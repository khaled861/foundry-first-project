// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "test/Mocks/MockV3Aggregator.sol";

contract HelperConfing is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public currnetConfig;

    constructor() {
        if (block.chainid == 11155111) {
            currnetConfig = getSepoliaConfig();
        }

        else {
            currnetConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() pure public returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaNetworkConfig;
    }

    function getAnvilConfig() public returns(NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator
            )});
        
        return anvilConfig;

    }
}