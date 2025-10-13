// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ImmutableSimple {
    uint256 immutable stored;

    constructor() {
        stored = 7;
    }

    function readStored() external view returns (uint256) {
        return stored;
    }
}
