// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Scope} from "../src/Assembly_4.sol";

contract Assembly1Test is Test {
    Scope public scope;

    function setUp() public {
        scope = new Scope();
    }

    function testIncrement(uint256 _x) public {
        uint256 expected;
        uint256 count = scope.count();
        unchecked {
            expected = count + _x;
        }
        if (expected < count || expected < _x) {
            return;
        }
        scope.increment(_x);
        assertEq(scope.count(), expected);
    }
}
