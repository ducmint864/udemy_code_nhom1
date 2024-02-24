pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../src/ERC721Implementation.sol";

error OwnableUnauthorizedAccount(address account);
error ERC721IncorrectOwner(address from, uint256 tokenId, address previousOwner);

contract CatNFTTest is Test {
    address mockDeployer;
    CatNFT cat;

    function setUp() public {
        mockDeployer = address(this);
        cat = new CatNFT(mockDeployer);
    }

    function testOwnerIsTestContract() public {
        assertEq(cat.owner(), mockDeployer);
    }

    function testMintingNFTs() public {
        cat.safeMint(msg.sender, "spacebear_1.json");
        assertEq(cat.ownerOf(0), msg.sender);
        assertEq(cat.tokenURI(0), "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_1.json");
    }

    function testNFTCreationWrongOwner() public {
        vm.startPrank(address(0x1));
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, address(0x1)));
        cat.safeMint(address(0x1), "spacebear_1.json");
        vm.stopPrank();
    }
    
    function testNFTTransferToken() public {
        address nftOwner = msg.sender;
        cat.safeMint(msg.sender, "spacebear_1.json");
        
        // Pretends to be NFT owner
        vm.startPrank(nftOwner);
        cat.transferFrom(nftOwner, address(0x1), 0);
        assertEq(cat.ownerOf(0), address(0x1));
        vm.stopPrank();
    }
}
