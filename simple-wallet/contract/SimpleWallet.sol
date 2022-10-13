// SPDX-License-Identifier: GPL 3.0

pragma solidity ^0.8.0;

import "./Allowance";

contract SimpleWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function renounceOwnership() public override onlyOwner {
        revert("Can't renouce ownership here");
    }

    function withdrawMoney(address payable _to, uint _amount) public onwerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "there are not enough funds stored in the smart contract");
        reduceAllowance(msg.sender, _amount);
        
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function sendMoney() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
} 