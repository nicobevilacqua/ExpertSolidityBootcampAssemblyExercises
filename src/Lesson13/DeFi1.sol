//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13; // @audit-issue remove floating pragma

import "./Token.sol";

contract DeFi1 {
    uint256 initialAmount = 0; // @audit-info unnecesary initialization
    address[] public investors;
    uint256 blockReward = 0; // @audit-info unnecesary initialization
    Token public token;

    constructor(uint256 _initialAmount, uint256 _blockReward) {
        initialAmount = initialAmount; // @audit-issue wrong initialization
        token = new Token(_initialAmount);
        blockReward = _blockReward;
    }

    function addInvestor(address _investor) public {
        // @audit-issue open public function (should be restricted to administrator only)
        investors.push(_investor);
    }

    function claimTokens() public {
        // @audit-issue open public function (should be restricted to investors only)
        bool found = false;
        uint256 payout = 0;

        for (uint256 ii = 0; ii < investors.length; ii++) {
            // @audit-issue use an auxiliar mapping to validate that msg.sender is an investor
            if (investors[ii] == msg.sender) {
                found = true;
            } else {
                found = false;
            }
        }
        if (found == true) {
            calculatePayout();
        }

        token.transfer(msg.sender, payout); // @audit-issue use safeTransfer instead
        // @audit-issue transaction will fail if contract has not enough tokens for payout
    }

    function calculatePayout() public returns (uint256) {
        // @audit-issue user can claim same reward multiple times
        // @audit-issue should be private
        uint256 payout = 0;
        uint256 blockReward = blockReward; // @audit-issue declaration shadows storage value
        blockReward = block.number % 1000; // @audit-issue this calculation is wrong
        payout = initialAmount / investors.length;
        payout = payout * blockReward;
        blockReward--;
        return payout;
    }
}
