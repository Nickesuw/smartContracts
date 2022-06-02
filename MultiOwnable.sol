// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MultiOwnable {
    address public manager; // address used to set owners
    address[] public owners;
    address public _marketing;

    mapping(address => bool) public ownerByAddress;

    event SetOwners(address[] owners);

    modifier onlyOwner() {
        require(ownerByAddress[msg.sender] == true);
        _;  
    }
        constructor() {
            _marketing = 0x51A81B430487fC5b2eA86178Aa609320D55f1E56;
            manager=msg.sender;
            ownerByAddress[msg.sender] == true;
            owners=[msg.sender];
        }

    function setOwners(address[] memory  _owners) public {
        require(msg.sender == manager);
        _setOwners(_owners);
    }

    function setMarketing(address newMarketing) public {
        require(msg.sender == manager);
        _marketing=newMarketing;
    }

    function setManager(address newManager) public {
        require(msg.sender == manager);
        manager=newManager;
    }

    function _setOwners(address[] memory _owners) internal {
        for(uint256 i = 0; i < owners.length; i++) {
            ownerByAddress[owners[i]] = false;
        }

        for(uint256 j = 0; j < _owners.length; j++) {
            ownerByAddress[_owners[j]] = true;
        }
        owners = _owners;
        emit SetOwners(_owners);
    }

    function getOwners() public view returns (address[]memory) {
        return owners;
    }
}

