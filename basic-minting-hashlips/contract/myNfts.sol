//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/*
    출처
    https://github.com/D-One0914/JustMintNFTsNow/blob/main/For_Ethereum_And_other_chains/myNfts.sol
*/

/*
특징
1. NFT 대량 민트
2. 프론트엔드 없이 NFT 판매

Ex) 발행한 스마트 컨트랙트 주소 : 0x265630755aDFB8896d6d7Cf0435B66926b60191E
    1. A가 0x265630755aDFB8896d6d7Cf0435B66926b60191E(발행한 스마트 컨트랙트 주소)에게 0.01 eth(현재 세팅한 가격만큼)전송한다.
    2. 0x265630755aDFB8896d6d7Cf0435B66926b60191E는 A에게 NFT를 발행한다.
    3. A는 15블록이후로 민트 가능하다.
    4. 배포자는 witdraw 함수로 판매된 NFT의 이더를 갖고 올 수 있다

NFT 발행 순서

1._baseURI함수에서 메타데이터(metadata) CID 추가
2. 컴파일 (ctrl+s)
3. DEPLOY & RUN TRANSACTIONS : Environment -> Injected Provider - Metamask 선택
4. CONTRACT -> myNFT 선택
5. myNFT의 아규먼트(argument) 넣어주기

    -_NAME : 토큰 이름 D_One'test_NFT
    -_SYMBOL : 토큰 심볼 D_One'test_NFT
    -_LIMIT : NFT 최대 발행 개수 10
    EX)
    첫번째 발행된 NFT의 id : 1 -> 메타데이터 1.json -> 그림 1.png
    두번째 발행된 NFT의 id : 2 -> 메타데이터 2.json -> 그림 2.png
        ...
    열번째 발행된 NFT의 id : 10 -> 메타데이터 10.json -> 그림 10.png
    limit = 10
    열한번째 발행된 NFT의 id : 11 -> 메타데이터 11.json -> 그림 11.png   -> X

    -_PRICE : NFT 판매 가격  10000000000000000
    1ETH = 10^18 / 0.1 eth = 10^17 / 0.01 eth = 10^16

    -_INTERVAL : NFT 민트 간격 (봇이 독점 방지) 15
        EX) 현재 블록 : 100
            간격 : 15 블록
            A -> 100번째 블록에서 NFT 민트(mint) -> 101~114 블록 민트 불가 ->115블록 부터 다시 NFT 민트(mint) 가능
            B -> 105번째 블록에서 NFT 민트(mint)
            (클레이튼 초당 1블록)

    -_REAVELINGBLOCK : 언제 NFT가 공개되는지 15
        EX) 현재 블록 : 100
            공개 시작 블록 : 15블록
            cvoer.js 파일에 있는 그림(NFT공개전 그림) -> 115 블록 -> 진짜 NFT 그림

    -_NOTREVELEDNFTURI : 진짜 NFT를 공개 하기전의 그림의 메타데이터 즉 Cover.js URI
        EX)  ipfs://YOUR_CID를 에서 YOUR_CID를 Cover.js의 CID로 변경하기.

6. Deploy 또는 transact 버튼 누르기

*/

contract myNFT is ERC721Enumerable, Ownable {

    error WaitForACoupleOfBlocks(uint tillBlock, uint currentBlock);
    error InsufficientValue(uint paidPrice, uint price);
    error OutOfNfts();
    error FailedToWithdraw();

    uint public limit;
    uint public latestId;
    uint public price;
    uint public interval;
    uint public revelingBlock;
    string public notReveledNFTURI;
    mapping(address=>uint) public NumberTracker;

    using Strings for uint;

    constructor(
        string memory _name,
        string memory _symbol,
        uint _limit,
        uint _price,
        uint _interval,
        uint _revelingBlock,
        string memory _notReveledNFTURI
    ) ERC721(_name, _symbol)
    {
        limit = _limit;
        price = _price;
        interval = _interval;
        revelingBlock = _revelingBlock + block.number;
        notReveledNFTURI = _notReveledNFTURI;
    }

    receive() external payable{
        mint();
    }

    function mint() public payable {
        if(NumberTracker[msg.sender] == 0 ? false : NumberTracker[msg.sender] + interval >= block.number) {
            revert WaitForACoupleOfBlocks(NumberTracker[msg.sender] + interval,block.number);
        }
        if(price != msg.value) {
            revert InsufficientValue(msg.value, price);
        }
        if(latestId>=limit) {
            revert OutOfNfts();
        }
        ++latestId;
        _safeMint(msg.sender,latestId);
        NumberTracker[msg.sender] = block.number;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        if(revelingBlock<=block.number){
            string memory baseURI = _baseURI();
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
        }else{
            return notReveledNFTURI;
        }


    }

    // Your_CID를 metadata CID로 변경해야 함
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmXdwYYEu438HQYNnMavEY8Kya3rAftBR64ZSM4ZxtghoF/";
    }

    // 리믹스 상에서 한번에 약 최대 250개 정도 가능
    // 원하는 유저에게 NFT를 줄 수 있음 (to : NFT를 받는 주소, _number : 몇개의 NFT를 줄것인지)
    function u_airdrop( address _to, uint _number) external onlyOwner() {
        if(latestId + _number>limit){
            revert OutOfNfts();
        }

        for(uint i; i < _number; ++i){
            ++latestId;
            _safeMint(_to,latestId);
        }
    }

    // 리믹스 상에서 한번에 약 최대 250개 정도 가능
    // ["유저주소", "유저주소2" ] 각 유저에게 한개씩 에어드랍.
    // ex) ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]
    function u_airdrop2(address[] calldata _to) external onlyOwner() {
        uint size = _to.length;
        if(latestId+size>limit) {
            revert OutOfNfts();
        }
        for(uint i; i < size; ++i){
            ++latestId;
            _safeMint(_to[i],latestId);
        }
    }

    //NFT 판매 가격 변경하는 함수
    function u_setPrice(uint _price) external onlyOwner()  {
        price = _price;
    }

    //NFT 민트할 수 있는 간격 정하는 함수
    function u_setInterval(uint _interval) external onlyOwner(){
        interval = _interval;
    }

    //NFT 실제 그림 몇 번째 블록에서 공개하는지 정하는 함수
    function u_setRevelingBlock(uint _revelingBlock) external onlyOwner(){
        revelingBlock = _revelingBlock + block.number;
    }

    //얼마후 NFT 실제 그림 공개하는지 보여주는 함수
    function u_whenToRevelNFTs() external view returns(uint) {
        return revelingBlock <= block.number  ? 0 : revelingBlock - block.number ;
    }

    // 현재 NFT 판매금액
    function u_currentBalance() external view returns(uint) {
        return address(this).balance;
    }

    // 판매금액 출금하기
    function u_withdraw() external onlyOwner() {
        (bool _result,) = address(msg.sender).call{value:address(this).balance}("");
        if(!_result) revert FailedToWithdraw();
    }

}
