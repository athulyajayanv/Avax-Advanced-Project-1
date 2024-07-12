# METACRAFTERS AVAX ADVANCED PROJECT 1

This Solidity program defines a Vault contract that works with a custom ERC20 token, DeFiToken, enabling coin deposits, withdrawals, token redemptions, player level management, and diamond earnings in a game like environment.

## Description

This Solidity contract, Vault, interacts with the custom ERC20 token DeFiToken to manage game related functionalities like depositing and withdrawing coins, redeeming tokens, leveling up players, and earning diamonds. The contract leverages OpenZeppelin's Ownable extension to restrict certain functions to the contract owner. It also tracks player levels and diamond earnings, demonstrating a comprehensive use of mappings and events for game mechanics.

1. Constructor:
The constructor initializes the contract with the address of the DeFiToken and sets the initial owner of the Vault.

2. mintTokens:
The mintTokens function allows the contract owner to mint new DeFiTokens to a specified recipient. It ensures the amount is valid and mints the tokens. It emits the TokensMinted event.

3. burnTokens:
The burnTokens function allows the contract owner to burn a specified amount of DeFiTokens from a player's balance. It ensures the amount is valid and within the player's balance before burning the tokens. It emits the TokensBurned event.

4. depositCoins:
The depositCoins function allows players to deposit their DeFiTokens into the Vault. It ensures the amount is valid and transfers the tokens from the player to the Vault. It emits the CoinsDeposited event.

5. withdrawCoins:
The withdrawCoins function allows the contract owner to withdraw DeFiTokens from the Vault. It checks the Vault's balance and transfers the specified amount to the owner. It emits the CoinsWithdrawn event.

6. redeemTokens:
The redeemTokens function allows players to redeem (withdraw) their DeFiTokens from the Vault. It verifies the Vault's balance and transfers the specified amount to the player. It emits the TokensRedeemed event.

7. vaultBalance:
The vaultBalance function returns the current balance of DeFiTokens in the Vault.

8. earnDiamonds:
The earnDiamonds function allows the contract owner to award diamonds to a player. It increments the player's diamond count and emits the DiamondsEarned event.

9. levelUp:
The levelUp function allows the contract owner to level up a player. It ensures the player is not already at the highest level (Expert) and upgrades their level. It emits the PlayerLeveledUp event.

10. getPlayerLevel:
The getPlayerLevel function returns the current level of a specified player.

11. getPlayerDiamonds:
The getPlayerDiamonds function returns the current diamond count of a specified player.

## Getting Started

### Executing program

1. To run this program, you can use Remix at https://remix.ethereum.org/.
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Save the file with a .sol extension.

## DeFiToken.sol
```javascript
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
```

## Vault.sol
```javascript
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
```
## Creating and Deploying an EVM Subnet

1. Install the Avalanche CLI.
2. Run this in your terminal:
 ```
   avalanche subnet create mySubnet
```
3. Select SubnetEVM and configure:

ChainId: 12345567

Token symbol: MYSUBNET

Use latest version

Low disk use / Low throughput

Airdrop 1 million tokens to the default address

5. Run this in your terminal:
   
   ```
   avalanche subnet deploy mySubnet
   ```
7. Select local network deployment.

## Connecting to MetaMask

1. Open MetaMask.
2. Go to Networks > Add a network > Add a network manually.
3. Enter the provided details and click Save.
4. Also import the provided private key into the metamask account.
   
## To compile the code,

1. Go to the 'Solidity Compiler' tab on the left.
2. Set the Compiler to 0.8.24 or a compatible version, and click Compile.
   
## Once compiled,

1. Go to the 'Deploy & Run Transactions' tab on the left.
2. Ensure the Environment is set to "Injected Web3" to connect with metamask wallet, for a local test environment.
3. Deploy the DeFiToken contract on Remix, copy its deployed address, then use this address to deploy the Vault contract.

After deploying, you can interact with the contract.

## Stop the Local Subnet

Type this in your terminal:

```
avalanche network stop
```

## Authors

Athulya Jayan V

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
