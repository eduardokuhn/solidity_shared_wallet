// SPDX-License-Identifier: GPL-3.0

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "./Allowance.sol";

pragma solidity ^0.8.11;

contract SimpleWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint256 _amount);
    event MoneyReceived(address indexed _from, uint256 _amount);

    function withdrawMoney(address payable _to, uint256 _amount)
        public
        ownerOrAllowed(_amount)
    {
        require(
            _amount <= address(this).balance,
            "There aren't enough funds stored in the smart contract"
        );
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public pure override {
        revert("Can't renounce ownership here");
    }

    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    receive() external payable {}
}
