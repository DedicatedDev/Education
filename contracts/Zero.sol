//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Zero is Ownable {
    IERC20 private _token;
    mapping (address => uint) public balances;
    uint private _feeRatio = 1000;
    function send(address tokenAdress, address[] memory recievers) external payable {
        require(msg.value > 0, "can't send empty amount");
        require(recievers.length > 0,"there is no recievers");
        uint fee = msg.value / _feeRatio;
        uint divider = (msg.value - fee) / recievers.length;
        IERC20 customToken = IERC20(tokenAdress);
        balances[tokenAdress] += fee;
        console.log(customToken.balanceOf(msg.sender));
        customToken.transferFrom(msg.sender, address(this), msg.value);
        for (uint256 index = 0; index < recievers.length; index++) {
            customToken.transfer(recievers[index], divider);
        }
    }

    function sendEther(address[] memory recievers) external payable {
        require(msg.value > 0, "can't send empty amount");
        require(recievers.length > 0,"there is no recievers");
        uint fee = msg.value / _feeRatio;
        uint divider = (msg.value - fee) / recievers.length;
        for (uint256 index = 0; index < recievers.length; index++) {
            payable(recievers[index]).transfer(divider);
        }
    }

    function withdraw(address tokenAdress) external onlyOwner payable {
        require(msg.value > 0 , "empty amount");
        uint balance = balances[tokenAdress];
        if (balance > msg.value) {
            balances[tokenAdress] -= msg.value;
        }else{
            balances[tokenAdress] = 0;
        }
        IERC20(tokenAdress).transferFrom(address(this),msg.sender, msg.value);
    }

    function withdrawEther() external onlyOwner payable {
        require(msg.value > 0 , "empty amount");
         if (address(this).balance > msg.value) {
            payable(msg.sender).transfer(msg.value);
         }else{
           payable(msg.sender).transfer(address(this).balance);
         }
    }
}