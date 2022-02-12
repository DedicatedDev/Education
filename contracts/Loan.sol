//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "./PriceOracle.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "hardhat/console.sol";
contract Lender is PriceOracle {
    uint256 private _feeRatio = 1000;
    //mapping(address => uint) public balances;
    function deposit(address tokenAddress, uint amount) external {
        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), amount);
      //  console.log(token.balanceOf(address(this)));
    }

    function borrowWithDebit(address tokenAddress, address oracleAddress) external payable {
        console.log(address(this).balance);
         IERC20 token = IERC20(tokenAddress);
         require(msg.value > 0 , "please input lender amount");
         uint fee = msg.value / _feeRatio;
         uint realAmount = msg.value - fee;
         uint256 price = 50; //uint(getLatesPrice(oracleAddress));
         uint exchangedTokenAmount = realAmount*price/1 ether;
         require(token.balanceOf(address(this)) > exchangedTokenAmount, "pool is not enough");
         token.transfer(msg.sender, exchangedTokenAmount);
    }


}