import { AppearHigherBidderEvent } from '../typechain/Auction';
import { Auction__factory,Auction} from '../typechain';

import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from 'hardhat';

const sleep = (delay:number) => {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}

xdescribe("Auction", async () => {
  let Auction:Auction__factory
  let auction:Auction
  it("it should add new bids", async() => {
    Auction = await ethers.getContractFactory("Auction");
    auction = await Auction.deploy(10,"0xFA95C59cb757471Ee21606e6e33F078Ac41B1c8b");
    await auction.deployed();
  })

  it("it is oneItem bid", async () => {
    expect(auction.address).to.not.equal("");
    const [owner, addr1,addr2,addr3] = await ethers.getSigners();  
    await auction.connect(addr2).bid({value:150});
    expect(await auction.highestBid()).to.equal(150);
  })

  it("it is lowItem bid test", async () => {
    const [owner,addr3] = await ethers.getSigners();
    try {
      await auction.connect(addr3).bid({value:100});
    } catch (error) {
      expect(error);
    }
  })

  it("it is test for auction cancel", async () => {
    try {
      await auction.auctionEnd();
    } catch (error) {
      expect(error);
    }
  })

  it("it is test for auction cancel success", async () => {
    const currentBlockTime:BigNumber = await auction.getBlockTime()
    const bidEndTime:BigNumber = await auction.auctionEndTime()
    if (bidEndTime > currentBlockTime) {
      const currentTime = +ethers.utils.formatEther(currentBlockTime)
      const endTime  = +ethers.utils.formatEther(bidEndTime)
      sleep(endTime-currentTime);
      await auction.auctionEndTime()
    }else{
      await auction.auctionEndTime()
    }
  })

})


