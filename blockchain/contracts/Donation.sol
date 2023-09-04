// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Donation {
  
    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
        string message;
    }

    address payable public owner;

    address payable public beneficiary;

    uint256 public totalDonations;

    mapping(uint256 => Donation) public donations;
    uint256 public donationCount = 0;

    bool private stopped = false;

    event NewDonation(uint256 donationId, address indexed donor, uint256 amount, string message);

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }

    modifier onlyBeneficiary {
        require(msg.sender == beneficiary, "Only beneficiary can perform this operation");
        _;
    }

    modifier stopInEmergency { if (!stopped) _; }
    modifier onlyInEmergency { if (stopped) _; }

    constructor(address payable _beneficiary) {
        owner = payable(msg.sender);
        beneficiary = _beneficiary;
    }

    function donate(string memory message) public payable stopInEmergency {
        require(msg.value > 0, "Donation should be greater than 0");
        donations[donationCount] = Donation(msg.sender, msg.value, block.timestamp, message);
        emit NewDonation(donationCount, msg.sender, msg.value, message);
        donationCount++;
        totalDonations += msg.value;
    }

    function withdraw() public onlyBeneficiary {
        uint256 balance = address(this).balance;
        (bool success, ) = beneficiary.call{value: balance}("");
        require(success, "Transfer failed.");
    }

    function setBeneficiary(address payable _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }

    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }

    function getBalance() public view onlyBeneficiary returns (uint)  {
        return address(this).balance;
    }
}
