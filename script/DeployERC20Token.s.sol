// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

contract DeployERC20Token is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (ERC20Token) {
        vm.startBroadcast();
        ERC20Token erc20Token = new ERC20Token(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return erc20Token;
    }
}
