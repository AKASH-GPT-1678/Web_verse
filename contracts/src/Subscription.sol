// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./IdentityInterfcae.sol";

contract Subscription {
    IIdentitySBT public identityContract;

    constructor(address _identity) {
        identityContract = IIdentitySBT(_identity);
    }
    modifier onlySBTowner() {
        require(identityContract.hasIdentity(msg.sender) , "User does not have an SBT");
        _;
        
    }

    uint256 public subscriptionId;

    
}
