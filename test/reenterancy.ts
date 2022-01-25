import { GetContractTypeFromFactory } from './../typechain/common.d';
import { Attack } from './../typechain/Attack.d';
import { Attack__factory } from './../typechain/factories/Attack__factory';
import { Bank } from './../typechain/Bank.d';
import { Bank__factory } from './../typechain/factories/Bank__factory';
import {ethers} from "hardhat"
import { expect } from "chai";
import { it } from 'mocha';

xdescribe("Reenterancy", async () => {
    let Bank:Bank__factory
    let bank:Bank
    let Attacker:Attack__factory
    let attacker:Attack

    beforeEach(async () => {
        Bank = await ethers.getContractFactory("Bank");
        bank = await Bank.deploy();
        Attacker = await ethers.getContractFactory("Attack");
    })
    
    it("build simulation",async () => {
        await bank.deployed()
        await bank.deposit({value:ethers.utils.parseEther("20")});

        attacker = await Attacker.deploy(bank.address);
        await attacker.deployed();

        console.log("----Before Attack:-------")
        console.log("Attacker",ethers.utils.formatEther(await attacker.getBalance()))
        console.log("bank",  ethers.utils.formatEther(await bank.getBalance()))
    })

    it("start attack to Bank", async () => {
        attacker.attack({value: ethers.utils.parseEther("1")})
    })
} )