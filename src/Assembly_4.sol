// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        // Modify state of the count variable from within
        // the assembly segment
        assembly {
            let _count := sload(count.slot)
            let newValue := add(_count, num)
            if gt(_count, newValue) {
                revert(0, 0)
            }
            if gt(num, newValue) {
                revert(0, 0)
            }
            sstore(count.slot, newValue)
        }
    }
}
