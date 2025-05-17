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

## ⚙️ How It Works

The `SmartDefiApp` protocol is composed of a single smart contract designed to simplify and standardize token swaps and liquidity interactions on EVM-compatible blockchains. Below is a breakdown of the components and their responsibilities:

---

### 🧩 Smart Contracts Overview

| Contract | Description |
|----------|-------------|
| [`SmartDefiApp`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/SmartDefiApp.sol) | Core contract of the protocol. Handles token swaps (ERC-20 and ETH), single- and dual-token liquidity provisioning, and liquidity removal. Uses a Uniswap V2-compatible router under the hood. |
| [`IRouterV2`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IRouterV2.sol) | Interface used to interact with external routers such as Uniswap V2 or SushiSwap. Supports swapping, adding, and removing liquidity. |
| [`IFactory`](https://github.com/aflores255/LiquidityPoolsApp/blob/master/src/interfaces/IFactory.sol) | Interface for querying LP token pair addresses from a Uniswap V2-compatible factory. Used during liquidity operations. |

### 🔗 External Dependencies

- **Router**: [Arbitrum RouterV2](https://arbiscan.io/address/0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24) – used for executing swaps and managing liquidity
- **Factory**: [Arbitrum Factory](https://arbiscan.io/address/0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9) – used to locate LP token addresses
- **Tokens**: Supports USDC, USDT, DAI, and WETH on Arbitrum One
- **OpenZeppelin Contracts**: [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- **Foundry**: [Foundry](https://book.getfoundry.sh/)

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

## 🚀 Deployment & Usage

This section explains how to interact with the `SmartDefiApp` smart contract deployed on the **Arbitrum One** network. It covers how to perform token swaps, add and remove liquidity, and provides a real transaction example to follow.

🔗 **Deployed Contract:** [0xcc0029c0109b12b108f1c3bce5bdc1dcec6ced9c on Arbiscan](https://arbiscan.io/address/0xcc0029c0109b12b108f1c3bce5bdc1dcec6ced9c)

---

### 🔁 How to Swap Tokens

To swap one token for another using `SmartDefiApp`:

1. Go to the [Write Contract tab on Arbiscan](https://arbiscan.io/address/0xcc0029c0109b12b108f1c3bce5bdc1dcec6ced9c#writeContract) and connect your wallet (make sure it's on Arbitrum One).
2. Approve the contract to spend your token using the token’s own contract (via `approve(spender, amount)`).
3. Call `swapExactTokensForTokens` with:
   - `amountIn_`: amount of tokens to swap (e.g. `1500000` for 1.5 USDC)
   - `amountOutMin_`: minimum amount of output tokens accepted
   - `path_`: array of token addresses (e.g. `[USDC, USDT]`)
   - `to_`: your wallet address
   - `deadline_`: Unix timestamp (e.g. `block.timestamp + 600`)

✅ Example: Swap 1.5 USDC → USDT  
- `amountIn_`: `1500000`  
- `amountOutMin_`: `1400000`  
- `path_`: `[0xaf88d065e77c8cC2239327C5EDb3A432268e5831, 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9]`  
- `to_`: your wallet address  
- `deadline_`: current time + 10 minutes

---

### 💧 How to Add Liquidity

To provide liquidity to a token pair (e.g. USDT/DAI):

1. Approve the contract to spend both tokens.
2. Use `addLiquidityFromTwoTokens` with:
   - `amountA_` and `amountB_`: amounts of each token
   - `tokenA_` and `tokenB_`: token addresses
   - `amountAMin_` and `amountBMin_`: slippage tolerances
   - `deadline_`: timestamp deadline

You can also use `addLiquidityFromOneToken` to deposit one token and have the contract split and convert it to form a pair automatically.

---

### 🧼 How to Remove Liquidity

To remove liquidity and receive your underlying tokens:

1. Use `removeLiquidity` with:
   - `tokenA_` and `tokenB_`: the token pair
   - `liquidity_`: amount of LP tokens to withdraw
   - `amountAMin_`, `amountBMin_`: minimum tokens to receive
   - `to_`: your address
   - `deadline_`: timestamp

Make sure you've approved the contract to spend your LP tokens.

---

### 📦 Real Example Transaction

Here is a real transaction on Arbitrum using this contract to swap tokens:

🔹 [Tx Hash: 0x392aaee3eeb91cf43de2b3df107bde1d8893d4210adc63f490e192adf9f91d0c](https://arbiscan.io/tx/0x392aaee3eeb91cf43de2b3df107bde1d8893d4210adc63f490e192adf9f91d0c)  
- Swapped: 0.0005 WETH → 1.23 USDT  
- Path: `[WETH, USDT]`  
- User: `0x...`  
- Contract: `SmartDefiApp`

---

You can interact with the contract directly via Arbiscan or through a front-end interface that supports contract method encoding and Web3 wallet interaction (e.g. Etherscan, Remix, or your custom dApp).

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

## 📄 License

This project is licensed under the **MIT License**.
