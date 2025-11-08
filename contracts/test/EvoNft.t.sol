// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/EvoNFT.sol";
import "forge-std/Test.sol";

contract EvoNftTest is Test {
    EvoNFT public nft;
    address user = 0xBe729f2e3ad77d1AFF0945a4e417f39b49E3FA08; // ✅ no quotes!

    function setUp() public {
        nft = new EvoNFT();
    }

    function testMintNFT() public {

        vm.prank(user);

   
        nft.mintNFT("ipfs://Qmdsu9PHoKSs1jD47XZoDdTa3kGu4A4wKEim1cSNNogf1C");

        // ✅ Check if the counter increased
        assertEq(nft.nftCounter(), 1);

        // ✅ Check owner of tokenId 0
        assertEq(nft.ownerOf(0), user);

        // ✅ Check tokenURI (must match full URI you passed!)
        string memory uri = nft.tokenURI(0);
        assertEq(uri, "ipfs://Qmdsu9PHoKSs1jD47XZoDdTa3kGu4A4wKEim1cSNNogf1C");
    }
}
