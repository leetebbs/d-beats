// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DBeatsNFT.sol";

contract DBeatsFactory is Ownable {
    uint256 public tokenCounter;

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
        //transfer ownership to the artist
        newNFT.transferOwnership(_artistAddress);
    }
}
