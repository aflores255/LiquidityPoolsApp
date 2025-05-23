//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/SmartDefiApp.sol";

//3. Contract

contract SwapTokensAppTest is Test {
    SmartDefiApp smartDefiApp;
    address routerAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Arbitrum One
    address factoryAddress = 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9; // Arbitrum One
    address user1 = 0x7711C90bD0a148F3dd3f0e587742dc152c3E9DDB; // Holder USDC
    address user2 = 0x52Aa899454998Be5b000Ad077a46Bbe360F4e497; //Holder USDT
    address user3 = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D; // Holder multiple tokens
    address USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // USDC Address in Arbitrum One Mainnet
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT Address in Arbitrum One Mainnet
    address WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; //WETH Address in Arbitrum One Mainnet
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI Address in Arbitrum One Mainnet

    /**
     * @notice Deploys the SmartDefiApp contract before each test.
     */
    function setUp() public {
        smartDefiApp = new SmartDefiApp(routerAddress, factoryAddress, USDT, USDC, DAI);
    }

    /**
     * @notice Verifies the initial Router address is correctly set.
     */
    function testInitialDeploy() public view {
        assert(smartDefiApp.RouterV2Address() == routerAddress);
    }

    /**
     * @notice Tests swapping an exact amount of USDC for USDT.
     */
    function testSwapExactTokensForTokens() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 9 * 1e6;
        uint256 deadline_ = block.timestamp + 600000;
        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = USDT;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceBefore = IERC20(USDT).balanceOf(user1);

        IERC20(USDC).approve(address(smartDefiApp), amountIn_);
        smartDefiApp.swapExactTokensForTokens(amountIn_, amountOutMin_, path_, user1, deadline_);

        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceAfter = IERC20(USDT).balanceOf(user1);

        assert(userToken1BalanceAfter == userToken1BalanceBefore - amountIn_);
        assert(
            userToken2BalanceBefore < userToken2BalanceAfter
                && (userToken2BalanceAfter - userToken2BalanceBefore >= amountOutMin_)
        );

        vm.stopPrank();
    }

    /**
     * @notice Tests swapping USDC for an exact amount of USDT.
     */
    function testSwapTokensForExactTokens() public {
        uint256 amountOut_ = 9 * 1e6;
        uint256 amountInMax_ = 10 * 1e6;
        uint256 deadline_ = block.timestamp + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = USDT;

        vm.startPrank(user1);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceBefore = IERC20(USDT).balanceOf(user1);

        IERC20(USDC).approve(address(smartDefiApp), amountInMax_);

        smartDefiApp.swapTokensForExactTokens(amountOut_, amountInMax_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user1);
        uint256 userToken2BalanceAfter = IERC20(USDT).balanceOf(user1);

        assert(userToken2BalanceAfter == userToken2BalanceBefore + amountOut_);
        assert(
            (userToken1BalanceAfter < userToken1BalanceBefore)
                && (userToken1BalanceBefore - userToken1BalanceAfter <= amountInMax_)
        );

        vm.stopPrank();
    }

    /**
     * @notice Tests swapping an exact amount of USDC for ETH.
     */
    function testSwapExactTokensForETH() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 0.003 ether;
        uint256 deadline_ = block.timestamp + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = WETH;

        vm.startPrank(user2);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user2);
        uint256 userEthBalanceBefore = user2.balance;
        IERC20(USDC).approve(address(smartDefiApp), amountIn_);

        smartDefiApp.swapExactTokensForETH(amountIn_, amountOutMin_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user2);

        assert(user2.balance >= userEthBalanceBefore + amountOutMin_);
        assert(userToken1BalanceAfter == userToken1BalanceBefore - amountIn_);

        vm.stopPrank();
    }

    /**
     * @notice Tests swapping USDC for an exact amount of ETH.
     */
    function testSwapTokensForExactETH() public {
        uint256 amountOut_ = 0.003 ether;
        uint256 amountInMax_ = 10 * 1e6;
        uint256 deadline_ = block.timestamp + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = USDC;
        path_[1] = WETH;

        vm.startPrank(user2);
        uint256 userToken1BalanceBefore = IERC20(USDC).balanceOf(user2);
        uint256 userEthBalanceBefore = user2.balance;
        IERC20(USDC).approve(address(smartDefiApp), amountInMax_);

        smartDefiApp.swapTokensForExactETH(amountOut_, amountInMax_, path_, deadline_);
        uint256 userToken1BalanceAfter = IERC20(USDC).balanceOf(user2);

        assert(user2.balance == userEthBalanceBefore + amountOut_);
        assert(
            (userToken1BalanceAfter < userToken1BalanceBefore)
                && (userToken1BalanceBefore - userToken1BalanceAfter >= amountInMax_)
        );

        vm.stopPrank();
    }

    /**
     * @notice Tests swapping ETH for USDC.
     */
    function testSwapExactETHForTokens() public {
        uint256 amountOutMin_ = 1.5 * 1e6;
        uint256 ethAmount_ = 0.001 ether;
        uint256 deadline_ = block.timestamp + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = WETH;
        path_[1] = USDC;

        vm.startPrank(user2);
        uint256 userTokenBalanceBefore = IERC20(USDC).balanceOf(user2);
        uint256 userEthBalanceBefore = user2.balance;
        smartDefiApp.swapExactETHForTokens{value: ethAmount_}(amountOutMin_, path_, deadline_);
        uint256 userTokenBalanceAfter = IERC20(USDC).balanceOf(user2);
        assert(userEthBalanceBefore - user2.balance == ethAmount_);
        assert(userTokenBalanceAfter - userTokenBalanceBefore >= amountOutMin_);
        vm.stopPrank();
    }

    /**
     * @notice Reverts if ETH sent is zero in ETH-for-token swap.
     */
    function testIncorrectSwapExactETHForTokens() public {
        uint256 amountOutMin_ = 1.5 * 1e6;
        uint256 ethAmount_ = 0 ether;
        uint256 deadline_ = block.timestamp + 600000;

        address[] memory path_ = new address[](2);
        path_[0] = WETH;
        path_[1] = USDC;

        vm.startPrank(user1);
        vm.expectRevert("Incorrect amount");
        smartDefiApp.swapExactETHForTokens{value: ethAmount_}(amountOutMin_, path_, deadline_);
        vm.stopPrank();
    }

    /**
     * @notice Tests adding liquidity using a single token (USDT).
     */
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
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user2);
        //  Balance before Add Liquidity
        uint256 userTokenABefore = IERC20(tokenA_).balanceOf(user2);
        IERC20(tokenA_).approve(address(smartDefiApp), amountIn_);
        uint256 lpTokenAmount_ = smartDefiApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );

        //  Get address and balance of LPTokens
        address lpToken = IFactory(factoryAddress).getPair(tokenA_, tokenB_);
        uint256 userLpBalance = IERC20(lpToken).balanceOf(user2);

        // Balance after addLiquidity
        uint256 userTokenAAfter = IERC20(tokenA_).balanceOf(user2);

        assert(userLpBalance >= lpTokenAmount_);
        assert(userTokenAAfter < userTokenABefore);
        vm.stopPrank();
    }

    /**
     * @notice Reverts if both tokens in the pair are the same.
     */
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
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user2);
        IERC20(tokenA_).approve(address(smartDefiApp), amountIn_);
        vm.expectRevert("Tokens must be different");
        smartDefiApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

    /**
     * @notice Reverts if token input amount is zero.
     */
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
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user2);
        IERC20(tokenA_).approve(address(smartDefiApp), amountIn_);
        vm.expectRevert("Amount must be above zero");
        smartDefiApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

    /**
     * @notice Tests adding liquidity using two tokens.
     */
    function testAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 10 * 1e6;
        uint256 amountB_ = 10 * 1e18;
        address tokenA_ = USDC;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user3);
        //  Balance before Add Liquidity
        uint256 userTokenABefore = IERC20(tokenA_).balanceOf(user3);
        uint256 userTokenBBefore = IERC20(tokenB_).balanceOf(user3);
        IERC20(tokenA_).approve(address(smartDefiApp), amountA_);
        IERC20(tokenB_).approve(address(smartDefiApp), amountB_);
        uint256 lpTokenAmount_ = smartDefiApp.addLiquidityFromTwoTokens(
            amountA_, amountB_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        //Balance After
        uint256 userTokenAAfter = IERC20(tokenA_).balanceOf(user3);
        uint256 userTokenBAfter = IERC20(tokenB_).balanceOf(user3);
        //  Get address and balance of LPTokens
        address lpToken = IFactory(factoryAddress).getPair(tokenA_, tokenB_);
        uint256 userLpBalance = IERC20(lpToken).balanceOf(user3);

        assert(lpTokenAmount_ > 0);
        assert(userLpBalance >= lpTokenAmount_);
        assert(userTokenAAfter < userTokenABefore);
        assert(userTokenBAfter < userTokenBBefore);
        vm.stopPrank();
    }

    /**
     * @notice Reverts if the two tokens in the pair are identical.
     */
    function testIncorrectPairAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 10 * 1e6;
        address tokenA_ = USDT;
        uint256 amountAMin_ = 0;
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user3);
        IERC20(tokenA_).approve(address(smartDefiApp), amountA_);
        vm.expectRevert("Tokens must be different");
        smartDefiApp.addLiquidityFromTwoTokens(
            amountA_, amountA_, tokenA_, tokenA_, amountAMin_, amountAMin_, deadline_
        );
        vm.stopPrank();
    }

    /**
     * @notice Reverts if one of the input amounts is zero.
     */
    function testIncorrectAmountAddLiquidityFromTwoTokens() public {
        uint256 amountA_ = 0 * 1e6;
        uint256 amountB_ = 10 * 1e18;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user3);
        IERC20(tokenA_).approve(address(smartDefiApp), amountA_);
        IERC20(tokenB_).approve(address(smartDefiApp), amountB_);
        vm.expectRevert("Amount must be above zero");
        smartDefiApp.addLiquidityFromTwoTokens(
            amountA_, amountB_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );
        vm.stopPrank();
    }

    /**
     * @notice Tests removing liquidity after adding it.
     */
    function testRemoveLiquidity() public {
        uint256 amountIn_ = 10 * 1e6;
        uint256 amountOutMin_ = 4.5 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = USDT;
        path_[1] = DAI;
        address tokenA_ = USDT;
        address tokenB_ = DAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = block.timestamp + 600000;

        vm.startPrank(user2);
        //  Balance before Add Liquidity
        uint256 userTokenABefore = IERC20(tokenA_).balanceOf(user2);
        IERC20(tokenA_).approve(address(smartDefiApp), amountIn_);
        uint256 lpTokenAmount_ = smartDefiApp.addLiquidityFromOneToken(
            amountIn_, amountOutMin_, path_, tokenA_, tokenB_, amountAMin_, amountBMin_, deadline_
        );

        //  Get address and balance of LPTokens
        address lpToken = IFactory(factoryAddress).getPair(tokenA_, tokenB_);
        uint256 userLpBalance = IERC20(lpToken).balanceOf(user2);

        // Balance after addLiquidity
        uint256 userTokenAAfter = IERC20(tokenA_).balanceOf(user2);

        assert(userLpBalance >= lpTokenAmount_);
        assert(userTokenAAfter < userTokenABefore);

        IERC20(lpToken).approve(address(smartDefiApp), lpTokenAmount_);
        smartDefiApp.removeLiquidity(tokenA_, tokenB_, lpTokenAmount_, amountAMin_, amountBMin_, user2, deadline_);

        uint256 userTokenAAfterRL = IERC20(tokenA_).balanceOf(user2);
        uint256 userLpBalanceAfterRL = IERC20(lpToken).balanceOf(user2);

        assert(userTokenAAfterRL > userTokenAAfter);
        assert(userLpBalanceAfterRL < userLpBalance);
        vm.stopPrank();
    }

    /**
     * @notice Tests that the contract correctly reverts when one of the tokens is not a supported stablecoin.
     */
    function testRevertIfTokenIsNotStablecoin() public {
        address invalidToken = address(0x0000); // Not a valid stablecoin in constructor
        uint256 amountA_ = 10 * 1e6;
        uint256 amountB_ = 10 * 1e6;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = block.timestamp + 600;

        vm.startPrank(user1);
        vm.expectRevert("Tokens must be StableCoin");
        smartDefiApp.addLiquidityFromTwoTokens(
            amountA_,
            amountB_,
            USDC, // valid
            invalidToken, // invalid
            amountAMin_,
            amountBMin_,
            deadline_
        );
        vm.stopPrank();
    }
}
