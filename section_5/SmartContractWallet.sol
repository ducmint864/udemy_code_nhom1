// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract SampleWallet {
    mapping (address => bool) public isGuardian;
    mapping (address => bool) public isAllowedToSend;
    mapping (address => uint256) public allowances;
    address internal owner;
    address internal nextOwner; 
    uint256 public nextOwnerVote;
    uint256 public constant nextOwnerVoteThreshold = 3;

    constructor() {
        owner = msg.sender;
        isGuardian[msg.sender] = true;
    }

    function proposeNewOwner(address payable newOwner) public {
        require(isGuardian[msg.sender], "You have no permission to propose new owner");
        require (newOwner != address(0), "New owner must not be adddress 0");

        if (nextOwner != newOwner) {
            nextOwner = newOwner;
            nextOwnerVote = 0;
        }
        nextOwnerVote++;
        if (nextOwnerVote >= nextOwnerVoteThreshold) {
            owner = nextOwner;
            nextOwner = payable(address(0));
            nextOwnerVote  = 0;
        }
    }    

    function denySending(address deniedSender) public ownerOnly {
        isAllowedToSend[deniedSender] = false;
    }

    function setAllowance(address spender, uint256 amount) public ownerOnly {
        allowances[spender] = amount;
        isAllowedToSend[spender] = true;
    }

    function setGuardian(address guardian) public ownerOnly {
        isGuardian[guardian] = true;
    }


    function transfer(address to, uint256 amount, bytes memory payload) public returns (bytes memory) {
        require (amount <= address(this).balance, "Contract doesn't have enough money to send");
        if (msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send money");
            require(amount <= allowances[msg.sender], "Amount to send has exceeded your allowance");
            allowances[msg.sender] -= amount;
        }

        (bool sent, bytes memory result) = payable(to).call{value: amount}(payload);
        require(sent, "Trasnfer failed");
        return result;
    }

    receive() external payable {

    }

    modifier ownerOnly() {
        require (msg.sender == owner, "You are not allowed to perform this action");
        _;
    }
}