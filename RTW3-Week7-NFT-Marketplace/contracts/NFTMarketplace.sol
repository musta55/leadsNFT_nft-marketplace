//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extentions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
    // Global variables

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private itemSold;

    address payable owner;

    uint256 listPrice = 0.01 ether;

    // Constructor
    constructor() public ERC721("NFTMarketplace", "NFTM") {
        owner = msg.sender;
    }

    // ListedToken Structure
    struct ListedToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    event TokenListedSuccess(
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        bool currentlylisted
    );

    mapping(unit256 => ListedToken) private idToListedToken;

    // Create NFT

    function createToken(
        string memory tokenURI,
        unit256 price
    ) public payalbe returns (uni256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        createListedToken(newTokenId, price);

        return newTokenId;
    }

    function createListedToken(uint256 tokenId, uint256 price) private {
        require(msg.value == listPrice, "Please pay the currect price");
        require(msg.value > 0, "male sure the price isn't negative");

        idListedToken[tokenId] = ListedToken(
            tokenId,
            payable(address(this)),
            payable(msg.sender),
            price,
            true
        );
        _transfer(msg.sender, address(this), tokenId);
        emit TokenListedSuccess(
            tokenId,
            address(this),
            msg.sender,
            price,
            currentlylisted
        );
    }

    // Get NFT
    function getAllNFTs() public view returns (ListedToken[] memory) {
        unit256 nftCount = _tokenIds.current();
        ListedToken[] memory tokens = new ListedToken[](nftCount);
        uint256 currentIndex = 0;

        for (int i = 0; i < nftCount; i++) {
            uint256 currentId = i + 1;
            ListedToken storage currentItem = idToListedToken(currentId);
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return tokens;
    }

    function getMyNFTs() public view returns (ListedToken[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 currentIndex = 0;

        for (int i = 0; i < totalItemCount; i++) {
            if (
                idToListedToken[i + 1].owner == msg.sender ||
                idToListedToken[i + 1].seller == msg.sender
            ) {
                itemCount += 1;
            }
        }

        ListedToken[] memory items = new ListedToken[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {
            if (
                idToListedToken[i + 1].owner == msg.sender ||
                idToListedToken[i + 1].seller == msg.sender
            ) {
                uint currentId = i + 1;
                ListedToken storage currentItem = idToListedToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }
    // Buy NFT
    //If the user has paid enough ETH equal to the price of the NFT, the NFT gets transferred to the new address and the proceeds of the sale are sent to the seller

    function executeSale (uint256 tokenId) public payable {
        uint256 price  =  idToListedToken[tokenId].price;
        address seller = idToListedToken[tokenId].seller;

        require(msg.value == price,"Please submit the asking price to buy this NFT");

        idToListedToken[tokenId].currentlyListed = true;
        idToListedToken[tokenId].seller = payable (msg.sender);
        _itemsSold.increment();

        _transfer(address(this), msg.sender, tokenId);

        approve(address(this), tokenId);

        payable(owner).transfer(listPrice);
        payable(seller).transfer(msg.value);
    }

    // Helper Function

    function updatelistPrice (unit256 _listPrice) public payable {
        require (owner == msg.sender, "Only owner can update listing price");
        listPrice = _listPrice;
    }

    function getListPrice () public view returns (uint256 ) {
        return listprice;
    }

    function getLatestIdToListedToken() public view returns (ListedToken memory) {
        unit256 currenttokenId  = _tokenIds.current();
        return idToListedToken[currenttokenId];
    }

    function getListedTokenforId(unit256 tokenId) public view returns (ListedToken) {
        return idToListedToken[tokenId];
    }

    function getCurrentToken() public view returns (uint256) {
        return _tokenIds.current();
    }
}
