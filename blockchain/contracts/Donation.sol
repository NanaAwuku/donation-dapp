// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Donation {
    // Structure to hold donation information
    struct DonationInfo {
        address donor;
        uint256 amount;
        string message;
        uint256 timestamp;
    }

    // Array to hold all donations
    DonationInfo[] public donations;

    // Beneficiary address
    address payable public beneficiary;

    // Constructor to set the beneficiary address at contract deployment
    constructor(address payable _beneficiary) {
        beneficiary = _beneficiary;
    }

    // Function to donate MATIC
    function donate(string memory _message) public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        donations.push(
            DonationInfo(msg.sender, msg.value, _message, block.timestamp)
        );
    }

    // Function to retrieve total donations
    function getTotalDonations() public view returns (uint256 total) {
        for (uint i = 0; i < donations.length; i++) {
            total += donations[i].amount;
        }
    }

    // Function to get donor list
    function getDonorList() public view returns (address[] memory donors) {
        donors = new address[](donations.length);
        for (uint i = 0; i < donations.length; i++) {
            donors[i] = donations[i].donor;
        }
    }

    // Function to withdraw funds to the beneficiary
    function withdraw() public {
        require(msg.sender == beneficiary, "Only the beneficiary can withdraw");
        require(address(this).balance > 0, "No funds to withdraw");
        beneficiary.transfer(address(this).balance);
    }

    // Administrative function to set or change the beneficiary's address
    function setBeneficiary(address payable _newBeneficiary) public {
        beneficiary = _newBeneficiary;
    }

    
}
