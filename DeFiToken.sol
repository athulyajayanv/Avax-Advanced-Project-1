// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  
contract DeFiToken is ERC20 {

    //Constructor to mint initial supply to the deployer
    constructor(uint256 initialSupply) ERC20("DeFiToken", "DFK") {
        _mint(msg.sender, initialSupply);
    } 

     //Function to burn a specified amount of tokens
     function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
