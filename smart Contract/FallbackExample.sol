//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    //we need not to write function keyword. fot receive and falllback
    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 1;
    }
}
