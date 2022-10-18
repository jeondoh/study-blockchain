// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./SaleAnimalToken.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}

    SaleAnimalToken public saleAnimalToken;
    // key: animalTokenId, value: animalType
    mapping(uint256 => uint256) public animalTypes;

    struct AnimalTokenData {
        uint256 animalTokenId;
        uint256 animalType;
        uint256 animalPrice;
    }

    function mintAnimalToken() public {
        // totalSupply : 현재까지 민팅된 NFT 총량
        uint256 animalTokenId = totalSupply() + 1;
        // 난수 생성
        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1;
        animalTypes[animalTokenId] = animalType;
        // 토큰 발행(민팅)
        _mint(msg.sender, animalTokenId);
    }

    function getAnimalToken(address _animalTokenOwner) view public returns (AnimalTokenData[] memory) {
        // balanceOf : 지정한 주소의 잔액을 가져옴
        uint256 balanceLength = balanceOf(_animalTokenOwner);
        // 보유(민팅)한 토큰이 없을 경우 에러
        require(balanceLength != 0, "Owner doesn't have token");
        // 구조체 객체 생성
        AnimalTokenData[] memory animalTokenData = new AnimalTokenData[](balanceLength);
        // 소유자가 가지고 있는 토큰 목록을 AnimalTokenData 구조체에 넣음
        for(uint256 i = 0; i < balanceLength; i++) {
            // tokenOfOwnerByIndex : 소유자 토큰 목록의 지정된 인덱스에서 토큰 ID를 가져옴
            uint256 animalTokenId = tokenOfOwnerByIndex(_animalTokenOwner, i);
            uint256 animalType = animalTypes[animalTokenId];
            uint256 animalPrice = saleAnimalToken.getAnimalTokenPrice(animalTokenId);
            animalTokenData[i] = AnimalTokenData(animalTokenId, animalType, animalPrice);
        }
        return animalTokenData;
    }
    // 객체 초기화
    function setSaleAnimalToken(address _saleAnimalToken) public {
        saleAnimalToken = SaleAnimalToken(_saleAnimalToken);
    }
}
