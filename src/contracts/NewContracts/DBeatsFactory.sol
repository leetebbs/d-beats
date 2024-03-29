// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DBeatsNFT.sol";

contract DBeatsFactory is Ownable {
    uint256 public tokenCounter;
    // Mapping to track NFTs created by each address
    mapping(address => address[]) public nftsByCreator;

    event NewNFT(
        address indexed nftAddress,
        address _initialOwner,
        address _artistAddress,
        string _newTokenURI,
        uint256 _mintAmount,
        string name,
        string symbol
    );

    constructor() Ownable(msg.sender) {} // pass msg.sender to the Ownable constructor

    function createNFT(
        address _initialOwner,
        address _artistAddress,
        string memory _newTokenURI,
        uint256 _mintAmount,
        string memory name,
        string memory symbol
    ) public onlyOwner {
        tokenCounter++;
        DBeatsNFT newNFT = new DBeatsNFT(
            _initialOwner,
            _artistAddress,
            _newTokenURI,
            _mintAmount,
            name,
            symbol
        );
        emit NewNFT(
            address(newNFT),
            _initialOwner,
            _artistAddress,
            _newTokenURI,
            _mintAmount,
            name,
            symbol
        );
        // Transfer ownership to the artist
        newNFT.transferOwnership(_artistAddress);
        // Store the NFT contract address in the mapping
        nftsByCreator[_artistAddress].push(address(newNFT));
    }

    // Function to get NFTs created by a specific address
    function getNFTsByCreator(address creator) public view returns (address[] memory) {
        return nftsByCreator[creator];
    }
}
