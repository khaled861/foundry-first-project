// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {FundMe} from "../src/fundMe.sol";
import {FundFundMe} from "script/Interactions.s.sol";


contract FundFundMeTest is Test {
    FundMe fundMe;
    address user = makeAddr("User");
    uint256 constant SEND_VALUE = 1 ether;

    // deploys the contract
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, 10 ether);
    }

    function testFundFundMe() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 10 ether);

        uint256 startingFundFundMeBalance = address(fundFundMe).balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        fundFundMe.fundFundMe(address(fundMe));

        uint256 endingFundFundMebalance = address(fundFundMe).balance;
        uint256 endingFundMeBalance = address(fundMe).balance;


        assert(endingFundFundMebalance == 0);
        assert(startingFundMeBalance + startingFundFundMeBalance == endingFundMeBalance);
    }
}

