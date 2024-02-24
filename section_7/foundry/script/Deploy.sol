pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ERC721Implementation.sol";

contract DeployCatNFT is Script {
    address nftOperator;
    uint256 privateKey;


    function setUp() public {
        string memory seedPhrase = vm.readFile(".secret");
        privateKey = vm.deriveKey(seedPhrase, 0);
        nftOperator = vm.addr(privateKey);
    }

    function run() public {
        vm.startBroadcast(privateKey);
        CatNFT cat = new CatNFT(nftOperator);
        vm.stopBroadcast();
    }
}