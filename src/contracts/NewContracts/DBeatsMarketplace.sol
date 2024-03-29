// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DBeatsMarketplace is ReentrancyGuard, Ownable {
    struct Listing {
        uint256 price;
        address seller;
        bool sold;
    }

    uint256 public _listingPrice = 0;
    uint256 public _platformPercentage = 10;
    address[] public nftAddresses;

    mapping(address => uint256[]) public tokenIds; // Array to keep track of token IDs for each NFT address

    mapping(address => mapping(uint256 => Listing)) public s_listings;
    mapping(address => uint256) public s_proceeds;

    // Define a custom error for incorrect price
    error IncorrectPrice(uint256 expected, uint256 received);

    event ItemListed(address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event ItemCanceled(address indexed nftAddress, uint256 indexed tokenId);
    event ItemBought(address indexed nftAddress, uint256 indexed tokenId, address indexed buyer, uint256 price);

    constructor() Ownable(msg.sender) {}

    function setPlatformFee(uint256 _newPlatformFee) public onlyOwner {
        _platformPercentage = _newPlatformFee;
    }

    function listItem(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    ) public payable {
        require(price > 0, "Price must be greater than 0");
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        nft.transferFrom(msg.sender, address(this), tokenId); // Transfer NFT to marketplace
        s_listings[nftAddress][tokenId] = Listing(price, msg.sender, false);
        tokenIds[nftAddress].push(tokenId);
        emit ItemListed(nftAddress, tokenId, price);
    }

    function cancelListing(address nftAddress, uint256 tokenId) public {
        require(s_listings[nftAddress][tokenId].seller == msg.sender, "Not the seller");
        IERC721 nft = IERC721(nftAddress);
        nft.transferFrom(address(this), msg.sender, tokenId); // Transfer NFT back to seller
        s_listings[nftAddress][tokenId].sold = true;
        emit ItemCanceled(nftAddress, tokenId);
    }

    function buyItem(address nftAddress, uint256 tokenId) public payable nonReentrant {
        require(s_listings[nftAddress][tokenId].sold == false, "Item already sold");
        Listing storage listing = s_listings[nftAddress][tokenId];
        if (listing.price != msg.value) {
            revert IncorrectPrice(listing.price, msg.value);
        }
        listing.sold = true;
        IERC721(nftAddress).transferFrom(address(this), msg.sender, tokenId);
        uint256 platformFee = msg.value * _platformPercentage / 100;
        uint256 sellerProceeds = msg.value - platformFee;
        payable(listing.seller).transfer(sellerProceeds);
        emit ItemBought(nftAddress, tokenId, msg.sender, msg.value);
    }

    function getPrice(address nftAddress, uint256 tokenId) public view returns (uint256) {
        require(s_listings[nftAddress][tokenId].sold == false, "Item already sold");
        return s_listings[nftAddress][tokenId].price;
    }

    function withdrawFunds() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
}
