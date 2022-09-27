// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Add} from "../src/Assembly_2.sol";

contract Assembly1Test is Test {
    Add public add;

    function setUp() public {
        add = new Add();
    }

    function testAdd(uint256 _x, uint256 _y) public {
        uint256 expected;
        unchecked {
            expected = _x + _y;
        }
        if (expected < _x || expected < _y) {
            // overflow
            return;
        }
        uint256 response = add.addAssembly(_x, _y);
        assertEq(response, expected);
    }
}
