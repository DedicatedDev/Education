import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ERC20Mock } from './../typechain/ERC20Mock.d';
import { ERC20__factory } from './../typechain/factories/ERC20__factory';
import { ERC20Mock__factory } from './../typechain/factories/ERC20Mock__factory';
import { ethers } from "hardhat";
import { FlashLender__factory, FlashLender, FlashBorrower__factory, FlashBorrower} from "../typechain";
import { expect } from "chai";
import { Address } from 'cluster';

// xdescribe("FlashLoan", async () => {
    
//     let Lender:FlashLender__factory,lender:FlashLender
//     let Borrower:FlashBorrower__factory,borrower:FlashBorrower
//     let WETH:ERC20Mock__factory,weth:ERC20Mock
//     let DAI:ERC20Mock__factory, dai:ERC20Mock
//     let accounts:SignerWithAddress[]

//     beforeEach(async() => {
//         WETH = await ethers.getContractFactory("ERC20Mock")
//         DAI = await ethers.getContractFactory("ERC20Mock")
//         Lender = await ethers.getContractFactory("FlashLender")
//         Borrower = await ethers.getContractFactory("FlashBorrower")
//         accounts = await ethers.getSigners()
//     })

//     it("Mock Token deploy", async () => {
//         weth = await WETH.deploy("WETH","WETH");
//         await weth.deployed()
//         dai = await DAI.deploy("DAI","DAI")
//         await dai.deployed()
//         console.log("WETH:", weth.address);
//         console.log("DAI:", dai.address);
//     })

//     it("FlashLoan Contract Deploy", async() => {
//         lender = await Lender.deploy([
//             weth.address, dai.address
//         ], 10)
//         await lender.deployed();
//         borrower = await Borrower.deploy(lender.address);
//         await borrower.deployed();
//     })

//     it("provide mock token to lender account", async () => {
//         await weth.mint(lender.address, 1000)
//         await dai.mint(lender.address,999)
//     })

//     it("test simple flash loan", async () => {
//         //WETH Borrow Process
//         await borrower.connect(accounts[1]).flashBorrow(weth.address, 1,)
//         let balanceAfter = await weth.balanceOf(accounts[1].address)
//         expect(balanceAfter.toString()).to.equal("0")

//         let flashBalance = await borrower.flashBalance()
//         expect(flashBalance.toString()).to.equal("1")

//         let flashToken = await borrower.flashToken()
//         expect(flashToken.toString()).to.equal(weth.address)

//         let flashAmount = await borrower.flashAmount()
//         expect(flashAmount.toString()).to.equal("1")

//         let flashInitator = await borrower.flashInitiator()
//         expect(flashInitator.toString()).to.equal(borrower.address)

//         //DAI Borrow Process 
//         await borrower.connect(accounts[1]).flashBorrow(dai.address, 3,)
//         balanceAfter = await dai.balanceOf(accounts[1].address)
//         expect(balanceAfter.toString()).to.equal("0")

//         flashBalance = await borrower.flashBalance()
//         expect(flashBalance.toString()).to.equal("3")

//         flashToken = await borrower.flashToken()
//         expect(flashToken.toString()).to.equal(dai.address)

//         flashAmount = await borrower.flashAmount()
//         expect(flashAmount.toString()).to.equal("3")

//         flashInitator = await borrower.flashInitiator()
//         expect(flashInitator.toString()).to.equal(borrower.address)
//     })

//     it("should do a loan that pay fees", async () => {
//         // const loan = ethers.utils.parseEther("1000")
//         // const fee = await lender.flashFee(weth.address,loan)

//         // await weth.connect(accounts[1]).mint(borrower.address,1)
//         // await borrower.flashBorrow(weth.address, loan,)
//         // const balanceAfter = await weth.balanceOf(accounts[1].address)
//         // expect(balanceAfter.toString()).to.equal("0")

//         // const flashBalance = await borrower.flashBalance()
//         // expect(flashBalance.toString()).to.equal(loan.add(fee).toString())
//     })

    
// })

