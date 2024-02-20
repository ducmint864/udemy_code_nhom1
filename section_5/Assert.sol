// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract AssertExample {
    mapping(address => uint8) balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
        assert(balanceReceived[msg.sender] >= uint8(msg.value));
    }

    function withdrawMoney(uint8 amount) public {
        require (amount <= balanceReceived[msg.sender]);
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - amount);
        balanceReceived[msg.sender] -= amount;
        (msg.sender).transfer(amount);
    }
}