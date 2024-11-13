// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {DeployERC20Token} from "../script/DeployERC20Token.s.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

contract ERC20TokenTest is Test {
    ERC20Token public token;
    DeployERC20Token public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployERC20Token();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, token.balanceOf(bob));
    }

    function testTransfer() public {
        uint256 transferAmount = 10 ether;

        vm.prank(bob);
        token.transfer(alice, transferAmount);

        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(token.balanceOf(alice), transferAmount);
    }

    //Test for transfer exceeding balance (should fail)
    function testTransferExceedingBalance() public {
        uint256 transferAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSignature(
                "ERC20InsufficientBalance(address,uint256,uint256)", bob, STARTING_BALANCE, transferAmount
            )
        );
        token.transfer(alice, transferAmount);
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        //Bob approves Alice to spend token on his behalf
        vm.prank(bob);
        token.approve(alice, initialAllowance);

        uint256 transferAllowance = 500;

        vm.prank(alice);
        token.transferFrom(bob, alice, transferAllowance);

        assertEq(token.balanceOf(alice), transferAllowance);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAllowance);
    }
}
