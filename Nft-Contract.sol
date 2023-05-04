//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



// Parent contract (factory contract)
contract Parent {
    Creative[] public children;
    mapping (string=> address) public creativeAddress;
    function createChildren(string memory baseURI,string memory name,string memory symbol, address[] memory Adress) public {
    
     for(uint256 i = 0; i < Adress.length; i++){
          Creative child = new Creative(baseURI,name,symbol,Adress);
          children.push(child);
     }

    }
    
    function getChildValue(uint256 _index) public view returns (address) {
        return address(children[_index]);
    }
}


contract Creative is ERC721URIStorage, Ownable {

    string public  _baseTokenURI;
    bool private  _paused;
    uint256 public tokenIds;
    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor ( string memory baseURI,string memory name,string memory symbol, address[] memory Adress) ERC721(name,symbol) {
       _baseTokenURI = baseURI;      
        bulkMint(baseURI,Adress);
        
    }
      
    function bulkMint(string memory baseURI, address[] memory Adress) public onlyWhenNotPaused{
        _baseTokenURI = baseURI;
        for(uint256 j = 0; j < Adress.length; j++) {
           tokenIds += 1;
              _safeMint(Adress[j], tokenIds);    
  
        }
        
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    _requireMinted(tokenId);

    return _baseTokenURI;
    }


    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

}
