// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DbeatNFTMarketplace is ERC721Holder {
    using SafeMath for uint256;

    address payable public owner;
    uint256 public platformFeePercentage; // Platform fee percentage (5%)
    mapping(uint256 => uint256) public tokenIdToPrice;

    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor() {
        owner = payable(msg.sender);
        platformFeePercentage = 5; // Default platform fee percentage
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function updatePlatformFee(uint256 _newFeePercentage) external onlyOwner {
        require(_newFeePercentage <= 100, "Fee percentage cannot exceed 100%");
        platformFeePercentage = _newFeePercentage;
    }

    function listNFT(address _nftContract, uint256 _tokenId, uint256 _price) external {
        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "You are not the owner of this NFT");
        require(_price > 0, "Price must be greater than zero");

        tokenIdToPrice[_tokenId] = _price;
        nft.safeTransferFrom(msg.sender, address(this), _tokenId);
        emit NFTListed(_tokenId, msg.sender, _price);
    }

    function buyNFT(address _nftContract, uint256 _tokenId) external payable {
        IERC721 nft = IERC721(_nftContract);
        uint256 price = tokenIdToPrice[_tokenId];
        require(price > 0, "NFT is not listed for sale");

        uint256 platformFee = (price.mul(platformFeePercentage)).div(100);
        uint256 sellerAmount = price.sub(platformFee);

        require(msg.value >= price, "Insufficient funds");

        address payable seller = payable(nft.ownerOf(_tokenId));
        seller.transfer(sellerAmount);

        // Transfer platform fee to the owner of the marketplace
        owner.transfer(platformFee);

        nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        delete tokenIdToPrice[_tokenId];
        emit NFTSold(_tokenId, msg.sender, seller, price);
    }

    function withdrawBalance() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function getPlatformFee() external view returns (uint256) {
        return platformFeePercentage;
    }
}

