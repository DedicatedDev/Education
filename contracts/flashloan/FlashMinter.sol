// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/interfaces/IERC3156.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FlashMinter is ERC20, IERC3156FlashLender {

    bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    uint256 public fee; //  1 == 0.0001 %.

    constructor (
        string memory name,
        string memory symbol,
        uint256 fee_
    ) ERC20(name, symbol) {
        fee = fee_;
    }

    function maxFlashLoan(
        address token
    ) external view override returns (uint256) {
        return type(uint256).max - totalSupply();
    }

    function flashFee(
        address token,
        uint256 amount
    ) external view override returns (uint256) {
        require(
            token == address(this),
            "FlashMinter: Unsupported currency"
        );
        return _flashFee(token, amount);
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external override returns (bool){
        require(
            token == address(this),
            "FlashMinter: Unsupported currency"
        );
        uint256 _fee = _flashFee(token, amount);
        _mint(address(receiver), amount);
        require(
            receiver.onFlashLoan(msg.sender, token, amount, _fee, data) == CALLBACK_SUCCESS,
            "FlashMinter: Callback failed"
        );
        uint256 _allowance = allowance(address(receiver), address(this));
        require(
            _allowance >= (amount + _fee),
            "FlashMinter: Repay not approved"
        );
        _approve(address(receiver), address(this), _allowance - (amount + _fee));
        _burn(address(receiver), amount + _fee);
        return true;
    }

    function _flashFee(
        address token,
        uint256 amount
    ) internal view returns (uint256) {
        return amount * fee / 10000;
    }
}
