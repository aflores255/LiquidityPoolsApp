# 🔁 SmartDefiApp

## 📌 Description

**SmartDefiApp** is a Solidity smart contract that allows users to swap between ERC-20 tokens and ETH, as well as provide and remove liquidity using a Uniswap V2-compatible router. It supports major DeFi operations like token swaps, ETH conversions, and liquidity management in a secure and efficient way.

Built with **Solidity 0.8.28**, this contract uses OpenZeppelin's `SafeERC20` for secure token interactions and includes a comprehensive **Foundry** test suite, tested on **Arbitrum One**.

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

---

## 🔗 Dependencies

- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Foundry](https://book.getfoundry.sh/)
- [`IRouterV2.sol`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IRouterV2.sol)
- [`IFactory.sol`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IFactory.sol)

---

## 🛠️ How to Use

### 🔧 Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Access to the **Arbitrum One** network
- Wallet with ETH and supported tokens (USDC, USDT, DAI)

---

### 🧪 Run Tests

```bash
forge test
```

---

### 🚀 Deployment

1. Clone the repository:

```bash
git clone https://github.com/aflores255/SmartDefiApp.git
cd SmartDefiApp
```

2. Deploy the contract:

```solidity
new SmartDefiApp(router, factory, usdt, usdc, dai);
```

Use valid addresses for the router, factory, and token contracts.

---

## 📄 License

This project is licensed under the **MIT License**.
