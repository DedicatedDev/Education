//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract Auction {
    //Set Auction end time and beneficiary address;
    address payable public beneficiary;
    uint public auctionEndTime;

    //Winner infos in Auction
    address public highBidder;
    uint public highestBid;

    //previous bidder's bid prices key value map
    mapping(address => uint) public pendingReturns;
    bool public ended;

    event AppearHigherBidder(address bidder, uint amount);
    event AuctionEnded(address winner, uint price);

    error AuctionAlreadyEnded();
    error LowBidThanHigestBid(uint highestBid);
    error AuctionNotYetEnded();
    error AlreadyEndedAuctionCalled();

    constructor(uint biddingTime, address payable beneficiaryAdress) {
        beneficiary = beneficiaryAdress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    //BidLogic
    function bid(uint bidPrice) external payable {
        require(msg.sender != address(0),"untrusted address");
        require(msg.sender != beneficiary, "tried to bid to your product!");
        if (block.timestamp > auctionEndTime) {
            revert AuctionAlreadyEnded();
        }
        if (bidPrice <= highestBid) revert LowBidThanHigestBid(highestBid);

        if (highestBid != 0) {
            pendingReturns[highBidder] += highestBid;
        }
        highestBid = bidPrice;
        highBidder = msg.sender;
        emit AppearHigherBidder(msg.sender, bidPrice);
    }

    function withdraw() external returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() external {
        if (block.timestamp < auctionEndTime) {
            revert AuctionNotYetEnded();
        }
        if (ended) revert AuctionAlreadyEnded();

        ended = true;
        emit AuctionEnded(highBidder, highestBid);

        beneficiary.transfer(highestBid);
    }

    function getBlockTime() external view returns(uint256) {
        return block.timestamp;
    }
}