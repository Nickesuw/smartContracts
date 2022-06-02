// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22;

import "./MultiOwnable.sol";
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
contract ARCD is ERC20, MultiOwnable {
    constructor() ERC20('ARCD','ARCD'){
        _mint(msg.sender,600000);
    }
    event 
    make[map[] string map[]float, map[] int, map[] ]
    
    function mint(address to, uint amount) external onlyOwner{
        _mint(to,amount);
    }

    function burn(uint amount) external onlyOwner {
        _burn(msg.sender, amount);
    }

    function safeMint(address to, uint amount) override onlyOwner{
        _safeMint(to, ammount, address(this));
    }

    function safeTransferFrom(address _to, address _from, byte [] data memory) public view returns(uint){
        _safeTransferFrom(_to, _from, data);
    }
}


