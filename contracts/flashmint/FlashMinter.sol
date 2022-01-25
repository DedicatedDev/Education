//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "./interface/IFlashMinter.sol";

contract FlashMinter is IFlashMinter {
    uint256 public totalBorrowed;
    address private immutable controller_;
    address private immutable fWETH_;
    constructor (address fWETH) {
        controller_ = msg.sender;
        fWETH_ = fWETH;
    }
    
    function onFlashMint (
    address sender, 
    uint256 amount, 
    bytes calldata data) external override {
        require(msg.sender == fWETH_, "only minter can create TOken");
        require(sender == controller_, "not owner");
        totalBorrowed += amount;
    }
}