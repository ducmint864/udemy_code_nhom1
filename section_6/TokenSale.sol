// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSale {
    uint immutable FEE_PERCENTAGE = 5;

    constructor(uint feePercentage) {
        FEE_PERCENTAGE = feePercentage;
    }

    function purchaseERC20Token(address _tokenAddrss) public {
        uint256 tokenPriceWei = 1 ether; // Simluate getting token price
        require(msg.value > tokenPriceWei, "Not enough money to purchase");

        IERC20 token = IERC20(_tokenAddrss);
        
        uint256 fee = getFee(msg.value);
        uint256 purchaseAmount = (msg.value - fee) / tokenPriceWei;
        uint256 remainder = msg.value - fee - (purchaseAmount * tokenPriceWei);
        token.transfer(msg.sender, purchaseAmount);
        (bool sent,) = payable(msg.sender).call{value: remainder }("");
        require(sent, "Failed to send remainder to user");
    }

    function _getFee(uint256 amount) internal view returns (uint256) {
        return amount * FEE_PERCENTAGE;
    }
    
}