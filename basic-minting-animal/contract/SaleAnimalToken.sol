// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;
    
    constructor(address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }

    mapping(uint256 => uint256) public animalTokenPrices;
    // 현재 판매중인 animal array, FE와 연동
    uint256[] public onSaleAnimalTokenArray;

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        // ownerOf : 지정된 토큰 ID의 소유자를 가져옴
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(animalTokenOwner == msg.sender, "Caller is not animal token owner.");
        require(_price > 0, "Price is zero or lower.");
        require(animalTokenPrices[_animalTokenId] == 0, "This animal token is already on sale.");
        // isApprovedForAll : owner가 특정 계정에게 자신의 모든 NFT에 대한 사용을 허용했는지의 여부 반환
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal token owner did not approve token.");

        animalTokenPrices[_animalTokenId] = _price;
        onSaleAnimalTokenArray.push(_animalTokenId);
    }
}