// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Blendr_Token.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the BLENDR token with an initial supply of 1,000,000 tokens
        Blendr token = new Blendr(1000000);

        console.log("BLENDR deployed at:", address(token));

        vm.stopBroadcast();
    }
}