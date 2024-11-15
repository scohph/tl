// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { IERC20 } from "./interfaces/IERC20.sol";

error InsufficientBalance();
error InsufficientAllowance();

contract Multisend {

    struct TransferItem {
        address recipient;
        uint256 amount;
    }

    function batchTransfer(
        IERC20 _token,
        TransferItem[] calldata _transfers
    ) 
        public 
    {
        uint256 totalAmount = 0;
        uint256 transfersLength = _transfers.length;

        for (uint256 i = 0; i < transfersLength;) {
            totalAmount += _transfers[i].amount;
            unchecked {
                i++;
            }
        }

        if (_token.balanceOf(msg.sender) < totalAmount) revert InsufficientBalance();
        if (_token.allowance(msg.sender, address(this)) < totalAmount) revert InsufficientAllowance();

        for (uint256 i = 0; i < transfersLength;) {
            _token.transferFrom(msg.sender, _transfers[i].recipient, _transfers[i].amount);
            unchecked {
                i++;
            }
        }
    }


}
