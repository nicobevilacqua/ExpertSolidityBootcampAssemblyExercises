// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {Lesson6Exercise1} from "../../src/Lesson6/Exercise_1.sol";

contract Assembly1Test is Test {
    Lesson6Exercise1 public lesson6Exercise1;

    function setUp() public {
        lesson6Exercise1 = new Lesson6Exercise1();
    }

    function testLesson6Exercise1(uint256 _value) public {
        console2.log("llegue aca");
        console2.log(address(this).balance);
        if (_value > address(this).balance) {
            return;
        }
        uint256 returned = lesson6Exercise1.returnValue{value: _value}();
        console2.log(_value, returned);
        assertEq(_value, returned);
    }

    function testLesson6ExerciseSingleValue() public {
        uint256 value = 1.1 ether;
        uint256 returned = lesson6Exercise1.returnValue{value: value}();
        assertEq(value, returned);
    }
}
