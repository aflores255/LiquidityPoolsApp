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
    //Events

    event SwapERC20Tokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapETHForTokens(address tokenOut, uint256 amountIn, uint256 amountOut);
    event SwapTokensForETH(address tokenIn, uint256 amountIn, uint256 amountOut);

    //Constructor

    constructor(address RouterV2Address_) {
        RouterV2Address = RouterV2Address_;
    }

    // 1. Swap exact tokens for tokens
    function swapExactTokensForTokens(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] memory path_,
        uint256 deadline_
    ) external {
        //Get first Token
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        //Approve
        IERC20(path_[0]).approve(RouterV2Address, amountIn_);
        //Swap
        uint256[] memory amountsOut_ =
            IRouterV2(RouterV2Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);

        emit SwapERC20Tokens(path_[0], path_[path_.length - 1], amountIn_, amountsOut_[amountsOut_.length - 1]);
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
}
