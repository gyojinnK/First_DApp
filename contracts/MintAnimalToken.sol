// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// ERC721은 NFT 룰을 정의한 것이라 생각하자, NFT == ERC721 이라고 생각하자

contract MintAnimalToken is ERC721Enumerable {
    // constructor는 스마트컨트랙트가 실행될 때 한번 실행되는 코드
    constructor() ERC721("h662Animals", "HAS"){} 

    // 앞은 animalTokenId 뒤는 animalTypes
    // 즉, TokenId를 입력하면 animalType를 반환한다는 의미
    mapping(uint256 => uint256) public animalTypes;

    function mintAnimalToken() public {
        // totalSupply는 지급까지 발행된 NFT의 양을 반환
        // 만약 20개의 NFT가 발행되었다고 가정했을 때 다음 TokenID는 기존 Id와 달라야함 = NFT의 성질
        uint256 animalTokenId = totalSupply() + 1; 

        // 1~5까지의 랜덤한 수를 만들 때
        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1;
       
        animalTypes[animalTokenId] = animalType;

        // ERC721에서 제공하는 mint 함수
        // 첫번째 인자: msg.sender는 명령어를 실행한 사람 즉, mint를 액세스한 사람
        // 두번째 인자: animalTokenId는 유일값으로 갖고있는 NFT를 증명하는 id
        _mint(msg.sender, animalTokenId);
    }
}