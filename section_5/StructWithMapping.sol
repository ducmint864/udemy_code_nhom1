// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract StructWithMapping {
    struct Transaction {
        uint256 amount;
        uint256 timestamp;
    }

    struct Account {
        uint256 totalBalance;
        uint256 numDeposits;
        mapping(uint256 => Transaction) deposits;
        uint256 numWithdrawals;
        mapping(uint256 => Transaction) withdrawals;
    }

    mapping(address => Account) accounts;

    function getDeposit(uint256 _numDeposit) public view returns (Transaction memory) {
        return accounts[msg.sender].deposits[_numDeposit];
    }

    function getNumDeposit() public view returns (uint256) {
        return accounts[msg.sender].numDeposits;
    }

    function getWithdrawal(uint256 _numWithdrawal) public view returns (Transaction memory) {
        return accounts[msg.sender].withdrawals[_numWithdrawal];
    }

    function getWithdrawalNum() public view returns (uint256) {
        return accounts[msg.sender].numWithdrawals;
    }

    function depositMoney() public payable {
        accounts[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        accounts[msg.sender].deposits[accounts[msg.sender].numDeposits] = deposit;
        accounts[msg.sender].numDeposits++;
    }

    function withdrawMoney() public payable {

    }
}