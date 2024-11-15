// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TRLOOP is ERC20, ERC20Burnable, ERC20Permit, Ownable {

    constructor(
        address _initialOwner
    ) 
        ERC20("TRLOOP", "TRLOOP") 
        Ownable(_initialOwner) 
        ERC20Permit("TRLOOP") 
    {
        _mint(_initialOwner, 10_000_000 * 10 ** decimals());
    }

    function decimals(
    ) 
        public 
        pure 
        override 
        returns (
            uint8 dec_
        )
    {
        dec_ = 18;
    }
}