// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Test {
    mapping(address => uint256) public balance;

    function sendMoney() public payable {
        balance[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    function withdrawAllMoney() public {
        require(balance[msg.sender] > 0, "Not enough to withdraw");
        balance[msg.sender] = 0;
        (bool sent,) = (msg.sender).call{value: balance[msg.sender]}("");
        require (sent, "Failed to send ether");
    }
}