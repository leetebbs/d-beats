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
        // Add the tokenId to the tokenIds array for the NFT address
        tokenIds[nftAddress].push(tokenId);
        emit ItemListed(nftAddress, tokenId, price);
    }

    function cancelListing(address nftAddress, uint256 tokenId) public {
        require(s_listings[nftAddress][tokenId].seller == msg.sender, "Not the seller");
        s_listings[nftAddress][tokenId].sold = true;
        IERC721 nft = IERC721(nftAddress);
        nft.transferFrom(address(this), msg.sender, tokenId); // Transfer NFT back to seller
        emit ItemCanceled(nftAddress, tokenId);
    }

    function buyItem(address nftAddress, uint256 tokenId) public payable nonReentrant {
        Listing storage listing = s_listings[nftAddress][tokenId];
        require(listing.price == msg.value, "Incorrect price");
        require(!listing.sold, "Item already sold");
        listing.sold = true;
        IERC721 nft = IERC721(nftAddress);
        nft.transferFrom(address(this), msg.sender, tokenId); // Transfer NFT to buyer

        // Calculate the platform fee
        uint256 platformFee = msg.value * _platformPercentage / 100;
        uint256 sellerProceeds = msg.value - platformFee;

        // Send the platform fee to the marketplace contract
        payable(address(this)).transfer(platformFee);

        // Send the remainder to the seller
        payable(listing.seller).transfer(sellerProceeds);

        emit ItemBought(nftAddress, tokenId, msg.sender, msg.value);
    }

    function getAllListings() public view returns (Listing[] memory) {
        uint256 totalListings = 0;
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            address nftAddress = nftAddresses[i];
            totalListings += tokenIds[nftAddress].length;
        }

        Listing[] memory listings = new Listing[](totalListings);
        uint256 index = 0;
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            address nftAddress = nftAddresses[i];
            for (uint256 j = 0; j < tokenIds[nftAddress].length; j++) {
                uint256 tokenId = tokenIds[nftAddress][j];
                if (!s_listings[nftAddress][tokenId].sold) {
                    listings[index] = s_listings[nftAddress][tokenId];
                    index++;
                }
            }
        }

        return listings;
    }

    function withdrawFunds() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
}
