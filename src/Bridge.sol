// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {IStargateRouter} from "./Interface/IStargate.sol";

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

contract Bridge {
    address public immutable routerAddress;
    address public immutable baseToken; // USDT token address

    constructor(address _routerAddress, address _baseToken) {
        require(_routerAddress != address(0), "Router address cannot be zero");
        require(_baseToken != address(0), "Base token address cannot be zero");
        routerAddress = _routerAddress;
        baseToken = _baseToken;
    }

    function estimateFee(
        uint16 dstChainId
    ) public view returns (uint nativeFee, uint zroFee) {
        // lzTxObj contains optional params:
        // - dstGasForCall: gas to forward if calling contract on destination
        // - dstNativeAmount: amount of native token to drop
        // - dstNativeAddr: destination wallet for the native token
        IStargateRouter.lzTxObj memory lzParams = IStargateRouter.lzTxObj({
            dstGasForCall: 0,
            dstNativeAmount: 0,
            dstNativeAddr: abi.encodePacked(msg.sender) // address receiving native token (if any)
        });

        // functionType 1 = SEND
        return
            IStargateRouter(routerAddress).quoteLayerZeroFee(
                dstChainId,
                1, // functionType (1 = sendTokens, per Stargate's docs)
                abi.encodePacked(msg.sender),
                bytes(""),
                lzParams
            );
    }

    function sendUSDT(uint256 amount) external payable {
        require(amount > 0, "Amount must be greater than zero");

        (uint nativeFee, ) = estimateFee(102);
        require(msg.value >= nativeFee, "Insufficient native token fee");

        // Transfer USDT from the user to this contract
        bool success = IERC20(baseToken).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "USDT transfer failed");

        // Approve the router to spend USDT
        success = IERC20(baseToken).approve(routerAddress, amount);
        require(success, "Approve failed");

        // Call Stargate swap
        IStargateRouter(routerAddress).swap{value: msg.value}(
            102, // Destination chain ID (e.g., BSC)
            2, // Source pool ID
            2, // Destination pool ID
            payable(msg.sender), // Refund address for extra gas
            amount, // Amount in local decimals
            1, // Minimum amount to receive on destination
            IStargateRouter.lzTxObj(0, 0, "0x"), // Gas/airdrop params
            abi.encodePacked(msg.sender), // Recipient on destination chain
            bytes("") // Optional payload
        );
    }
}
