// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/Lesson13/DeFi1Fixed.sol";
import "../../src/Lesson13/Token.sol";

contract User {
    receive() external payable {}
}

contract DeFi1Test is Test {
    DeFi1Fixed internal defi;
    Token internal token;
    User internal alice;
    User internal bob;
    User internal chloe;
    uint256 internal initialAmount = 1000;
    uint256 internal blockReward = 5;

    function setUp() public {
        defi = new DeFi1Fixed(initialAmount, blockReward);
        token = Token(address(defi.token()));
        alice = new User();
        bob = new User();
        chloe = new User();
    }

    function testInitialBalance() public {
        assertEq(token.balanceOf(token.owner()), initialAmount);
    }

    function testAddInvestor() public {
        defi.addInvestor(address(alice));
        assert(defi.investors(address(alice)));
    }

    function testClaim() public {
        defi.addInvestor(address(alice));
        defi.addInvestor(address(bob));
        vm.prank(address(alice));
        vm.roll(1);
        defi.claimTokens();
    }

    function testCorrectPayoutAmount(uint256 blockNumber) public {
        defi.addInvestor(address(alice));

        uint256 initialBlock = defi.initialBlock();
        vm.assume(type(uint256).max - blockNumber > initialBlock);
        vm.assume(blockNumber > initialBlock);

        vm.roll(initialBlock + blockNumber);
        vm.startPrank(address(alice));

        uint256 payout = defi.calculatePayout();
        uint256 initialBalance = token.balanceOf(address(alice));

        defi.claimTokens();

        uint256 newBalance = token.balanceOf(address(alice));

        if ((blockNumber - initialBlock) / 1000 > 5) {
            assertEq(initialBalance, newBalance);
        } else {
            assertEq(initialBalance + payout, newBalance);
        }
    }

    function testAddingManyInvestors(uint8 numInvestors) public {
        for (uint8 i = 0; i < numInvestors; i++) {
            address investor = makeAddr("investor");
            defi.addInvestor(investor);
            assert(defi.investors(investor));
        }
    }

    function testAddingManyInvestorsAndClaiming(
        uint8 numInvestors,
        uint256 blockNumber
    ) public {
        uint256 initialBlock = defi.initialBlock();
        vm.assume(type(uint256).max - blockNumber > initialBlock);
        vm.assume(blockNumber > initialBlock);
        vm.roll(initialBlock + blockNumber);

        address[] memory investors = new address[](numInvestors);

        for (uint8 i = 0; i < numInvestors; i++) {
            investors[i] = makeAddr("investor");
            defi.addInvestor(investors[i]);
            assert(defi.investors(investors[i]));

            uint256 payout = defi.calculatePayout();
            uint256 initialBalance = token.balanceOf(investors[i]);
            vm.prank(investors[i]);
            defi.claimTokens();
            uint256 finalBalance = token.balanceOf(investors[i]);
            assertEq(finalBalance, initialBalance + payout);
        }
    }
}
