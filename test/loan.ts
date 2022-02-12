import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"
import { expect } from "chai"
import { BigNumber } from "ethers"
import { ethers } from "hardhat"
import { ERC20Mock, ERC20Mock__factory, Lender, Lender__factory } from "../typechain"

describe("Loan", async()=> {
    let ERC20MockFactory:ERC20Mock__factory
    let dai:ERC20Mock
    let LenderFactory:Lender__factory;
    let lender:Lender;
    let accounts:SignerWithAddress[];

    before(async()=>{
        accounts = await ethers.getSigners();
        ERC20MockFactory = await ethers.getContractFactory("ERC20Mock");
        dai = await ERC20MockFactory.deploy("DAI","DAI");
        await dai.deployed();

        LenderFactory = await ethers.getContractFactory("Lender");
        lender = await LenderFactory.deploy();
        await lender.deployed()
    })


    it("should be borrow with debit Ether", async() => {
        dai.mint(accounts[0].address, 1e10);
        console.log("Dai balance in Account 0:=>", await dai.balanceOf(accounts[0].address))
        dai.approve(lender.address, 1e8);

        await lender.connect(accounts[0]).deposit(dai.address,1e6)
        const balance = await dai.balanceOf(lender.address)
        console.log("custom Token deposit test:=>", balance)
        expect(balance).to.equal(BigNumber.from(1e6))

        const debitEther = ethers.utils.parseEther("20")
        const fee = 20 / 1000
        const realAmount = (20 - fee) * 50;
        await lender.connect(accounts[1]).borrowWithDebit(dai.address,accounts[2].address,{value: debitEther})
        expect(await dai.balanceOf(accounts[1].address)).to.equal(BigNumber.from(realAmount))
    })
})