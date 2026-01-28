// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/SovereignRescue.sol";

contract SovereignRescueTest is Test {
    SovereignRescue rescue;
    address safeExit = address(0xDEADBEEF);

    function setUp() public {
        rescue = new SovereignRescue(safeExit);
    }

    function test_PanicEth() public {
        vm.deal(address(rescue), 1 ether);
        address[] memory tokens = new address[](0);
        
        rescue.panic(tokens);
        assertEq(safeExit.balance, 1 ether);
    }
}
