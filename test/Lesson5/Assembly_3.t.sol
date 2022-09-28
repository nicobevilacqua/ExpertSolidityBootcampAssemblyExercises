// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {SubOverflow} from "../../src/Lesson5/Assembly_3.sol";

contract Assembly1Test is Test {
    SubOverflow public subOverflow;

    function setUp() public {
        subOverflow = new SubOverflow();
    }

    function testSubOverflow(uint256 _x, uint256 _y) public {
        uint256 expected;
        unchecked {
            expected = _x - _y;
        }
        uint256 response = subOverflow.subtract(_x, _y);
        if (_y > _x) {
            assertEq(response, 0);
            return;
        }
        assertEq(response, expected);
    }
}
