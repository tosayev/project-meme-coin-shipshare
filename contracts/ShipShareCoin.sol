// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// Import ERC20 libraries from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Create contract called ShipShareCoin and use 'is' keyword to inherit the functionalities
// of the ERC20, Ownable and ERC20Burnable libraries into the contract.
contract ShipShareCoin is ERC20, Ownable, ERC20Burnable {
    // Setup Solidity events to enable logging directly to the Ethereum blockchain.
    event tokensBurned(address indexed owner, uint256 amount, string message);
    event tokensMinted(address indexed owner, uint256 amount, string message);
    event additionalTokensMinted(address indexed owner,uint256 amount,string message);

    // Call the ERC20 constructor to initialize the coin.  The constructor function will
    // only be called once - when the coin smart contract is deployed.
    constructor() ERC20("ShipShareCoin","SHIPSHARE") {
        // Mint first batch of the coins.  We will start with 40 million in supply to represent the average
        // USD price for a second hand aframax tanker under 5 years old.  Each coin will represent 1/40 million
        // share of the vessel.
        _mint(msg.sender, 40000000*10**decimals());

        // Log initial mint to the blockchain.
        emit tokensMinted(msg.sender, 40000000 * 10 **decimals(), "Initial supply of tokens minted.");
    }

    // Mint function will allow the owner of the coin to mint coins.  Use onlyOwner specifier to
    // limit the mint function to the owner of the coin smart contract.  In this use case, minting is
    // discouraged - the supply needs to be limited to the initial mint.  The only time when minting
    // makes economical sense is when there will be an upgrade on the vessel which will require capital
    // expenditure.  For example, the installation of a BWTS will require an extra 1 million USD in investment
    // so 1 million SHIPSHARE can be minted and offered to buyers to fund the upgrade.
    function mint(address to, uint256 amount) public onlyOwner {
        // Mint 'amount' number of coins
        _mint(to, amount);

        // Log the minting of the coins to the blockchain.
        emit additionalTokensMinted(msg.sender, amount, "Additional tokens minted.");
    }

    // Burn function will allow the owner of the coin to burn coins. Use override specifier
    // to override the burn() function specified in ER20.sol.  Use onlyOwner specifier to limit
    // the burn function to the owner of the coin smart contract.  In this use case, coins should
    // be burned only in the case of the vessel's sale.
    function burn(uint256 amount) public override onlyOwner {
        // Burn 'amount' number of coins
        _burn(msg.sender, amount);
        
        // Log the burning of the coins to the blockchain.
        emit tokensBurned(msg.sender, amount, "Tokens burned.");
    }
}