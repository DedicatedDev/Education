//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
// import "hardhat/console.sol";
// import "openzeppelin/contracts/utils/math/SafeMath.sol";
// import "openzeppelin/contracts/interface/IERC20.sol";

// contract Dex {
//     using SafeMath for uint256;
//     IERC20 token;
//     uint256 public totalLiquidity;
//     mapping (address => uint256) public liquidity;

//     constructor(address token_addr)  public {
//         token = IERC20(token_addr);
//     }
//     function deposit(uint256 tokens) public payable returns (uint256) {
//         require(totalLiquidity == 0, "Dex:init- already has liquidity");
//         totalLiquidity = address(this).balance;
//         liquidity(msg.sender) == totalLiquidity;
//         require(tokens.transForm(msg.sender, address(this), tokens));
//         return totalLiquidity
//     }


// }