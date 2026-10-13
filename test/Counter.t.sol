// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Vault} from "../src/Counter.sol";

contract VaultTest is Test {
    Vault vault;
    address alice = address(0x1);

    function setUp() public {
        vault = new Vault();
        vm.deal(alice, 10 ether);
    }

    function testDeposit() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        assertEq(vault.balances(alice), 1 ether);
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSignature(
                "Error(string)",
                "Insufficient balance"
            )
        );
        vault.withdraw(2 ether);
    }

    function testWithdrawReturnsFunds() public {
        vm.prank(alice);
        vault.deposit{value: 2 ether}();

        uint256 balanceBefore = alice.balance;

        vm.prank(alice);
        vault.withdraw(1 ether);

        assertEq(vault.balances(alice), 1 ether);
        assertEq(alice.balance, balanceBefore + 1 ether);
    }

    function testReentrancyAttemptCannotStealFunds() public {
        ReentrantAttacker attacker = new ReentrantAttacker(vault);

        vm.deal(address(attacker), 1 ether);
        vm.deal(address(vault), 5 ether);

        vm.expectRevert();
        attacker.attack{value: 1 ether}();
    }
}

contract ReentrantAttacker {
    Vault public vault;
    uint256 public attackCount;

    constructor(Vault _vault) {
        vault = _vault;
    }

    function attack() external payable {
        vault.deposit{value: msg.value}();
        vault.withdraw(msg.value);
    }

    receive() external payable {
        if (attackCount < 1 && address(vault).balance >= 1 ether) {
            attackCount++;
            vault.withdraw(1 ether);
        }
    }
}