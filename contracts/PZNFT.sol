//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "hardhat/console.sol";

contract PZNFT is ERC721URIStorage, EIP712, AccessControl {
    using ECDSA for bytes32;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping (address => uint256) public pendingWithdrawals;

    constructor(address payable minter) 
        ERC721("PZNF","PZT")
        EIP712("PZNFT-Voucher","1") {
            _setupRole(MINTER_ROLE, minter);
    }

    struct NFTVoucher {
        uint256 tokenId;
        uint256 minPrice;
        string uri;
    }

    function  withdraw() public {
        require(hasRole(MINTER_ROLE, msg.sender), "Only authorized minters can withdraw");
        address payable receiver = payable(msg.sender);
        uint amount = pendingWithdrawals[receiver];
        pendingWithdrawals[receiver] = 0;
        receiver.transfer(amount);
    }

    function _hash(NFTVoucher calldata voucher) internal view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(
            keccak256("NFTVoucher(uint256 tokenId,uint256 minPrice,string uri)"),
            voucher.tokenId,
            voucher.minPrice,
            keccak256(bytes(voucher.uri))
        )));
    }
    
    function _verify(NFTVoucher calldata voucher, bytes memory signature) internal view returns(address) {
        bytes32 digest = _hash(voucher);
        console.logBytes32(digest);
        return digest.toEthSignedMessageHash().recover(signature);
    }
    function availableToWithdraw() public view returns (uint256) {
        return pendingWithdrawals[msg.sender];
    }

    

    function redeem(address redeemer, NFTVoucher calldata voucher, bytes memory signature) public payable returns (uint256) {
        address signer = _verify(voucher, signature);
        console.log(signer);
        require(hasRole(MINTER_ROLE,signer),"Signature invalid or unauthorized");
        require(msg.value >= voucher.minPrice, "Insufficient funds to redeem");
        _mint(signer, voucher.tokenId);
        _setTokenURI(voucher.tokenId, voucher.uri);

        _transfer(signer, redeemer, voucher.tokenId);

        pendingWithdrawals[signer] += msg.value;
        return voucher.tokenId;
    }
    

    function supportsInterface(bytes4 interfaceId) public view virtual override (AccessControl, ERC721) returns (bool) {
        return ERC721.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
    }
}