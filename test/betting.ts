import { Betting } from './../typechain/Betting.d';
import { Betting__factory } from './../typechain/factories/Betting__factory';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ethers } from 'hardhat';
const { expect } = require("chai");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

describe("Betting", function () {
    let owner: SignerWithAddress,
      addr1: SignerWithAddress,
      addr2: SignerWithAddress,
      addr3: SignerWithAddress,
      addr4: SignerWithAddress,
      addr5: SignerWithAddress;
    let Betting:Betting__factory, betting:Betting;

    before(async function() {
      [owner, addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();

      Betting = await ethers.getContractFactory("Betting");
      betting = await Betting.deploy();

      await betting.deployed();
    });
    

    it("Should allow claiming gains", async function () {
        await betting.bet(1, { value : 1e9 });

        await betting.connect(addr1).bet(1, { value : 1e9 })

        await betting.connect(addr2).bet(2, { value : 1e9 })

        const list = await betting.getPlayersBetTwo();
        console.log("list:=>",list)

        const merkleTree = new MerkleTree(list, keccak256, { hashLeaves: true, sortPairs: true });
        console.log(merkleTree)

        const root = merkleTree.getHexRoot();
        console.log(root)

        await betting.setMerkleRoot(root, 2);

        const proof = merkleTree.getHexProof(addr2.address);
      
        console.log("proof:=>",proof);

        await expect(betting.connect(addr2).claim(proof))
          .to.emit(betting, 'GainsClaimed')
          .withArgs(addr2.address, 3e9);;
    });
})