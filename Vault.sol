// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./DeFiToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is Ownable {
    DeFiToken private _token; 

    enum PlayerLevel { Beginner, Intermediate, Advanced, Expert }
    mapping(address => PlayerLevel) public playerLevels;
    mapping(address => uint256) public playerDiamonds; 

    //Events for logging actions
    event CoinsDeposited(address indexed sender, uint256 amount);
    event CoinsWithdrawn(address indexed recipient, uint256 amount);
    event TokensRedeemed(address indexed recipient, uint256 amount);
    event PlayerLeveledUp(address indexed player, PlayerLevel newLevel);
    event DiamondsEarned(address indexed player, uint256 amount);

    //Constructor to set token address and initial owner
    constructor(address tokenAddress, address initialOwner) Ownable(initialOwner) {
        _token = DeFiToken(tokenAddress);
    }

     //Function to deposit coins into the vault
    function depositCoins(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(_token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit CoinsDeposited(msg.sender, amount);
    }

     //Function to withdraw coins from the vault
    function withdrawCoins(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(_token.balanceOf(address(this)) >= amount, "Insufficient balance in Vault");
        require(_token.transfer(owner(), amount), "Transfer failed");
        emit CoinsWithdrawn(owner(), amount);
    }

    //Function to redeem tokens from the vault
    function redeemTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(_token.balanceOf(address(this)) >= amount, "Insufficient balance in Vault");
        require(_token.transfer(msg.sender, amount), "Transfer failed");
        emit TokensRedeemed(msg.sender, amount);
    } 

    //Function to check vault balance
    function vaultBalance() external view returns (uint256) {
        return _token.balanceOf(address(this));
    }

    //Function for the owner to award diamonds to a player
    function earnDiamonds(address player, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        playerDiamonds[player] += amount;
        emit DiamondsEarned(player, amount);
    }

    //Function for the owner to level up a player
    function levelUp(address player) external onlyOwner {
        PlayerLevel currentLevel = playerLevels[player];
        require(currentLevel != PlayerLevel.Expert, "Player is already at the highest level");
        
        PlayerLevel newLevel = PlayerLevel(uint(currentLevel) + 1);
        playerLevels[player] = newLevel;
        emit PlayerLeveledUp(player, newLevel);
    }

    //Function to get a player's level
    function getPlayerLevel(address player) external view returns (PlayerLevel) {
        return playerLevels[player];
    }

    //Function to get a player's diamond count
    function getPlayerDiamonds(address player) external view returns (uint256) {
        return playerDiamonds[player];
    }
}
