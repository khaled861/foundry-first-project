// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {FundMe} from "src/fundMe.sol";
import {HelperConfing} from "script/HelperConfig.s.sol";


contract DeployFundMe is Script {
    function run() external returns(FundMe) {
        HelperConfing helperConfig = new HelperConfing();
        address priceFeed = helperConfig.currnetConfig();
        
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}