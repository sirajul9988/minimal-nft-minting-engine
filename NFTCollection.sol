// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title NFTCollection
 * @dev High-performance ERC-721A implementation for gas-optimized batch minting.
 */
contract NFTCollection is ERC721A, Ownable {
    using Strings for uint256;

    string public baseURI;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.05 ether;

    constructor(string memory _initialBaseURI) ERC721A("Web3 Dev Collection", "WDC") Ownable(msg.sender) {
        baseURI = _initialBaseURI;
    }

    function mint(uint256 quantity) external payable {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Reached max supply");
        require(msg.value >= MINT_PRICE * quantity, "Insufficient ETH sent");
        _safeMint(msg.sender, quantity);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}
