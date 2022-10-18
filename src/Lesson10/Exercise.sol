// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lesson10Exercise {
    function div(uint256 _numerator, uint256 _denominator)
        public
        pure
        returns (uint256 result)
    {
        result = _numerator / _denominator;
    }

    function divAssembly(uint256 _numerator, uint256 _denominator)
        public
        pure
        returns (uint256 result)
    {
        assembly {
            result := div(_numerator, _denominator)
        }
    }
}
