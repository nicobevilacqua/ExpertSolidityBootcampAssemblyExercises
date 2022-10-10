// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {BrokenSea} from "../../src/Lesson12/BrokenSea.sol";

contract BrokenSeaTest is Test {
    address private owner;
    address private hacker;

    BrokenSea private brokenSea;

    function setUp() public {
        owner = makeAddr("owner");
        hacker = makeAddr("hacker");

        vm.prank(owner);
        brokenSea = new BrokenSea();
    }

    function testBrokenSea() public {}
}
