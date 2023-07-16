// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;

    constructor (address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }

    // animalToken을 입력하면 가격을 반환하는 mapping
    mapping(uint256 => uint256) public animalTokenPrices;

    // 프론트엔드에서 이 배열을 가지고 어떤게 판매 중인지 확인
    uint256[] public onSaleAnimalTokenArray;

    // 판매 등록 함수 
    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        // 제공하는 ownerOf()를 통해 tokenId로 address를 받아옴
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        // animalTokenOwner가 mint를 액세스한 사람이 맞는지 확인
        // 만약 다르다면 Error, 뒤 문자열 출력
        require(animalTokenOwner == msg.sender, "Caller is not animal token owner.");   
        require(_price > 0, "Price is zero or lower");
        require(animalTokenPrices[_animalTokenId] == 0, "This animal Token is already on sale.");

        //isApprovedForAll(주인, 현재 컨트랙트의 스마트컨트랙트)
        // 주인이 판매 계약을 넘겼는지 확인하는 구문
        // 이상한 컨트랙트는 아닌지 확인하는 절차
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal token owner did not approve token");
    
        animalTokenPrices[_animalTokenId] = _price;
        onSaleAnimalTokenArray.push(_animalTokenId);
    }

    // 구매 함수
    // payable을 명시해야 매틱이 오고감
    function purchaseAnimalToken(uint256 _animalTokenId) public payable  {
        uint256 price = animalTokenPrices[_animalTokenId];
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);
        require(price > 0, "Animal token not sale.");
        // msg.value는 구매 함수를 실행 할 때 보내는 매틱의 양
        require(price <= msg.value, "Caller sent lower than price.");
        require(animalTokenOwner != msg.sender, "Caller is animal token owner.");

        // msg.value는 매틱의 양
        // msg.sender의 msg.value 즉, sender의 구매 가격 만큼의 양이 animalTokenOwner에게 전달된다. 
        payable(animalTokenOwner).transfer(msg.value);

        // NFT 카드를 보내는 구문
        // safeTransferFrom(보내는 사람, 받는 사람, 보내는 것);
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner, msg.sender, _animalTokenId);

        // mapping 끊기 
        // 판매되었으므로 0원으로 초기화
        animalTokenPrices[_animalTokenId] = 0;

        for(uint256 i = 0; i < onSaleAnimalTokenArray.length; i++){
            // 0원으로 초기화시킨 인덱스를 찾아 제거하는 if문
            if(animalTokenPrices[onSaleAnimalTokenArray[i]] == 0){
                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length -1];
                onSaleAnimalTokenArray.pop();
            }
        }
    }

    // 프론트엔드에서 사용할 데이터 -> 배열의 길이 return
    function getOnSaleAnimalTokenArrayLength() view public returns (uint256) {
        return onSaleAnimalTokenArray.length;
    }
}