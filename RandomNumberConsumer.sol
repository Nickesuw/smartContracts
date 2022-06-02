// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./Card.sol";
import "./MultiOwnable.sol";

contract RandomNumberConsumer is VRFConsumerBase, MultiOwnable {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    uint256 public randomToken;
    address tokenAddress = 0xECf87d4f74704AF166016D5a5f71fDE90C399649;
    address toMint;
    uint256 counter = 1;
    uint256 NUM_CREATURES_PER_BOX = 5;

    event GetRarityFromPack(
        uint256 packNum,
        string cardRarity,
        uint256 countCard
    );

    constructor()
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK token address
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    mapping(uint256 => mapping(string => uint256)) public rarities;
    mapping(string => uint256) public countCards;

    function setTokenAddress(address _newTokenAddress) public onlyOwner {
        tokenAddress = _newTokenAddress;
    }
//TODO: view 
    function getTokenAddress() public view onlyOwner returns (address) {
        return tokenAddress;
    }

    function setCountCards(uint256 newCount) public onlyOwner {
        NUM_CREATURES_PER_BOX = newCount;
    }

    function getRandomNumber(address _toMint, address owner) public {
        require(owner == msg.sender, "only owner");
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK in contract"
        );
        toMint = _toMint;
        requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        Card token = Card(tokenAddress);
        for (uint256 i = 0; i < NUM_CREATURES_PER_BOX; i++) {
            string memory packRarity = getPackRarity(
                (random(randomness + i)) % 10000
            );
            uint256 cardID = getCardID(random(randomness + i), packRarity);
            token.lootBoxMint(toMint, 1, "", cardID);
            emit GetRarityFromPack(counter, packRarity, NUM_CREATURES_PER_BOX);
        }
        counter += 5;
    }

    function setRarities(
        uint256 packId,
        string memory rarityString,
        uint256 amount
    ) public onlyOwner {
        rarities[packId][rarityString] = amount;
    }

    function getCardID(uint256 randomness, string memory packRarity)
        public
        view
        returns (uint256)
    {
        uint256 rarityOffset;
        if (strCompare(packRarity, "common")) {
            rarityOffset = countCards["common"];
        }
        if (strCompare(packRarity, "rare")) {
            rarityOffset = countCards["rare"] + countCards["common"];
        }
        if (strCompare(packRarity, "epic")) {
            rarityOffset =
                countCards["epic"] +
                countCards["common"] +
                countCards["rare"];
        }
        if (strCompare(packRarity, "legendary")) {
            rarityOffset =
                countCards["legendary"] +
                countCards["common"] +
                countCards["rare"] +
                countCards["epic"];
        }
        return randomness % rarityOffset;
    }

    function setCountCards(string memory rarityString, uint256 amount)
        public
        onlyOwner
    {
        countCards[rarityString] = amount;
    }

    function getPackRarity(uint256 randomNum)
        public
        view
        returns (string memory)
    {
        if (randomNum >= rarities[1]["legendary"]) {
            return "legendary";
        }

        if (
            (randomNum >= rarities[1]["epic"]) &&
            (randomNum <= rarities[1]["legendary"])
        ) {
            return "epic";
        }

        if (
            (randomNum >= rarities[1]["rare"]) &&
            (randomNum <= rarities[1]["epic"])
        ) {
            return "rare";
        }
        return "common";
    }

    function random(uint256 number) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(number)));
    }

    function strCompare(string memory s1, string memory s2)
        public
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}

