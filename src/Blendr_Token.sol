// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol"; 

contract BLENDR is ERC20, ERC20Burnable, Ownable {
    constructor(uint256 initialSupply) ERC20("BLENDR", "BLND") {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    /**
     * @dev Mints new tokens.
     * Can only be called by the contract owner.
     * @param to The address to receive the minted tokens.
     * @param amount The amount of tokens to mint (without considering decimals).
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * (10 ** decimals()));
    }
}