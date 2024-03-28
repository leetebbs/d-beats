// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC-721 contract for minting music NFTs
contract MusicNFT is ERC721, Ownable {
    uint256 public tokenIdCounter;

    struct Music {
        string name;
        string artistName;
        string musicUrl;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => Music) public musicNFTs;

    event MusicMinted(uint256 indexed tokenId, address indexed artist, string name, string artistName, string musicUrl, uint256 price);
    event MusicListed(uint256 indexed tokenId, uint256 price);
    event MusicSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor(address initialOwner) ERC721("Music NFT", "MUSIC") Ownable(initialOwner) {
        tokenIdCounter = 1;
    }

    function mintMusicNFT(string memory _name, string memory _artistName, string memory _musicUrl, uint256 _price) external returns (uint256) {
        uint256 tokenId = tokenIdCounter++; 
        _safeMint(msg.sender, tokenId);
        musicNFTs[tokenId] = Music(_name, _artistName, _musicUrl, _price, false);
        emit MusicMinted(tokenId, msg.sender, _name, _artistName, _musicUrl, _price);
        return tokenId;
    }

    function listMusicNFT(uint256 _tokenId, uint256 _price) external onlyOwner {
        musicNFTs[_tokenId].price = _price;
        musicNFTs[_tokenId].isListed = true;
        emit MusicListed(_tokenId, _price);
    }

    function buyMusicNFT(uint256 _tokenId) external payable {
        Music storage music = musicNFTs[_tokenId];
        require(music.isListed, "NFT is not listed for sale");
        require(msg.value >= music.price, "Insufficient funds");

        address payable seller = payable(ownerOf(_tokenId));
        seller.transfer(msg.value);
        _transfer(seller, msg.sender, _tokenId);
        music.isListed = false;
        emit MusicSold(_tokenId, msg.sender, seller, music.price);
    }

    function getMusicNFT(uint256 _tokenId) external view returns (string memory name, string memory artistName, string memory musicUrl, uint256 price, bool isListed) {
        address ownerAddress = ownerOf(_tokenId);
        require(ownerAddress != address(0), "Token does not exist");

        Music storage music = musicNFTs[_tokenId];
        return (music.name, music.artistName, music.musicUrl, music.price, music.isListed);
    }
}
