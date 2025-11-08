// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EvoNFT is ERC721URIStorage, Ownable {
    constructor() ERC721("EvoNFT", "ENFT") Ownable(msg.sender) {}


    uint public nftCounter; // ✅ fixed spelling

    function mintNFT(string memory tokenURI) public {
        uint newItemId = nftCounter;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        nftCounter++;
    }
}
