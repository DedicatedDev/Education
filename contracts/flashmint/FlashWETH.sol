//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/IFlashMinter.sol";


contract PZToken is ERC20("PZToken","PZ"){
    using SafeMath for uint256;

    receive () external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }

    function flashMint(address recipient, uint256 amount, bytes calldata data) external {
        IFlashMinter falshMinter = IFlashMinter(recipient);
        _mint(recipient, amount);
        falshMinter.onFlashMint(msg.sender, amount, data);
        _burn(recipient, amount);

    }
    
}
