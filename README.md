# 🌉 USDT Cross-Chain Bridge via Stargate

This smart contract provides a simple interface to bridge **USDT** tokens to another chain using **LayerZero's Stargate protocol**. It supports fee estimation and token bridging from an EVM-compatible source chain (e.g., Ethereum, Arbitrum) to a destination chain (e.g., BSC).

---

## ⚙️ Features

- ✅ Send USDT to another chain via Stargate
- ✅ Estimate required native gas fee using Stargate's LayerZero fee quoting
- ✅ Built-in approval and token transfer logic
- ✅ Configurable router and USDT token addresses

---

## 🧱 Built With

- **Solidity `^0.8.0`**
- **Stargate Router Interface**
- Compatible with **LayerZero Protocol**

---

## 📁 Files

- `Bridge.sol`: Main smart contract for bridging
- `Interface/IStargate.sol`: Stargate router interface definition (import required)
- `script/DeployBridge.s.sol`: Forge deployment script

---

## 🔧 Deployment

### 🛠️ Using Foundry

To deploy this contract on a network like Arbitrum using Foundry:

```bash
forge script script/DeployBridge.s.sol:BridgeDeploy \
  --rpc-url $ARBITRUM_RPC_URL \
  --broadcast \
  --verify \
  -vvvv
