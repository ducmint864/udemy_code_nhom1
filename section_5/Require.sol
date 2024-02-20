// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ExampleRequire {
    mapping (address => uint256) balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(uint256 amount) public {
        require(amount <= balanceReceived[msg.sender], "Not enough money to withdraw");
        balanceReceived[msg.sender] -= amount;
        (bool sent, ) = (msg.sender).call{value: balanceReceived[msg.sender]}("");
        require(sent, "Failed to send Ether");
    }   
}