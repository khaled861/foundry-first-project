// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundMetest is Test {
    FundMe fundMe;
    address user = makeAddr("User");

    // deploys the contract
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, 10 ether);
    }

    modifier funded {
        vm.prank(user);
        fundMe.fund{value: 10e18}();
        _;
    }


    function testMinimumDollarValue() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMesnager() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }


    function testsInterfaceVersion() public view {
        uint256 version = fundMe.getVersion();

        assertEq(version, 4);
    }

    function testFundFailWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public funded {
        uint256 balence = fundMe.getAddressToAmountFunded(user);
        assertEq(balence, 10e18);

    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, user);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(user);
        fundMe.fund{value: 10e18}();
        vm.expectRevert();
        fundMe.withdraw();
    }


    function testWithdrawWithSingleFunder() public funded {
        uint256 stratingFundMeFunds = address(fundMe).balance;
        uint256 startingOwnerFunds = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingFundMeFunds = address(fundMe).balance;
        uint256 endingOwnerFunds = fundMe.getOwner().balance;

        assertEq(endingFundMeFunds, 0);
        assertEq(startingOwnerFunds + stratingFundMeFunds, endingOwnerFunds);

    }


    function testwithDrawFromManyFunders() public {
        uint256 funders = 10;

        for(uint160 i = 1; i < funders; i++) {
            hoax(address(i), 10e18);
            fundMe.fund{value: 10e18}();
        }

        uint256 startingFundMeFunds = address(fundMe).balance;
        uint256 startingOwnerFunds = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();


        uint256 endingFundMefunds = address(fundMe).balance;
        uint256 endingOwnerFunds = fundMe.getOwner().balance;

        assert(endingFundMefunds == 0);
        assert(startingOwnerFunds + startingFundMeFunds == endingOwnerFunds);
        

        
    }



    function testwithDrawFromManyFundersCheaper() public {
        uint256 funders = 10;

        for(uint160 i = 1; i < funders; i++) {
            hoax(address(i), 10e18);
            fundMe.fund{value: 10e18}();
        }

        uint256 startingFundMeFunds = address(fundMe).balance;
        uint256 startingOwnerFunds = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();


        uint256 endingFundMefunds = address(fundMe).balance;
        uint256 endingOwnerFunds = fundMe.getOwner().balance;

        assert(endingFundMefunds == 0);
        assert(startingOwnerFunds + startingFundMeFunds == endingOwnerFunds);
        

        
    }

}