import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { PZNFT, PZNFT__factory } from "../typechain";
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { LazyMinter } = require('../lib');

async function deploy() {
  const [minter, redeemer] = await ethers.getSigners();

  // eslint-disable-next-line camelcase
  const factory: PZNFT__factory = await ethers.getContractFactory(
    "LazyNFT",
    minter
  );
  const contract = await factory.deploy(minter.address)

  // the redeemerContract is an instance of the contract that's wired up to the redeemer's signing key
  const redeemerFactory = factory.connect(redeemer)
  const redeemerContract = redeemerFactory.attach(contract.address)

  return {
    minter,
    redeemer,
    contract,
    redeemerContract,
  }
}

describe("LazyNFT", function() {
  let PZNFTFactory:PZNFT__factory;
  let pznft:PZNFT;
  let redeemerFactory:PZNFT__factory;
  let redeemerContract:PZNFT;
  let minter:SignerWithAddress;
  let redeemer:SignerWithAddress;
  
  before(async ()=>{
    const signers = await ethers.getSigners();
    minter = signers[0];
    redeemer = signers[1];
  })

  it("Should deploy", async function() {
    PZNFTFactory = await ethers.getContractFactory("PZNFT", minter);
    pznft = await PZNFTFactory.deploy(minter.address);
    //await pznft.deployed();
    //console.log("nft address:=>",pznft.address);

    redeemerFactory = PZNFTFactory.connect(redeemer);
    redeemerContract = redeemerFactory.attach(pznft.address);
    //console.log("redeemerContract address:=>",redeemerContract.address);
  });

  it("Should redeem an NFT from a signed voucher", async function() {
    //const { contract, redeemerContract, redeemer, minter } = await deploy()
    const lazyMinter = new LazyMinter(pznft.address,minter)
    const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi");
    console.log("signature:=>",signature);

    await expect(redeemerContract.redeem(redeemer.address, voucher, signature))
        .to.emit(pznft, 'Transfer')  // transfer from null address to minter
        .withArgs('0x0000000000000000000000000000000000000000', minter.address, voucher.tokenId)
        .and.to.emit(pznft, 'Transfer') // transfer from minter to redeemer
        .withArgs(minter.address, redeemer.address, voucher.tokenId);
  });

  // it("Should fail to redeem an NFT that's already been claimed", async function() {
    

  //   const lazyMinter = new LazyMinter({ contractAddress: pznft.address, signer: minter })
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature))
  //     .to.emit(pznft, 'Transfer')  // transfer from null address to minter
  //     .withArgs('0x0000000000000000000000000000000000000000', minter.address, voucher.tokenId)
  //     .and.to.emit(pznft, 'Transfer') // transfer from minter to redeemer
  //     .withArgs(minter.address, redeemer.address, voucher.tokenId);

  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature))
  //     .to.be.revertedWith('ERC721: token already minted')
  // });

  // it("Should fail to redeem an NFT voucher that's signed by an unauthorized account", async function() {
  //   const signers = await ethers.getSigners()
  //   const rando = signers[signers.length-1];
    
  //   const lazyMinter = new LazyMinter({ contractAddress: pznft.address, signer: rando })
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature))
  //     .to.be.revertedWith('Signature invalid or unauthorized')
  // });

  // it("Should fail to redeem an NFT voucher that's been modified", async function() {
  //   const { contract, redeemerContract, redeemer, minter } = await deploy()

  //   const signers = await ethers.getSigners()
  //   const rando = signers[signers.length-1];
    
  //   const lazyMinter = new LazyMinter({ contractAddress: contract.address, signer: rando })
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

  //   voucher.tokenId = 2
  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature))
  //     .to.be.revertedWith('Signature invalid or unauthorized')
  // });

  // it("Should redeem if payment is >= minPrice", async function() {
  //   const { contract, redeemerContract, redeemer, minter } = await deploy()

  //   const lazyMinter = new LazyMinter({ contractAddress: contract.address, signer: minter })
  //   const minPrice = ethers.constants.WeiPerEther // charge 1 Eth
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", minPrice)

  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature, { value: minPrice }))
  //     .to.emit(contract, 'Transfer')  // transfer from null address to minter
  //     .withArgs('0x0000000000000000000000000000000000000000', minter.address, voucher.tokenId)
  //     .and.to.emit(contract, 'Transfer') // transfer from minter to redeemer
  //     .withArgs(minter.address, redeemer.address, voucher.tokenId)
  // })

  // it("Should fail to redeem if payment is < minPrice", async function() {
  //   const { contract, redeemerContract, redeemer, minter } = await deploy()

  //   const lazyMinter = new LazyMinter({ contractAddress: contract.address, signer: minter })
  //   const minPrice = ethers.constants.WeiPerEther // charge 1 Eth
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", minPrice)

  //   const payment = minPrice.sub(10000)
  //   await expect(redeemerContract.redeem(redeemer.address, voucher, signature, { value: payment }))
  //     .to.be.revertedWith('Insufficient funds to redeem')
  // })

  // it("Should make payments available to minter for withdrawal", async function() {
  //   //const { contract, redeemerContract, redeemer, minter } = await deploy()

  //   const lazyMinter = new LazyMinter({ contractAddress: pznft.address, signer: minter })
  //   const minPrice = ethers.constants.WeiPerEther // charge 1 Eth
  //   const { voucher, signature } = await lazyMinter.createVoucher(1, "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", minPrice)
    
  //   // the payment should be sent from the redeemer's account to the contract address
  //   await expect(await redeemerContract.redeem(redeemer.address, voucher, signature, { value: minPrice }))
  //     .to.changeEtherBalances([redeemer, pznft], [minPrice.mul(-1), minPrice]) 

  //   // minter should have funds available to withdraw
  //   expect(await pznft.availableToWithdraw()).to.equal(minPrice)

  //   // withdrawal should increase minter's balance
  //   await expect(await pznft.withdraw())
  //     .to.changeEtherBalance(minter, minPrice)

  //   // minter should now have zero available
  //   expect(await pznft.availableToWithdraw()).to.equal(0)
  // })

});