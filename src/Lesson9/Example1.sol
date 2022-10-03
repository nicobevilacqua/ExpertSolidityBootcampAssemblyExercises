// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lesson9Example1 {
    uint256 private rand1 = block.timestamp;

    function random(uint256 Max) public view returns (uint256 result) {
        uint256 rand2 = Max / rand1;
        return rand2 % Max;
    }
}
