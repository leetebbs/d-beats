// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./DBeatsNFT.sol";

contract DBeatsFactory is Ownable, AccessControl {
    uint256 public tokenCounter;
    mapping(address => address[]) public nftsByCreator;

    // Define a new role identifier for the admin role
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    event NewNFT(
        address indexed nftAddress,
        address _initialOwner,
        address _artistAddress,
        string _newTokenURI,
        uint256 _mintAmount,
        string name,
        string symbol
    );

    constructor() Ownable(msg.sender) AccessControl() {
        // Grant the admin role to the contract deployer
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Function to add a user to a specific role
    function addUserToRole(bytes32 role, address account) public onlyOwner {
        grantRole(role, account);
    }

    function createNFT(
        address _initialOwner,
        address _artistAddress,
        string memory _newTokenURI,
        uint256 _mintAmount,
        string memory name,
        string memory symbol
    ) public {
        // Check that the caller has the admin role
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");

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
