// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./ERC721Tradable.sol";
import "./Creature.sol";
import "./RandomNumberConsumer.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./MultiOwnable.sol";
import "./RandomNumberConsumer.sol";

/**
 * @title CreatureLootBox
 *
 * CreatureLootBox - a tradeable loot box of Creatures.
 */

contract CardPack is ERC721Tradable, Pausable {
    address randomnessProviderAddress =
        0x3adcd648B57Eb26e488a6A8c8d86bC9B6B2d75da;

    constructor(address _proxyRegistryAddress, address _factoryAddress)
        ERC721Tradable("CardPack", "CARDPACK", _proxyRegistryAddress)
    {}

    function unpack(uint256 _tokenId) public whenNotPaused {
        require(ownerOf(_tokenId) == _msgSender());
        RandomNumberConsumer rndConsumer = RandomNumberConsumer(
            randomnessProviderAddress
        );
        rndConsumer.getRandomNumber(msg.sender, address(this));
        _burn(_tokenId);
    }

    function burn(uint256 _tokenId) public onlyOwner {
        _burn(_tokenId);
    }

    function setRandomAddress(address NewToken) public onlyOwner {
        randomnessProviderAddress = NewToken;
    }

    function getRandomAddress() public view onlyOwner returns (address) {
        return randomnessProviderAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function baseTokenURI() public pure override returns (string memory) {
        return "https://creatures-api.opensea.io/api/box/";
    }
}

