# 🔁 SmartDefiApp -  A DeFi Protocol for Token Swaps and Liquidity Management on EVM Chains

## 📌 Description

**SmartDefiApp** is a smart contract designed to simplify and unify core DeFi operations such as token swaps and liquidity management, using a Uniswap V2-compatible router. It enables users to swap between ERC-20 tokens and ETH, provide liquidity using either one or two tokens, and remove liquidity with full control over slippage and deadlines — all from a single, streamlined interface.

The contract supports major stablecoins like USDC, USDT, and DAI by default, making it well-suited for real-world use cases and integrations with other protocols. Its logic handles the complexities of token approvals, routing, and safe transfers under the hood, so developers can focus on building user-facing applications without reinventing swap or liquidity flows.

Built in **Solidity 0.8.28**, SmartDefiApp leverages OpenZeppelin’s `SafeERC20` for secure token handling and is fully tested on **Arbitrum One** using the **Foundry** framework. It’s a modular, gas-efficient base for any dApp, aggregator, or DeFi tool aiming to interact with liquidity pools in a reliable and extensible way.

---

## 🚀 Features

| **Feature**              | **Description**                                                |
|--------------------------|----------------------------------------------------------------|
| 🔄 **Token ↔ Token Swaps**  | Swap ERC-20 tokens via customizable paths.                     |
| 🌐 **ETH ↔ Token Swaps**    | Seamlessly convert between ETH and tokens.                     |
| 💧 **Liquidity Management** | Add/remove liquidity using one or two tokens.                 |
| 🛡️ **Secure Transfers**     | Utilizes `SafeERC20` from OpenZeppelin for secure operations. |
| 🧪 **Foundry Test Suite**   | Comprehensive test coverage using real tokens and addresses.  |
| 📡 **Event Logging**        | Emits events for every operation, including liquidity removal.|

---

## 📜 Contract Details

### ⚙️ Constructor

```solidity
constructor(address RouterV2Address_, address FactoryAddress_, address USDT_, address USDC_, address DAI_)
```

Initializes the contract with the router and factory addresses, and the supported stablecoins (USDT, USDC, DAI).

---

### 🔧 Functions

| **Function**                 | **Description**                                                       |
|------------------------------|------------------------------------------------------------------------|
| `swapExactTokensForTokens`   | Swaps a fixed amount of tokens for a minimum output.                  |
| `swapTokensForExactTokens`   | Swaps tokens to receive a fixed output.                               |
| `swapExactETHForTokens`      | Swaps a fixed amount of ETH for tokens.                               |
| `swapTokensForExactETH`      | Swaps tokens to receive a fixed amount of ETH.                        |
| `swapExactTokensForETH`      | Swaps a fixed amount of tokens for ETH.                               |
| `addLiquidityFromOneToken`   | Adds liquidity using a single token (splitting and swapping).         |
| `addLiquidityFromTwoTokens`  | Adds liquidity using both tokens directly.                            |
| `removeLiquidity`            | Removes liquidity and returns token balances.                         |

---

### 📡 Events

| **Event**              | **Description**                          |
|------------------------|------------------------------------------|
| `SwapERC20Tokens`      | Emitted on token-to-token swap.          |
| `SwapETHForTokens`     | Emitted on ETH-to-token swap.            |
| `SwapTokensForETH`     | Emitted on token-to-ETH swap.            |
| `AddLiquidity`         | Emitted after liquidity is added.        |
| `RemoveLiquidity`      | Emitted after liquidity is removed.      |

---

---

### 🔑 Modifiers

| **Modifier**              | **Description**                          |
|------------------------|------------------------------------------|
| `validPairs`      | Ensures the pair is composed of valid stablecoins.          |

---

## 🧪 Testing with Foundry

All swap and liquidity functions are thoroughly tested with **Foundry** using real user addresses and tokens on the **Arbitrum One** mainnet.

### ✅ Implemented Tests

| **Test**                               | **Description**                                      |
|----------------------------------------|------------------------------------------------------|
| `testInitialDeploy`                    | Validates contract initialization.                  |
| `testSwapExactTokensForTokens`         | Token-to-token swap with fixed input.               |
| `testSwapTokensForExactTokens`         | Token-to-token swap with fixed output.              |
| `testSwapExactTokensForETH`            | Token-to-ETH swap with fixed input.                 |
| `testSwapTokensForExactETH`            | Token-to-ETH swap with fixed output.                |
| `testSwapExactETHForTokens`            | ETH-to-token swap with fixed input.                 |
| `testAddLiquidityFromOneToken`         | Liquidity addition using one token.                 |
| `testAddLiquidityFromTwoTokens`        | Liquidity addition using two tokens.                |
| `testRemoveLiquidity`                  | Tests removal of liquidity.                         |
| `testIncorrectSwapExactETHForTokens`   | Ensures function reverts with 0 ETH input.          |
| `testIncorrectPairAddLiquidity*`       | Ensures validation of token pair constraints.       |
| `testIncorrectAmountAddLiquidity*`     | Ensures non-zero amount validation.                 |

### 🧪 Run Tests

```bash
forge test
```

### 📊 Coverage Report

| File                    | % Lines         | % Statements     | % Branches      | % Functions     |
|-------------------------|------------------|-------------------|------------------|------------------|
| `src/SmartDefiApp.sol` | 100.00% (67/67) | 100.00% (62/62) | 100.00% (10/10) | 100.00% (11/11)   |

---

## 🔗 Dependencies

- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Foundry](https://book.getfoundry.sh/)
- [`IRouterV2.sol`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IRouterV2.sol)
- [`IFactory.sol`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IFactory.sol)

---

## 📄 License

This project is licensed under the **MIT License**.
