//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC3156.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract FlashLender is IERC3156FlashLender {

    bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    mapping(address => bool) public supportedTokens;
    uint256 public fee; //  1 == 0.0001 %.
    constructor(
        address[] memory supportedTokens_,
        uint256 fee_
    ) {
        for (uint256 i = 0; i < supportedTokens_.length; i++) {
            supportedTokens[supportedTokens_[i]] = true;
        }
        fee = fee_;
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external override returns(bool) {
        require(
            supportedTokens[token],
            "FlashLender: Unsupported currency"
        );
        uint256 _fee = _flashFee(token, amount);
        console.log("=>start<=");
        console.log("Lender:",IERC20(token).balanceOf(address(this)));
        console.log("Borrower",IERC20(token).balanceOf(address(receiver)));

        require(
            IERC20(token).transfer(address(receiver), amount),
            "FlashLender: Transfer failed"
        );

        console.log("=>after borrower<=");
        console.log("Lender:",IERC20(token).balanceOf(address(this)));
        console.log("Borrower",IERC20(token).balanceOf(address(receiver)));
        
        require(
            receiver.onFlashLoan(msg.sender, token, amount, _fee, data) == CALLBACK_SUCCESS,
            "FlashLender: Callback failed"
        );
        
        
        require(
            IERC20(token).transferFrom(address(receiver), address(this), amount + _fee),
            "FlashLender: Repay failed"
        );
        console.log("flashLoan =>end<=");
        console.log("Lender:",IERC20(token).balanceOf(address(this)));
        console.log("Borrower",IERC20(token).balanceOf(address(receiver)));
        console.log("--------+++++++++++----------");
        return true;
    }

    function flashFee(
        address token,
        uint256 amount
    ) external view override returns (uint256) {
        require(
            supportedTokens[token],
            "FlashLender: Unsupported currency"
        );
        
        return _flashFee(token, amount);
    }

    function _flashFee(
        address token,
        uint256 amount
    ) internal view returns (uint256) {
        return amount * fee / 10000;
    }

    function maxFlashLoan(
        address token
    ) external view override returns (uint256) {
        return supportedTokens[token] ? IERC20(token).balanceOf(address(this)) : 0;
    }
}