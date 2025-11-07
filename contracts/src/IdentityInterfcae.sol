// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IIdentitySBT {
    function hasIdentity(address user) external view returns (bool);
}