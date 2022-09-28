// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Intro} from "../../src/Lesson5/Assembly_1.sol";

contract Assembly1Test is Test {
    Intro public intro;

    function setUp() public {
        intro = new Intro();
    }

    function testIntro() public {
        uint256 param = 420;
        uint16 response = intro.intro();
        assertEq(response, uint16(param));
    }
}
