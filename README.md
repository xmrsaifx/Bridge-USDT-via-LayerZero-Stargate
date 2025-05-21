<h1>🌉 USDT Cross-Chain Bridge via Stargate</h1>

<p>This smart contract provides a simple interface to bridge <strong>USDT</strong> tokens to another chain using <strong>LayerZero's Stargate protocol</strong>. It supports fee estimation and token bridging from an EVM-compatible source chain (e.g., Ethereum, Arbitrum) to a destination chain (e.g., BSC).</p>

<hr>

<h2>⚙️ Features</h2>
<ul>
  <li>✅ Send USDT to another chain via Stargate</li>
  <li>✅ Estimate required native gas fee using Stargate's LayerZero fee quoting</li>
  <li>✅ Built-in approval and token transfer logic</li>
  <li>✅ Configurable router and USDT token addresses</li>
</ul>

<hr>

<h2>🧱 Built With</h2>
<ul>
  <li><strong>Solidity <code>^0.8.0</code></strong></li>
  <li><strong>Stargate Router Interface</strong></li>
  <li>Compatible with <strong>LayerZero Protocol</strong></li>
</ul>

<hr>

<h2>📁 Files</h2>
<ul>
  <li><code>Bridge.sol</code>: Main smart contract for bridging</li>
  <li><code>Interface/IStargate.sol</code>: Stargate router interface definition (import required)</li>
  <li><code>script/DeployBridge.s.sol</code>: Forge deployment script</li>
</ul>

<hr>

<h2>🔧 Deployment</h2>

<h3>🛠️ Using Foundry</h3>

<p>To deploy this contract on a network like Arbitrum using Foundry:</p>

<pre><code>forge script script/DeployBridge.s.sol:BridgeDeploy \
  --rpc-url $ARBITRUM_RPC_URL \
  --broadcast \
  --verify \
  -vvvv
</code></pre>

<h3>✅ Requirements</h3>

<ul>
  <li>Set your RPC URL in <code>.env</code> as <code>ARBITRUM_RPC_URL</code></li>
  <li>Set your Etherscan/Arbiscan API key in <code>foundry.toml</code></li>
  <li>Ensure you have a <code>DeployBridge.s.sol</code> script similar to:</li>
</ul>

<pre><code>// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Bridge.sol";

contract BridgeDeploy is Script {
    function run() external {
        vm.startBroadcast();

        address router = 0x...;     // Stargate Router address
        address usdt = 0x...;       // USDT token address

        new Bridge(router, usdt);

        vm.stopBroadcast();
    }
}
</code></pre>

<hr>

<h2>🚀 Usage</h2>

<h3>1. Estimate Cross-Chain Fee</h3>

<pre><code>(uint nativeFee, uint zroFee) = bridge.estimateFee(102); // Example: destination chain ID = 102
</code></pre>

<h3>2. Send USDT Across Chains</h3>

<pre><code>bridge.sendUSDT{value: nativeFee}(1000 * 1e6); // 1000 USDT (assuming 6 decimals)
</code></pre>

<hr>

<h2>📌 Notes</h2>

<ul>
  <li><code>102</code> is hardcoded as the destination chain ID (e.g., BSC). Modify as needed.</li>
  <li>Pool IDs (<code>2</code>) are currently hardcoded for USDT. You must confirm correct pool IDs for your network with <a href="https://stargate.finance/docs" target="_blank" rel="noopener noreferrer">Stargate Docs</a>.</li>
  <li>This contract bridges to the same wallet address on the destination chain.</li>
  <li>Only supports USDT and assumes it's ERC-20 compliant.</li>
</ul>

<hr>

<h2>🛡️ Security</h2>

<ul>
  <li>Always verify the correct Stargate router and USDT token addresses before deploying.</li>
  <li>Ensure the contract has proper token approval before calling <code>sendUSDT</code>.</li>
  <li><strong>Not audited</strong> — use in production at your own risk.</li>
</ul>

<hr>

<h2>📚 Resources</h2>

<ul>
  <li><a href="https://stargate.finance/docs" target="_blank" rel="noopener noreferrer">Stargate Documentation</a></li>
  <li><a href="https://docs.layerzero.network/" target="_blank" rel="noopener noreferrer">LayerZero Docs</a></li>
  <li><a href="https://book.getfoundry.sh/" target="_blank" rel="noopener noreferrer">Foundry Book</a></li>
</ul>

<hr>

<h2>📝 License</h2>

<p>This project is licensed under <strong>UNLICENSED</strong>. Not open source.</p>
