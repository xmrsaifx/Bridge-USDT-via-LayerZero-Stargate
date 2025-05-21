// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Bridge} from "../src/Bridge.sol";

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

contract BridgeDeploy is Script {
    Bridge public bridge;
    address router = 0x53Bf833A5d6c4ddA888F69c22C88C9f356a41614;
    address usdt = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        bridge = new Bridge(router, usdt);

        console.log("Bridge deployed at:", address(bridge));
        (uint nativeFee, ) = bridge.estimateFee(102);
        console.log("Estimated fee:", nativeFee);
        IERC20(usdt).approve(address(bridge), 366970);
        bridge.sendUSDT{value: nativeFee}(366970);
        vm.stopBroadcast();
    }
}
