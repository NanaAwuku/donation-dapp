const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

async function deployDonationFixture() {
  const [owner, donor, beneficiary] = await ethers.getSigners();

  const Donation = await ethers.getContractFactory("Donation");
  const donation = await Donation.deploy(beneficiary.address);

  return { donation, donor, beneficiary };
}


describe("Donation", function() {
  it("should set the beneficiary address in the constructor", async function() {
    const { donation, beneficiary } = await loadFixture(deployDonationFixture);
    expect(await donation.beneficiary()).to.equal(beneficiary.address);
  });

  it("should allow users to donate", async function() {
    const { donation, donor } = await loadFixture(deployDonationFixture);

    await donation.connect(donor).donate("Test donation", { value: ethers.utils.parseEther("1.0") });

    expect(await donation.totalDonations()).to.equal(ethers.utils.parseEther("1.0"));
  });

  it("should allow the beneficiary to withdraw funds", async function() {
    const { donation, donor, beneficiary } = await loadFixture(deployDonationFixture);

    await donation.connect(donor).donate("Test donation", { value: ethers.utils.parseEther("1.0") });
    await donation.connect(beneficiary).withdraw();

    expect(await ethers.provider.getBalance(donation.address)).to.equal(0);
  });
});
