import { Election } from './../typechain/Election.d';
import { Election__factory } from './../typechain/factories/Election__factory';
import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';


xdescribe("Election Test", async() => {
    let Election:Election__factory
    let election:Election
    let testers:SignerWithAddress[]

    beforeEach(async() => {
        testers = await ethers.getSigners();
    } )

    it("Deploy test",async() => {
        Election = await ethers.getContractFactory("Election");
        election = await Election.deploy([
            ethers.utils.formatBytes32String("Ariana Grande"),
            ethers.utils.formatBytes32String("Michael Jackson"),
            ethers.utils.formatBytes32String("Freddie Mercury"),
            ethers.utils.formatBytes32String("Taylor Swift")
        ]);
        await election.deployed();
        expect(election.address).to.not.equal("")
    })

    it("it should be right allocation test(group allocation)", async () => {
        await election.connect(testers[1]).giveRightToVotes([
            testers[4].address,
            testers[5].address,
            testers[6].address,
            testers[7].address,
        ])
    })

    it("test reallocation", async () => {
        await expect(election.connect(testers[4]).giveRightToVote(testers[1].address)).to.be.revertedWith("Have weight already'")
    })

  
    it("This is right voter test", async () => {
        await election.vote(1)
        await election.connect(testers[4]).vote(3)
        await election.connect(testers[5]).vote(3)
        await election.connect(testers[6]).vote(2)
    })

    it("This is right wrong test", async () => {
        await expect(election.connect(testers[3]).vote(2)).to.be.revertedWith("Has no right to vote")
    })

    it("This is test for delegate", async () => {
        await election.connect(testers[9]).delegate(testers[6].address)
    })

    it("This is test for wrong delegate", async () => {
        await expect(election.connect(testers[4]).delegate(testers[4].address)).to.be.reverted
    })

    it("This is test for final result", async () => {
        const result =  await election.winnerInfo()
        console.log(ethers.utils.parseBytes32String(result.winnerName_))
    })


})