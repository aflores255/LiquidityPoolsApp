//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

//3. Interface

interface IFactory {
    /**
     * @notice Returns the address of the liquidity pool (pair) for two tokens.
     * @param tokenA Address of the first token.
     * @param tokenB Address of the second token.
     * @return pair Address of the LP token (pair) contract for the two tokens.
     */
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}
