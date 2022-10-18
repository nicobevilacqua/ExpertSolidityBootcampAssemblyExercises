//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./Token.sol";

contract DeFi1Fixed {
    uint256 public initialBlock;
    mapping(address => bool) public investors;
    mapping(address => bool) public tokensClaimed;

    uint256 public initialAmount;
    uint256 public blockReward;

    Token public token;

    address public administrator;

    error AccessDenied();
    error TokensAlreadyClaimed();
    error InvestorAlreadyAdded();

    constructor(uint256 _initialAmount, uint256 _blockReward) {
        initialAmount = _initialAmount;
        token = new Token(_initialAmount);
        blockReward = _blockReward;
        initialBlock = block.number;
        administrator = msg.sender;
    }

    function addInvestor(address _investor) external {
        if (msg.sender != administrator) {
            revert AccessDenied();
        }

        if (investors[_investor]) {
            revert InvestorAlreadyAdded();
        }

        investors[_investor] = true;
    }

    function claimTokens() external {
        if (!investors[msg.sender]) {
            revert AccessDenied();
        }

        if (tokensClaimed[msg.sender]) {
            revert TokensAlreadyClaimed();
        }

        uint256 payout = calculatePayout();

        if (payout > 0) {
            tokensClaimed[msg.sender] = true;
            token.transfer(msg.sender, payout);
        }
    }

    function calculatePayout() public view returns (uint256) {
        uint256 timedRewardReduced = (block.number - initialBlock) / 1000;
        if (timedRewardReduced > blockReward) {
            return 0;
        }

        uint256 payout = blockReward - timedRewardReduced;

        if (token.balanceOf(address(this)) < payout) {
            return 0;
        }

        return payout;
    }
}
