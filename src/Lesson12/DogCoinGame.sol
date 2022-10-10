// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4; // @audit floating pragma version
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DogCoinGame is ERC20 {
    uint256 public currentPrize; // @audit unused variable
    uint256 public numberPlayers; // @audit can be removed and use players.length instead
    address payable[] public players;
    address payable[] public winners;

    event startPayout();

    constructor() ERC20("DogCoin", "DOG") {} // @audit why is it a token?

    function addPlayer(address payable _player) public payable {
        // @audit-issue player added should be msg.sender and not _player
        if (msg.value == 1) {
            players.push(_player);
        } // @audit-issue num players would increment even though player has not paid the required ether
        numberPlayers++; // @audit use players.length instead
        if (numberPlayers > 200) {
            // @audit-issue numPlayers should be 201 or higher and not 200 like the specification
            emit startPayout();
        }
    }

    function addWinner(address payable _winner) public {
        // @audit why you need to save the winners instead of send an array and pay immediatly?
        // @audit-issue anyone can call addWinner
        winners.push(_winner);
    }

    function payout() public {
        if (address(this).balance == 100) {
            // @audit-issue balance wouldn't be 100 if 200 players have paid 1 ether to join the game
            uint256 amountToPay = winners.length / 100;
            payWinners(amountToPay);
        }
    }

    function payWinners(uint256 _amount) public {
        // @audit-issue anyone can call this function and send an arbitrary amount of ether to winners
        // for (uint256 i = 0; i <= winners.length; i++) { // @audit-issue wrong for condition, fixed for testing purposes
        for (uint256 i = 0; i < winners.length; i++) {
            winners[i].send(_amount); // @audit-issue deprecated .send function used. Use a .call() instead
        }
    }
}
