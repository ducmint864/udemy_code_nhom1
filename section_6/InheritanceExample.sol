// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

contract Ownable {
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner is allowed to perform this action"); 
        _; }

}

contract  InheritanceModifierExample is Ownable {
    mapping(address => uint) public tokenBalance;

    uint256 tokenPrice = 1 ether;

    constructor() {
        tokenBalance[owner] = 1000;
    }

    function mintToken() public onlyOwner {
        tokenBalance[msg.sender]++;
    }

    function burnToken() public onlyOwner {
        tokenBalance[msg.sender]--;
    }

    function purchaseToken() public payable {
        require((tokenBalance[msg.sender] * tokenPrice) / msg.value > 0, "Not enough tokens");
        uint256 amount = msg.value / tokenPrice;
        tokenBalance[owner] -= amount;
        tokenBalance[msg.sender] += amount;
    }

    function sendToken(address _to, uint256 _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens to send");
        // No need arithmetic underflow and overflow assertion starting from solidity 0.8.0
        // assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        // assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);

        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
    }
}