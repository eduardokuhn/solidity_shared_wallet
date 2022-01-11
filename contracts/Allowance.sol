// SPDX-License-Identifier: GPL-3.0

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

pragma solidity ^0.8.11;

contract Allowance is Ownable {
    using SafeMath for uint256;

    event AllowanceChanged(
        address indexed _forWhom,
        address indexed _fromWhom,
        uint256 _oldAmount,
        uint256 _newAmount
    );

    mapping(address => uint256) public allowance;

    modifier ownerOrAllowed(uint256 _amount) {
        require(
            isOwner() || allowance[msg.sender] >= _amount,
            "Your aren't allowed"
        );
        _;
    }

    function isOwner() public view virtual returns (bool) {
        return msg.sender == owner();
    }

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint256 _amount) internal {
        emit AllowanceChanged(
            _who,
            msg.sender,
            allowance[_who],
            allowance[_who].sub(_amount)
        );
        allowance[_who] = allowance[_who].sub(_amount);
    }
}
