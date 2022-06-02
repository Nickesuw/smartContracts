// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22;
import "./ERC1155.sol";
import "./MultiOwnable.sol";
// import ".deps/npm/@openzeppelin/contracts/access/Ownable.sol";

contract Collectible is ERC1155, MultiOwnable {

    string private baseURI;
    string public name="pokemons";
    uint256 public count = 0;
    bool public saleIsActive = true;

    constructor() 
        ERC1155('ipfs://QmS9ZADWMk7n2R3tMNbsKXjPxdwv1BdiaAwZxiwkbZaDb8/{id}.json') { 
            // setApprovalForAll(address(this), true);
    }

    function setBaseURI(string memory _newuri) public onlyOwner {
        _setURI(_newuri);
    }

    function burn(address account, uint256 id, uint256 amount) public onlyOwner {
        _burn(account,id,amount);
    }

    function setName(string memory _name) public onlyOwner {
        name = _name;
    }

    function mintBatch(uint256 [] memory ids, uint256 [] memory amounts) public onlyOwner {
        _mintBatch(msg.sender, ids, amounts, '');
        count = count + ids.length;
    }

    function mint(uint256 id, uint256 amount) public onlyOwner {    
        _mint(msg.sender, id, amount, '');
        count++;
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    } 

    function balanceOf(address account) public view returns (uint){
        uint256 balance = 0;

        for (uint256 i = 0; i < count; ++i) {
            balance = balance + _balances[i+1][account];
        }
        return balance;
    }
}

