//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract Bank {
    mapping(address => uint) public shares;
    modifier onlyTrust() {
        require(msg.sender != address(0), "Untrusted User");
        require(msg.value != 0, "no value");
        _;
    }
    
    function deposit() external payable onlyTrust {
        shares[msg.sender] += msg.value;
    }

    function withdraw(uint amount_) external {
        require(shares[msg.sender] >= amount_,"remain is 0 ether" );
        
        (bool sent,) = msg.sender.call{value:amount_}("");
        require(sent, "Failed to send Ether");
        //require(payable(msg.sender).send(amount_),"sddsfdsf");
        shares[msg.sender] -= amount_;
        
        // if (payable(msg.sender).send(amount_)) {
        //     shares[msg.sender] -= amount_;
        // }
        
    }

    function getBalance() public view returns (uint balance_) {
        balance_ = address(this).balance;
    }
    function getInstanceAddress() public view returns (address address_) {
        address_ = address(this);
    }
}