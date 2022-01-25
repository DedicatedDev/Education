//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IFlashMinter {
    function onFlashMint(
        address sender,
        uint256 amount,
        bytes calldata data
    ) external;
}