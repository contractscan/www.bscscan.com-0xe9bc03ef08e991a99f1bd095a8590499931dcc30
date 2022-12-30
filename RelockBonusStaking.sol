// SPDX-License-Identifier: ISC

pragma solidity ^0.8.0;

import "./Initializable.sol";
import "./ERC20PresetMinterPauser.sol";
import "./OwnableUpgradeable.sol";
import "./SafeERC20.sol";
import "./TaxedStaking.sol";
import "./StaticFixedTimeLockStaking.sol";

contract RelockBonusStaking is StaticFixedTimeLockStaking {
    uint256 public relockBonus;

    function __RelockBonusStaking_init_unchained(uint256 _relockBonus) public onlyInitializing {
        relockBonus = _relockBonus;
    }

    function relock() external {
        require(block.timestamp >= locks[msg.sender], "LockPeriodHasNotEnded");
        locks[msg.sender] = block.timestamp + lockTime;
        uint256 bonusAmount = (_balances[msg.sender] * relockBonus) / 10_000;
        allocateBonus(address(this), bonusAmount);
        _balances[msg.sender] += bonusAmount;
        _totalSupply += bonusAmount;
    }

    function setRelockBonus(uint256 _relockBonus) public onlyRole(DEFAULT_ADMIN_ROLE) {
        relockBonus = _relockBonus;
    }

    function allocateBonus(address account, uint256 amount) internal virtual {}

    uint256[50] private __gap;
}