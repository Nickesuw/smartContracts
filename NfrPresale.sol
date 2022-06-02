// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22;
import "./ERC1155.sol";
import "./MultiOwnable.sol";

contract NftPresale is MultiOwnable {

    address private account_address = 0x9674D466aA1951e1632d85D577F39F42Fa85F6A7;
    mapping(address => mapping(uint256 => Listing)) public listings;
    struct Listing{
        uint256 price;
        address seller;
    }

    constructor() { 
        
    }

    function addListing(uint256 price, uint256 tokenId) public onlyOwner {
        ERC1155 token = ERC1155(account_address);
        require(token.balanceOf(msg.sender, tokenId)>0, "caller must own given token");
        require(token.isApprovedForAll(msg.sender, address(this)), "contact must be approved");

        listings[account_address][tokenId] = Listing(price, msg.sender);
    }

    function get_listings(address token_address, uint256 tokenId) public view returns (uint256) {
        return (listings[token_address][tokenId].price);
    }

    function cancelListing(uint256 tokenId) public onlyOwner {
       delete listings[account_address][tokenId];
    }

    function change_address(address new_address) public onlyOwner {
        account_address=new_address;
    }
 
    event Purchase(address indexed _from, uint256 indexed _id, uint256 _amount);
    function purchase(uint256 tokenId, uint256 amount) public payable {
        Listing memory item = listings[account_address][tokenId];
        require(ERC1155(account_address).balanceOf(item.seller, tokenId) >= amount, "enter a smaller quantity");
        require(msg.value>=item.price * amount, "insufficient funds sent");

        ERC1155 token = ERC1155(account_address);
        token.safeTransferFrom(item.seller, msg.sender, tokenId, amount, "");
        emit Purchase(msg.sender, tokenId, amount);
    }

    function withdraw(address payable destAddr) public onlyOwner {
        destAddr.transfer(address(this).balance);
    }
}
