//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

import "./interfaces/IRouterV2.sol";
import "./interfaces/IFactory.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

//3. Contract

contract SmartDefiApp {
    using SafeERC20 for IERC20;

    //Variables
    address public RouterV2Address;
    address USDC;
    address USDT;
    address DAI;
    address public FactoryAddress;

    //Events

    event SwapERC20Tokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapETHForTokens(address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapTokensForETH(address tokenIn, uint256 amountIn, uint256 amountOut);
    event AddLiquidity(address tokenA, address tokenB, uint256 lpTokenAmount);
    event RemoveLiquidity(address tokenA, address tokenB, uint256 amountTokenA, uint256 amountTokenB);

    //Modifiers

    modifier validPairs(address tokenA, address tokenB) {
        require(tokenA != tokenB, "Tokens must be different");
        bool isTokenAValid = (tokenA == USDT || tokenA == USDC || tokenA == DAI);
        bool isTokenBValid = (tokenB == USDT || tokenB == USDC || tokenB == DAI);
        require(isTokenAValid && isTokenBValid, "Tokens must be StableCoin");
        _;
    }

    /**
     * @notice Initializes the contract with required addresses.
     * @param RouterV2Address_ Address of the DEX router.
     * @param FactoryAddress_ Address of the DEX factory.
     * @param USDT_ Address of USDT token.
     * @param USDC_ Address of USDC token.
     * @param DAI_ Address of DAI token.
     */
    constructor(address RouterV2Address_, address FactoryAddress_, address USDT_, address USDC_, address DAI_) {
        RouterV2Address = RouterV2Address_;
        FactoryAddress = FactoryAddress_;
        USDC = USDC_;
        USDT = USDT_;
        DAI = DAI_;
    }

    /**
     * @notice Swaps an exact amount of input tokens for as many output tokens as possible.
     * @param amountIn_ Amount of input tokens to send.
     * @param amountOutMin_ Minimum amount of output tokens expected.
     * @param path_ Swap path (array of token addresses).
     * @param to_ Recipient address for the output tokens.
     * @param deadline_ Unix timestamp after which the transaction will revert.
     * @return exactAmountOut Amount of tokens received.
     */
    function swapExactTokensForTokens(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] memory path_,
        address to_,
        uint256 deadline_
    ) public returns (uint256 exactAmountOut) {
        //Get first Token
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        //Approve
        IERC20(path_[0]).approve(RouterV2Address, amountIn_);
        //Swap
        uint256[] memory amountsOut_ =
            IRouterV2(RouterV2Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, to_, deadline_);

        emit SwapERC20Tokens(path_[0], path_[path_.length - 1], amountIn_, amountsOut_[amountsOut_.length - 1]);
        return amountsOut_[amountsOut_.length - 1];
    }

    /**
     * @notice Swaps tokens for an exact amount of another token.
     * @param amountOut_ Exact amount of output tokens desired.
     * @param amountInMax_ Maximum amount of input tokens to spend.
     * @param path_ Swap path.
     * @param deadline_ Deadline for the swap.
     */
    function swapTokensForExactTokens(
        uint256 amountOut_,
        uint256 amountInMax_,
        address[] memory path_,
        uint256 deadline_
    ) external {
        // Get First Token MaxIn
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountInMax_);
        //Approve
        IERC20(path_[0]).approve(RouterV2Address, amountInMax_);

        uint256[] memory amounts_ =
            IRouterV2(RouterV2Address).swapTokensForExactTokens(amountOut_, amountInMax_, path_, msg.sender, deadline_);

        emit SwapERC20Tokens(path_[0], path_[path_.length - 1], amounts_[0], amountOut_);
    }

    /**
     * @notice Swaps ETH for as many output tokens as possible.
     * @param amountOutMin_ Minimum amount of tokens to receive.
     * @param path_ Swap path (starts with WETH).
     * @param deadline_ Deadline for the swap.
     */
    function swapExactETHForTokens(uint256 amountOutMin_, address[] memory path_, uint256 deadline_) external payable {
        require(msg.value > 0, "Incorrect amount");
        uint256[] memory amounts_ = IRouterV2(RouterV2Address).swapExactETHForTokens{value: msg.value}(
            amountOutMin_, path_, msg.sender, deadline_
        );

        emit SwapETHForTokens(path_[path_.length - 1], msg.value, amounts_[amounts_.length - 1]);
    }

    /**
     * @notice Swaps tokens for an exact amount of ETH.
     * @param amountOut_ Exact amount of ETH desired.
     * @param amountInMax_ Maximum input tokens to spend.
     * @param path_ Swap path.
     * @param deadline_ Deadline for the transaction.
     */
    function swapTokensForExactETH(uint256 amountOut_, uint256 amountInMax_, address[] memory path_, uint256 deadline_)
        external
    {
        // Get First Token MaxIn
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountInMax_);
        // Approve
        IERC20(path_[0]).approve(RouterV2Address, amountInMax_);

        uint256[] memory amounts_ =
            IRouterV2(RouterV2Address).swapTokensForExactETH(amountOut_, amountInMax_, path_, msg.sender, deadline_);

        emit SwapTokensForETH(path_[0], amounts_[0], amountOut_);
    }

    /**
     * @notice Swaps an exact amount of tokens for ETH.
     * @param amountIn_ Amount of tokens to send.
     * @param amountOutMin_ Minimum amount of ETH to receive.
     * @param path_ Swap path.
     * @param deadline_ Deadline for the swap.
     */
    function swapExactTokensForETH(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, uint256 deadline_)
        external
    {
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[0]).approve(RouterV2Address, amountIn_);

        uint256[] memory amounts =
            IRouterV2(RouterV2Address).swapExactTokensForETH(amountIn_, amountOutMin_, path_, msg.sender, deadline_);

        emit SwapTokensForETH(path_[0], amountIn_, amounts[amounts.length - 1]);
    }

    /**
     * @notice Adds liquidity using a single token that is split and swapped to form a pair.
     * @param amountIn_ Total amount of input token to use.
     * @param amountOutMin_ Minimum output expected from swap.
     * @param path_ Swap path to obtain the second token.
     * @param tokenA_ First token in the pair.
     * @param tokenB_ Second token in the pair.
     * @param amountAMin_ Minimum amount of tokenA to add.
     * @param amountBMin_ Minimum amount of tokenB to add.
     * @param deadline_ Deadline for the transaction.
     * @return lpTokenAmount_ Amount of LP tokens received.
     */
    function addLiquidityFromOneToken(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] memory path_,
        address tokenA_,
        address tokenB_,
        uint256 amountAMin_,
        uint256 amountBMin_,
        uint256 deadline_
    ) external validPairs(tokenA_, tokenB_) returns (uint256 lpTokenAmount_) {
        require(amountIn_ > 0, "Amount must be above zero");
        uint256 halfAmount = amountIn_ / 2;

        IERC20(tokenA_).safeTransferFrom(msg.sender, address(this), halfAmount);

        // First step, swap tokens
        uint256 exactAmountOut = swapExactTokensForTokens(halfAmount, amountOutMin_, path_, address(this), deadline_);

        lpTokenAmount_ =
            approveAndAddLiquidity(tokenA_, tokenB_, halfAmount, exactAmountOut, amountAMin_, amountBMin_, deadline_);
        return lpTokenAmount_;
    }

    /**
     * @notice Adds liquidity using two token amounts directly.
     * @param amountA_ Amount of token A to add.
     * @param amountB_ Amount of token B to add.
     * @param tokenA_ Address of token A.
     * @param tokenB_ Address of token B.
     * @param amountAMin_ Minimum accepted amount of token A.
     * @param amountBMin_ Minimum accepted amount of token B.
     * @param deadline_ Deadline for the transaction.
     * @return lpTokenAmount_ Amount of LP tokens received.
     */
    function addLiquidityFromTwoTokens(
        uint256 amountA_,
        uint256 amountB_,
        address tokenA_,
        address tokenB_,
        uint256 amountAMin_,
        uint256 amountBMin_,
        uint256 deadline_
    ) external validPairs(tokenA_, tokenB_) returns (uint256 lpTokenAmount_) {
        require(amountA_ > 0 && amountB_ > 0, "Amount must be above zero");
        IERC20(tokenA_).safeTransferFrom(msg.sender, address(this), amountA_);
        IERC20(tokenB_).safeTransferFrom(msg.sender, address(this), amountB_);
        lpTokenAmount_ =
            approveAndAddLiquidity(tokenA_, tokenB_, amountA_, amountB_, amountAMin_, amountBMin_, deadline_);
        return lpTokenAmount_;
    }

    /**
     * @notice Removes liquidity from a token pair.
     * @param tokenA_ First token of the pair.
     * @param tokenB_ Second token of the pair.
     * @param liquidity_ Amount of LP tokens to burn.
     * @param amountAMin_ Minimum amount of token A to receive.
     * @param amountBMin_ Minimum amount of token B to receive.
     * @param to_ Recipient of the underlying tokens.
     * @param deadline_ Deadline for the transaction.
     */
    function removeLiquidity(
        address tokenA_,
        address tokenB_,
        uint256 liquidity_,
        uint256 amountAMin_,
        uint256 amountBMin_,
        address to_,
        uint256 deadline_
    ) external {
        //Get Pair Address
        address lpTokenAddress = IFactory(FactoryAddress).getPair(tokenA_, tokenB_);
        //Transfer LP Tokens to Contract
        IERC20(lpTokenAddress).safeTransferFrom(msg.sender, address(this), liquidity_);
        //Approve LP Tokens
        IERC20(lpTokenAddress).approve(RouterV2Address, liquidity_);
        (uint256 amountTokenA_, uint256 amountTokenB_) = IRouterV2(RouterV2Address).removeLiquidity(
            tokenA_, tokenB_, liquidity_, amountAMin_, amountBMin_, to_, deadline_
        );
        emit RemoveLiquidity(tokenA_, tokenB_, amountTokenA_, amountTokenB_);
    }

    /**
     * @param tokenA_ Address of token A.
     * @param tokenB_ Address of token B.
     * @param amountA_ Amount of token A.
     * @param amountB_ Amount of token B.
     * @param amountAMin_ Minimum accepted amount of token A.
     * @param amountBMin_ Minimum accepted amount of token B.
     * @param deadline_ Deadline for the transaction.
     * @return lpTokenAmount_ Amount of LP tokens received.
     */
    function approveAndAddLiquidity(
        address tokenA_,
        address tokenB_,
        uint256 amountA_,
        uint256 amountB_,
        uint256 amountAMin_,
        uint256 amountBMin_,
        uint256 deadline_
    ) internal returns (uint256 lpTokenAmount_) {
        IERC20(tokenA_).approve(RouterV2Address, amountA_);
        IERC20(tokenB_).approve(RouterV2Address, amountB_);

        (,, uint256 lpTokenAmount) = IRouterV2(RouterV2Address).addLiquidity(
            tokenA_, tokenB_, amountA_, amountB_, amountAMin_, amountBMin_, msg.sender, deadline_
        );

        emit AddLiquidity(tokenA_, tokenB_, lpTokenAmount);
        return lpTokenAmount;
    }
}
