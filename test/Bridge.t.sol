// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Bridge} from "../src/Bridge.sol";

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

contract BridgeTest is Test {
    Bridge public bridge;
    address router = 0x53Bf833A5d6c4ddA888F69c22C88C9f356a41614;
    address usdt = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
    address owner = 0xE2F215BbD5C214AC79BB1315d05117673c1A7D7e;

    function setUp() public {
        bridge = new Bridge(router, usdt);
    }

    function test_Send() public {
        vm.startPrank(owner);
        IERC20(usdt).approve(address(bridge), 100000000);
        (uint nativeFee, ) = bridge.estimateFee(102);
        bridge.sendUSDT{value: nativeFee}(1);
    }
}
