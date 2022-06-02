// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MultiOwnable.sol";

contract Card is ERC1155, MultiOwnable {
    constructor()
        ERC1155(
            "ipfs://QmaFvWb5ZjeMVQ8rt3PhD88Ff1dVynhRDYNG3uaJ4Nf6Ed/{packId}.json"
        )
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function lootBoxMint(
        address account,
        uint256 amount,
        bytes memory data,
        uint256 cardID
    ) public onlyOwner {
        _mint(account, cardID, amount, data);
    }

    function mintCard(
        address account,
        uint256 tokenpackId,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, tokenpackId, amount, data);
    }

    function burnCard(
        address account,
        uint256 packId,
        uint256 amount
    ) public onlyOwner {
        _burn(account, packId, amount);
    }

    function mintBatchCard(
        address to,
        uint256[] memory packIds,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, packIds, amounts, data);
    }
}

