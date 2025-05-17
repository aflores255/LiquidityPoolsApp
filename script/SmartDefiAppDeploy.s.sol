// 1. License
//SPDX-License-Identifier: UNLICENSED

//2. Solidity
pragma solidity 0.8.28;

//3. Contract

import {Script} from "forge-std/Script.sol";
import {SmartDefiApp} from "../src/SmartDefiApp.sol";

contract FloMarketplaceDeploy is Script {
    function run() external returns (SmartDefiApp) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address routerAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Arbitrum One
        address factoryAddress = 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9; // Arbitrum One
        address USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // USDC Address in Arbitrum One Mainnet
        address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT Address in Arbitrum One Mainnet
        address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI Address in Arbitrum One Mainnet
        vm.startBroadcast(deployerPrivateKey);
        SmartDefiApp smartDefiApp = new SmartDefiApp(routerAddress, factoryAddress, USDT, USDC, DAI);
        vm.stopBroadcast();
        return smartDefiApp;
    }
}