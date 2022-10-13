// SPDX-License-Identifier: GPL 3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint) public allowance;
    
    modifier onwerOrAllowed(uint _amount) {
        require(allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        allowance[_who] -= _amount;
    }
}

contract SimpleWallet is Allowance {
    function withdrawMoney(address payable _to, uint _amount) public onwerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "there are not enough funds stored in the smart contract");
        reduceAllowance(msg.sender, _amount);
        _to.transfer(_amount);
    }

    function sendMoney() external payable {

    }
}