//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Lender is ReentrancyGuard  {
    
    mapping(address => uint) public deposits;
    
    modifier onlyTrustAddress() {
        require(msg.sender != address(0),"Untrusted Address");
        _;
    }
    function deposit() external payable  {
        deposits[msg.sender] += msg.value;        
    }

    function lend() public payable nonReentrant onlyTrustAddress {
        
    }

}