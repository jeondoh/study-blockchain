// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.9.0;

/*
    게임규칙
    1. 1 이더만 내야함
    2. 중복해서 참여 불가(단, 누군가 적립금을 받으면 초기화)
    3. 관리자만 적립된 이더 볼 수 있음.
    4. 3의 배수 번째 사람에게만 적립 이더를 준다.
*/
contract MoneyBox {
    event WhoPaid(address indexed sender, uint256 payment);
    address owner;

    uint256 round = 1;
    // uint256 = round(key값)
    mapping (uint256 => mapping(address => bool)) paidMemberList;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.001 ether, "Must be 0.001 ether");
        require(paidMemberList[round][msg.sender] == false, "Must be a new player in each game");
        paidMemberList[round][msg.sender] = true;
        emit WhoPaid(msg.sender, msg.value);
        if(address(this).balance == 0.003 ether){
            // 스마트 컨트렉에 있는 이더리움을 3번째 사람에게 전달
            (bool sent, ) = payable(msg.sender).call{value:address(this).balance}("");
            require(sent, "Failed to pay");
            round++;
        }
    }

    function checkRound() public view returns(uint256){
        return round;
    }

    // 배포자만 볼수 있게
    function checkValue() public view returns(uint256){
        require(owner == msg.sender, "Only Owner can check the value");
        return address(this).balance;
    }


}