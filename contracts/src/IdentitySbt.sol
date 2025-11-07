// SPDX-Licencese-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IdentitySBT is ERC721, Ownable, ERC721URIStorage {
    constructor() ERC721("IdentitySBT", "ISBT") {}

    uint private _tokenIdCounter;
    struct Identity {
        string username;
        uint256 joinDate;
        uint256 reputation;
    }

    mapping(uint256 => Identity) public identities;
    mapping(address => boolean) public hasIdentity;

    function beforetokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(
            _ownerOf(tokenId) == from,
            "Only the owner can transfer the token"
        );
        super.beforetokenTransfer(from, to, tokenId);
    }

    function safeMint(address to) public onlyOwner {
            require(!hasIdentity[to], "User already has an SBT");
        _mint(to, _tokenIdCounter);

    
        _tokenIdCounter++;
    }

    function burn(uint256 tokenId) public {
        require(msg.sender == ownerOf(tokenId), "BRN01");
        _burn(tokenId);
    }
}
