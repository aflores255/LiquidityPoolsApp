//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity 0.8.28;

//3. Interface

interface IFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}
