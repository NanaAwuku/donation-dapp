import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Donate", function () {
  async function deployDonationFixture() {
    const [beneficiary, doner1, doner2] = await ethers.getSigners();

    const Donation = await ethers.getContractFactory("Donation");
    const donation = await Donation.deploy(beneficiary.address);
    return { donation, beneficiary };
  }

  it("should set the beneficiary address in the constructor", async function () {
    const { donation, beneficiary } = await loadFixture(deployDonationFixture);
    
    // Assert that the beneficiary address is set correctly
    expect(await donation.beneficiary()).to.equal(beneficiary.address);
  });
  it("should allow users to donate", async function () {
    const { donation, beneficiary } = await loadFixture(deployDonationFixture);
  
    // Get the addresses of the signers
    const [doner1, doner2] = await ethers.getSigners();

  });
  
  
});