// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
            let response := sub(x, y)
            if gt(response, x) {
                return(0x00, 0x20)
            }
            if gt(response, y) {
                return(0x00, 0x20)
            }
            mstore(0x00, response)
            return(0x00, 0x20)
        }
    }
}
