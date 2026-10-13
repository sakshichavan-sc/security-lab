Vault Security Lab

A beginner smart contract security project built with Solidity and Foundry.

Overview

This project implements a simple ETH vault that allows users to deposit and withdraw funds while tracking individual balances.

Security concepts explored

- Deposit accounting
- Preventing withdrawals beyond the caller's recorded balance
- Verifying ETH transfers
- Checks-Effects-Interactions pattern
- Testing a reentrancy attempt

Tests

Run the test suite:

forge test -vv

The current test suite covers:

1. "testDeposit" — verifies deposit accounting.
2. "testCannotWithdrawMoreThanBalance" — checks rejection of excessive withdrawals.
3. "testWithdrawReturnsFunds" — verifies balance updates and ETH transfers.
4. "testReentrancyAttemptCannotStealFunds" — exercises a reentrant withdrawal attempt.

Current result

All four tests pass in the local Foundry test environment.

Learning note

Passing tests provide evidence about the specific scenarios tested; they do not establish that a contract is fully secure. Further work should include fuzz testing, invariant testing, and additional adversarial cases.

Tools

- Solidity
- Foundry
- Forge
- Git