//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

//3. Interface

interface IRouterV2 {
    /**
     * @notice Swaps an exact amount of input tokens for as many output tokens as possible.
     * @param amountIn The exact amount of input tokens to send.
     * @param amountOutMin The minimum amount of output tokens to receive.
     * @param path Array of token addresses representing the swap path.
     * @param to Address to receive the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts Array of input and output amounts for each step of the swap.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    /**
     * @notice Swaps tokens to receive an exact amount of output tokens.
     * @param amountOut The exact amount of output tokens desired.
     * @param amountInMax The maximum amount of input tokens to spend.
     * @param path Array of token addresses representing the swap path.
     * @param to Address to receive the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts Array of input and output amounts for each step of the swap.
     */
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    /**
     * @notice Swaps ETH for as many output tokens as possible.
     * @param amountOutMin The minimum amount of output tokens to receive.
     * @param path Array of token addresses representing the swap path (must start with WETH).
     * @param to Address to receive the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts Array of ETH and output token amounts for the swap.
     */
    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
        external
        payable
        returns (uint256[] memory amounts);

    /**
     * @notice Swaps tokens to receive an exact amount of ETH.
     * @param amountOut The exact amount of ETH desired.
     * @param amountInMax The maximum amount of tokens to spend.
     * @param path Array of token addresses representing the swap path.
     * @param to Address to receive the ETH.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts Array of input and output amounts for each step of the swap.
     */
    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    /**
     * @notice Swaps an exact amount of tokens for as much ETH as possible.
     * @param amountIn The exact amount of input tokens to send.
     * @param amountOutMin The minimum amount of ETH to receive.
     * @param path Array of token addresses representing the swap path.
     * @param to Address to receive the ETH.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts Array of input token and ETH amounts.
     */
    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    /**
     * @notice Adds liquidity to a token pair.
     * @param tokenA Address of token A.
     * @param tokenB Address of token B.
     * @param amountADesired Amount of token A to add.
     * @param amountBDesired Amount of token B to add.
     * @param amountAMin Minimum amount of token A to add (slippage protection).
     * @param amountBMin Minimum amount of token B to add (slippage protection).
     * @param to Address to receive the LP tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amountA Amount of token A actually added.
     * @return amountB Amount of token B actually added.
     * @return liquidity Amount of LP tokens minted.
     */
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    /**
     * @notice Removes liquidity from a token pair.
     * @param tokenA Address of token A.
     * @param tokenB Address of token B.
     * @param liquidity Amount of LP tokens to burn.
     * @param amountAMin Minimum amount of token A to receive.
     * @param amountBMin Minimum amount of token B to receive.
     * @param to Address to receive the underlying tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amountA Amount of token A returned.
     * @return amountB Amount of token B returned.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);
}
