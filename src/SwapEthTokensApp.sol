//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

import "./interfaces/IRouterV2.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

//3. Contract

contract SwapEthTokensApp {
    using SafeERC20 for IERC20;

    //Variables
    address public RouterV2Address;
    address USDC;
    address USDT;
    address DAI;
    
    //Events

    event SwapERC20Tokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapETHForTokens(address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapTokensForETH(address tokenIn, uint256 amountIn, uint256 amountOut);
    event AddLiquidity(address tokenA, address tokenB, uint256 lpTokenAmount);

    //Modifiers

    modifier validPairs(address tokenA, address tokenB){
        require(tokenA != tokenB,"Tokens must be different");
        bool isTokenAValid = (tokenA == USDT || tokenA == USDC || tokenA == DAI);
        bool isTokenBValid = (tokenB == USDT || tokenB == USDC || tokenB == DAI);
        require(isTokenAValid && isTokenBValid, "Tokens must be StableCoin");
        _;
    }

    //Constructor

    constructor(address RouterV2Address_, address USDT_, address USDC_, address DAI_) {
        RouterV2Address = RouterV2Address_;
        USDC = USDC_;
        USDT = USDT_;
        DAI = DAI_;
    }

    // 1. Swap exact tokens for tokens
    function swapExactTokensForTokens(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] memory path_,
        uint256 deadline_
    ) public returns(uint256 exactAmountOut){
        //Get first Token
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        //Approve
        IERC20(path_[0]).approve(RouterV2Address, amountIn_);
        //Swap
        uint256[] memory amountsOut_ =
            IRouterV2(RouterV2Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);

        emit SwapERC20Tokens(path_[0], path_[path_.length - 1], amountIn_, amountsOut_[amountsOut_.length - 1]);
        return amountsOut_[amountsOut_.length - 1];
    }

    // 2. Swap Tokens for Exact Tokens

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

    // 3. Swap Exact Eth for Tokens
    function swapExactETHForTokens(uint256 amountOutMin_, address[] memory path_, uint256 deadline_) external payable {
        require(msg.value > 0, "Incorrect amount");
        uint256[] memory amounts_ = IRouterV2(RouterV2Address).swapExactETHForTokens{value: msg.value}(
            amountOutMin_, path_, msg.sender, deadline_
        );

        emit SwapETHForTokens(path_[path_.length - 1], msg.value, amounts_[amounts_.length - 1]);
    }

    // 4. Swap Tokens for Exact Eth

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

    // 5. Swap Exact Tokens for ETH
    function swapExactTokensForETH(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, uint256 deadline_)
        external
    {
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[0]).approve(RouterV2Address, amountIn_);

        uint256[] memory amounts =
            IRouterV2(RouterV2Address).swapExactTokensForETH(amountIn_, amountOutMin_, path_, msg.sender, deadline_);

        emit SwapTokensForETH(path_[0], amountIn_, amounts[amounts.length - 1]);
    }

    // 6. Add Liquidity

    function addLiquidityFromOneToken(uint256 amountIn_, uint256 amountOutMin_,address[] memory path_,address tokenA_, address tokenB_, uint256 amountAMin_, uint256 amountBMin_, uint256 deadline_) external validPairs(tokenA_, tokenB_){
        
        //Ensure only the necessary Token A is used
         IERC20(tokenA_).safeTransferFrom(msg.sender, address(this), amountIn_/2);
        //Swap Tokens to ensure 50/50
        uint256 exactAmountOut_ = swapExactTokensForTokens(amountIn_/2, amountOutMin_,path_,deadline_);
        //Add Liquidity
        (,,uint256 lpTokenAmount) = IRouterV2(RouterV2Address).addLiquidity(tokenA_, tokenB_, amountIn_/2, exactAmountOut_, amountAMin_, amountBMin_, msg.sender, deadline_);

        emit AddLiquidity(tokenA_, tokenB_, lpTokenAmount);


    }
}
