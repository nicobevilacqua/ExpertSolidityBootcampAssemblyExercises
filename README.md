# Expert Solidity Bootcamp Exercises

Collection of exercises and solution from Septemer Encode's expoert solidity bootcamp.

* Homework 1
* Homework 2
* Homework 3
* Homework 4
* Homework 5
* [Homework 9](#homework-9)
* [Homework 13](#homework-13)


## Homework 9

### 1. How can the use of `tx.origin` in a contract be exploited?
If a contract uses tx.origin for authentication/user validation then you can impersonate him by following these steps:
  1. Create an intermediate contract with a method calling your target contract/method.
  2. Do some social engineering and make the user that you want to impersonate to call your contract sending a transaction.
  3. Your contract will call the contract to be exploited impersonating the user.

### 2. What do you understand by event spoofing?
### 3. What problems can you find in this [contract](./src/Lesson9/Example1.sol) designed to produce a random number.
  1. `block.timestamp` is not a good source of randomness.
  2. Private stored variables can be accesed anyway.
  3. There is no real randomness source. Random number can be reproduced.
  4. `block.timestamp` can be manipulated by validators/miners.
### 4. What problems are there in this [contract](./src/Lesson9/Example2.sol)
  1. A student can be added multiple times to the array.
  2. `startingNumber` is not necessary, students.length can be returned instead.
  3. Students can be added after `welcomeStudents` is called.
  4. `teacher` should be constant (or even better, be an immutable and be initialized on construction time)
  5. An event should be added to `joinCurse` for better tracking.
  6. Bot functions can be changed to `external`.
  7. Explicitly visibility should be added to storage variables.
  8. Event names should be on CamelCase, and should be a verb in past. (on this case, StudentWelcomed would be a better name for that event)
  9. Message is not being sent to the students. The implementation is wrong.


## Homework 10

### 1. Why are negative numbers more expensive to store than positive numbers?
### 2. Test the following statements in Remix, which is cheaper and why ? Assume that the demoninator can never be zero
  1. 
  ```
  result = numerator / denominator;
  ``` 
  vs 
  ```
  assembly { result := div(numerator, denominator) }
  ```


## Homework 13

1. Investigate this [project](./src//Lesson13/DeFi1.sol)

Imagine you have been given the DeFi1 contract by a colleague and asked to test it
using Foundry.

Your colleague explains that the contract allows

* investors to be added by the administrator
* investors to claim tokens, but the amount that they can claim should reduce
every 1000 blocks.

When testing make sure you know

* how would you advance blocks
* how would you make sure every block will work
* how would you make sure the contract works with different starting values such
as
  - block reward
  - numbers of investors
  - initial number of tokens

Try to find all the bugs / security problems / optimisation opportunities in the
contract.

You do not need to fix the code.