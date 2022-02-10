import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"
import { expect } from "chai"
import { BigNumber } from "ethers"
import { ethers } from "hardhat"
import { send } from "process"
import { ERC20Mock, ERC20Mock__factory, Zero, Zero__factory } from "../typechain"

describe("Zero", async()=>{
    let ZeroFactory:Zero__factory
    let zero:Zero
    let accounts:SignerWithAddress[]
    let MockTokenFactory:ERC20Mock__factory
    let mockToken:ERC20Mock

    beforeEach(async() => {
        accounts = await ethers.getSigners();
        
        MockTokenFactory = await ethers.getContractFactory("ERC20Mock")
        mockToken = await MockTokenFactory.deploy("DAI","DAI")
        await mockToken.deployed()
        
        ZeroFactory = await ethers.getContractFactory("Zero");
        zero = await ZeroFactory.deploy()
        await zero.deployed()
    })

    it("deposit ethers and divider", async() => {
        const receivers:string[] = [accounts[1].address, accounts[2].address]
        const sendAmount:number = 10000
        const expectedAmount = (await accounts[1].getBalance()).add(BigNumber.from(sendAmount*(1-0.001)/2))
        await zero.connect(accounts[0]).sendEther(receivers,{value:sendAmount})
        for (let index = 0; index < receivers.length; index++) {
            expect(await accounts[index+1].getBalance()).to.equal(expectedAmount.toString())
        }
    })

    it("deposit customToken and divider", async() => {
        mockToken.mint(accounts[0].address, 1e10)
        const receivers:string[] = [accounts[1].address, accounts[2].address]
        const sendAmount:number = 1e4
        const expectedAmount = BigNumber.from(sendAmount*(1-0.001)/2)
       //Approve
        mockToken.connect(accounts[0]).approve(zero.address, 1e4)
        //Send
        await zero.connect(accounts[0]).send(mockToken.address,receivers,{value:sendAmount})
        for (let index = 0; index < receivers.length; index++) {
            expect(await mockToken.balanceOf(accounts[index+1].address)).to.equal(expectedAmount.toString())
        }
    })
}) 