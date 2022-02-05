//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Factory {
    event Deployed(address addr_);
    function deploy(uint salt, bytes calldata bytecode) public {
        bytes memory implInitCode = bytecode;
        address addr;
        assembly {
            let encoded_data := add(0x20, implInitCode)
            let encoded_size := mload(implInitCode)
            addr := create2(0,encoded_data, encoded_size, salt)
        }
        emit Deployed(addr);
    }
}

contract NoConstructor {
    uint public myUnit = 5;
}