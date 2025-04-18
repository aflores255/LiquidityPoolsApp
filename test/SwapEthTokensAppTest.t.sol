//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/SwapEthTokensApp.sol";

//3. Contract

contract SwapTokensAppTest is Test {
    SwapEthTokensApp swapEthTokensApp;
    address routerAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Arbitrum one
    address user1 = 0x29F01FA20886EFF9Ba9D08Ad8e9E1eC7ADcf89E6; // Holder USDC
    address user2 = 0x52Aa899454998Be5b000Ad077a46Bbe360F4e497; //Holder USDT
    address user3 = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D; // Holder multiple tokens
    address USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // USDC Address in Arbitrum One Mainnet
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT Address in Arbitrum One Mainnet
    address WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; //WETH Address in Arbitrum One Mainnet
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI Address in Arbitrum One Mainnet

    function setUp() public {
        swapEthTokensApp = new SwapEthTokensApp(routerAddress, USDT, USDC, DAI);
    }

    function testInitialDeploy() public view {
        assert(swapEthTokensApp.RouterV2Address() == routerAddress);
    }

    function testSwapExactTokensForTokens() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 9 * 1e6;
        uint256 deadline_ = 1744647360 + 600000;
        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = USDT;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceBefore = IERC20(USDT).balanceOf(user1);

        IERC20(USDC).approve(address(swapEthTokensApp), amountIn_);
        swapEthTokensApp.swapExactTokensForTokens(amountIn_, amountOutMin_, path_, user1, deadline_);

        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceAfter = IERC20(USDT).balanceOf(user1);

        assert(userToken1BalanceAfter == userToken1BalanceBefore - amountIn_);
        assert(
            userToken2BalanceBefore < userToken2BalanceAfter
                && (userToken2BalanceAfter - userToken2BalanceBefore >= amountOutMin_)
        );

        vm.stopPrank();
    }

    function testSwapTokensForExactTokens() public {
        uint256 amountOut_ = 9 * 1e6;
        uint256 amountInMax_ = 10 * 1e6;
        uint256 deadline_ = 1744647360 + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = USDT;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceBefore = IERC20(USDT).balanceOf(user1);

        IERC20(USDC).approve(address(swapEthTokensApp), amountInMax_);

        swapEthTokensApp.swapTokensForExactTokens(amountOut_, amountInMax_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceAfter = IERC20(USDT).balanceOf(user1);

        assert(userToken2BalanceAfter == userToken2BalanceBefore + amountOut_);
        assert(
            (userToken1BalanceAfter < userToken1BalanceBefore)
                && (userToken1BalanceBefore - userToken1BalanceAfter <= amountInMax_)
        );

        vm.stopPrank();
    }

    function testSwapExactTokensForETH() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 0.003 ether;
        uint256 deadline_ = 1744647360 + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = WETH;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userEthBalanceBefore = user1.balance;
        IERC20(USDC).approve(address(swapEthTokensApp), amountIn_);

        swapEthTokensApp.swapExactTokensForETH(amountIn_, amountOutMin_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);

        assert(user1.balance >= userEthBalanceBefore + amountOutMin_);
        assert(userToken1BalanceAfter == userToken1BalanceBefore - amountIn_);

        vm.stopPrank();
    }

    function testSwapTokensForExactETH() public {
        uint256 amountOut_ = 0.003 ether;
        uint256 amountInMax_ = 10 * 1e6;
        uint256 deadline_ = 1744647360 + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = WETH;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userEthBalanceBefore = user1.balance;
        IERC20(USDC).approve(address(swapEthTokensApp), amountInMax_);

        swapEthTokensApp.swapTokensForExactETH(amountOut_, amountInMax_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);

        assert(user1.balance == userEthBalanceBefore + amountOut_);
        assert(
            (userToken1BalanceAfter < userToken1BalanceBefore)
                && (userToken1BalanceBefore - userToken1BalanceAfter >= amountInMax_)
        );

        vm.stopPrank();
    }

    function testSwapExactETHForTokens() public {
        uint256 amountOutMin_ = 1.5 * 1e6;
        uint256 ethAmount_ = 0.001 ether;
        uint256 deadline_ = 1744647360 + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = WETH;
        path_[1] = USDC;

        vm.startPrank(user1);
        uint256 userTokenBalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userEthBalanceBefore = user1.balance;
        swapEthTokensApp.swapExactETHForTokens{value: ethAmount_}(amountOutMin_, path_, deadline_);
        uint256 userTokenBalanceAfter = IERC20(USDC).balanceOf(user1);
        assert(userEthBalanceBefore - user1.balance == ethAmount_);
        assert(userTokenBalanceAfter - userTokenBalanceBefore >= amountOutMin_);
        vm.stopPrank();
    }

    function testIncorrectSwapExactETHForTokens() public {
        uint256 amountOutMin_ = 1.5 * 1e6;
        uint256 ethAmount_ = 0 ether;
        uint256 deadline_ = 1744647360 + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = WETH;
        path_[1] = USDC;

        vm.startPrank(user1);
        vm.expectRevert("Incorrect amount");
        swapEthTokensApp.swapExactETHForTokens{value: ethAmount_}(amountOutMin_, path_, deadline_);
        vm.stopPrank();
    }

    function testAddLiquidityFromOneToken() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 4.5 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = USDT;
        path_[1] = DAI;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user2);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountIn_);
        swapEthTokensApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

      function testIncorrectPairAddLiquidityFromOneToken() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 4.5 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = USDT;
        path_[1] = USDT;
        address tokenA_ = USDT;
        address tokenB_ = USDT;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user2);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountIn_);
        vm.expectRevert("Tokens must be different");
        swapEthTokensApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

      function testIncorrectAmountAddLiquidityFromOneToken() public {
        uint256 amountIn_ = 0 * 1e6;
        uint256 amountOutMin_ = 4.5 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = USDT;
        path_[1] = DAI;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user2);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountIn_);
        vm.expectRevert("Amount must be above zero");
        swapEthTokensApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

       function testAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 10 * 1e6;
        uint256 amountB_ = 10 * 1e18;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user3);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountA_);
        IERC20(tokenB_).approve(address(swapEthTokensApp), amountB_);
        swapEthTokensApp.addLiquidityFromTwoTokens(
            amountA_, amountB_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

       function testIncorrectPairAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 10 * 1e6;
        address tokenA_ = USDT;
        uint256 amountAMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user3);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountA_);
        vm.expectRevert("Tokens must be different");
        swapEthTokensApp.addLiquidityFromTwoTokens(
            amountA_, amountA_, tokenA_, tokenA_, amountAMin_, amountAMin_, deadline_
        );
        vm.stopPrank();
    }

     function testIncorrectAmountAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 0 * 1e6;
        uint256 amountB_ = 10 * 1e18;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1744647360 + 600000;

        vm.startPrank(user3);
        IERC20(tokenA_).approve(address(swapEthTokensApp), amountA_);
        IERC20(tokenB_).approve(address(swapEthTokensApp), amountB_);
        vm.expectRevert("Amount must be above zero");
        swapEthTokensApp.addLiquidityFromTwoTokens(
            amountA_, amountB_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }
    


}
