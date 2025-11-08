// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract IdentitySBT is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    struct Identity {
        string username;
        uint256 joinDate;
        uint256 reputation;
        bool verified;
    }

    mapping(uint256 => Identity) public identities;
    mapping(address => uint256) private _ownerToTokenId;

    event IdentityCreated(address user, uint256 tokenId);
    event IdentityBurned(address user, uint256 tokenId);

    constructor() ERC721("IdentitySBT", "ISBT") Ownable(msg.sender) {}

    function safeMint(address to, string memory username) public onlyOwner {
        require(_ownerToTokenId[to] == 0, "User already has an SBT");

        uint256 tokenId = _tokenIdCounter + 1;
        _safeMint(to, tokenId);

        identities[tokenId] = Identity({
            username: username,
            joinDate: block.timestamp,
            reputation: 0,
            verified: false
        });

        _ownerToTokenId[to] = tokenId;
        _tokenIdCounter++;

        emit IdentityCreated(to, tokenId);
    }

    function burn() public {
        uint256 tokenId = _ownerToTokenId[msg.sender];
        require(tokenId != 0, "No SBT found");

        _burn(tokenId);
        delete _ownerToTokenId[msg.sender];
        delete identities[tokenId];

        emit IdentityBurned(msg.sender, tokenId);
    }

    function makeVerified() public payable {
        uint256 tokenId = _ownerToTokenId[msg.sender];
        require(tokenId != 0, "No SBT found");
        require(msg.value >= 0.01 ether, "Insufficient payment");

        identities[tokenId].verified = true;
    }

    function checkOwner(address user) public view returns (bool) {
        uint256 tokenId = _ownerToTokenId[user];
        return tokenId != 0 && ownerOf(tokenId) == user;
    }

    function getIdentity(address user) public view returns (Identity memory) {
        uint256 tokenId = _ownerToTokenId[user];
        require(tokenId != 0, "No SBT found");
        return identities[tokenId];
    }

    // Non-transferable SBT
    //     function _beforeTokenTransfer(
    //         address from,
    //         address to,
    //         uint256 firstTokenId,
    //         uint256 batchSize
    //     ) internal override {
    //         require(from == address(0) || to == address(0), "SBT: Non-transferable");
    //         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    //     }
    // }
}
