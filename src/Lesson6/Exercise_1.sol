// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

/**
  1. Create a Solidity contract with one function
  The solidity function should return the amount of ETH that was passed to it, and the
  function body should be written in assembly
 */
contract Lesson6Exercise1 {
    function returnValue() external payable returns (uint256) {
        assembly {
            mstore(0x00, callvalue())
            return(0x00, 0x20)
        }
    }
}
