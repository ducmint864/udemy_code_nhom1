// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct PaymentReceived {
    address from;
    uint256 amount;
}

contract Wallet {
    PaymentReceived public payment;

    function payContract() public payable {
        payment.from = msg.sender;
        payment.amount = msg.value;
    }
}