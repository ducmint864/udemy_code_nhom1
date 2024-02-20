// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// The easy way to call external contract
contract Receiver {
    mapping(address => uint256) balances;

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    receive() external payable {
        
    }
}

contract Sender {
    function send(address rcvAddress) public {
        Receiver rcv = Receiver(payable(rcvAddress));
        rcv.deposit{value: 1 ether}();
    }

    function topUp() public payable {

    }
}

// The more advanced way to call external contracts
contract Sender2 {
    function send(address rcvAddress) public {
        bytes memory funcSelector = abi.encodeWithSignature("deposit()");
        (bool sent, ) = rcvAddress.call{value: 1 ether}(funcSelector);
        require(sent, "Failed to send ether");
    }
    
    function topUp() public payable {

    }
}

// A little more advanced - sending ether to the receive() function on the Receiver contract:
contract Sender3 {
    function send(address rcvAddress) public {
        (bool sent, ) = rcvAddress.call{value: 1 ether}(""); // empty calldata
        require(sent, "Failed to send ether");
    }

    function topUp() public payable {

    }
}
