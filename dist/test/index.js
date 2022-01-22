"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const chai_1 = require("chai");
const ethers_1 = require("ethers");
const hardhat_1 = require("hardhat");
// describe("Greeter", function () {
//   it("Should return the new greeting once it's changed", async function () {
//     const Greeter = await ethers.getContractFactory("Greeter");
//     const greeter = await Greeter.deploy("Hello, world!");
//     await greeter.deployed();
//     expect(await greeter.greet()).to.equal("Hello, world!");
//     const setGreetingTx = await greeter.setGreeting("Hola, mundo!");
//     // wait until the transaction is mined
//     await setGreetingTx.wait();
//     expect(await greeter.greet()).to.equal("Hola, mundo!");
//   });
// });
describe("Auction", async () => {
    it("it should add new bids", async () => {
        const [owner, addr1, addr2, addr3] = await hardhat_1.ethers.getSigners();
        const Auction = await hardhat_1.ethers.getContractFactory("Auction");
        const auction = await Auction.deploy(1000000, "0xFA95C59cb757471Ee21606e6e33F078Ac41B1c8b");
        await auction.deployed();
        console.log(auction.address);
        (0, chai_1.expect)(auction.address).to.not.equal("");
        auction.on("AppearHigherBidder", (event) => {
            console.log(event);
            // expect(event).to.equal("helloworld2");
        });
        auction.connect(addr3);
        console.log(addr3.address);
        console.log("-------+++++++---------");
        console.log(auction.address);
        const bid1 = await auction.bid();
        bid1.value = new ethers_1.BigNumber("0x", "40000");
        await bid1.wait();
        console.log("-------*********--------------");
        console.log(auction.signer);
        // bid1.value = new BigNumber("0x","30000");
        // sleep(2000)
        // const bid2 = await auction.connect(addr2).bid();
        // bid2.value = new BigNumber("0x","40000");
        // await bid2.wait();
        // sleep(2000)
        // const bid3 = await auction.connect(addr3).bid();
        // bid3.value = new BigNumber("0x","20000");
        // await bid3.wait();
    });
});
const sleep = (delay) => {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay)
        ;
};
// describe("test",async()=> {
//   it("new test", function() {
//     expect("helloworld").to.equal("helloworld2");
//   }) 
// })
