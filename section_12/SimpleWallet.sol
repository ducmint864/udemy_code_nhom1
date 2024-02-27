// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

pragma solidity ^0.8.20;

contract SimpleWallet is Ownable {
    event AllowanceChanged(address indexed allowee, uint256 indexed oldAmount, uint256 indexed newAmount);
    event MoneyReceived(address indexed from, uint256 indexed amount);
    event MoneySent(address indexed to, uint256 indexed amount);

    mapping (address => uint256) public allowance;

    constructor() Ownable(msg.sender) {
    }

    function addAllowance(address to, uint256 amount) public onlyOwner {
        emit AllowanceChanged(to, allowance[to], amount);
        allowance[to] = amount;
    }

    function withdrawMoney(address to, uint256 amount) public allowedOrOwner(amount) {
        require(amount <= address(this).balance, "Not enough money in this contract");
        emit MoneySent(to, amount);
        if (_msgSender() != owner()) {
            _reduceAllowance(to, amount);
        }
        payable(to).transfer(amount);
    }

    function _reduceAllowance(address to, uint256 amount) internal {
        emit AllowanceChanged(to, allowance[to], allowance[to] - amount);
        allowance[to] -= amount;
    }

    function renounceOwnership() public pure override {
        revert("Can't renounce ownership here");
    }

    fallback() external payable {
        if (msg.value > 0) {
            emit MoneyReceived(_msgSender(), msg.value);
        }
    }

    receive() external payable {
        emit MoneyReceived(_msgSender(), msg.value);
    }

    modifier allowedOrOwner(uint256 amount) {
        if (allowance[_msgSender()] < amount) {
            _checkOwner();
        }
        _;
    }
}

