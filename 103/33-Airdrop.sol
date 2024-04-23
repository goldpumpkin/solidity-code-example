// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {

    constructor(){
    }

    // total amount of arr
    // calldata ?   public pure
    function getSum(uint256[] calldata arr) public pure returns(uint sum) {
        for(uint8 i=0; i< arr.length; i++) {
            sum += arr[i];
        }
        return sum;
    }

    // multi drop
    // there is no 'int' type
    function multiDrop(address token, address[] calldata recipients, uint256[] calldata arrAmount) external returns (bool) {
        require(recipients.length == arrAmount.length, "Lengths of Addresses and Amounts NOT EQUAL");

        // compare allowance & arrAmount
        uint256 dropTotalAmount = getSum(arrAmount);
        IERC20 t = IERC20(token);
        uint256 allAllowance = t.allowance(msg.sender, address(this));
        require(dropTotalAmount <= allAllowance, "Need Approve ERC20 token");

        // cycle drop
        for(uint8 i = 0; i < arrAmount.length; i++) {
            t.transferFrom(msg.sender, recipients[i], arrAmount[i]);
        }

        return true;
    }

    // address payable[]  calldata?
    function multiTransferPrimitiveCoin(address payable[] calldata recipients, uint256[] calldata arrAmount) public payable {
        require(recipients.length == arrAmount.length, "Lengths of Addresses and Amounts NOT EQUAL");

        uint256 sum = getSum(arrAmount);
        require(sum <= msg.value, "Primitive Coin Not enough");

        for(uint8 i = 0; i< arrAmount.length; i++) {
            recipients[i].transfer(arrAmount[i]);
        }
    }
}
