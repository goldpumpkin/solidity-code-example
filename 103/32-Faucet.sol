// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Faucet {

    event SendToken(address indexed receiver, uint256 indexed amount);

    // faucet 发放地址
    address public tokenContract;

    // 记录领取过代币的地址
    mapping(address => bool) public requestAddress;

    // 每次领取数量
    uint256 public amountAllowed = 100;

    constructor(address tokenContract_){
        tokenContract = tokenContract_;
    }

    function requestToken() external returns(bool) {
        require(requestAddress[msg.sender] == false, "this address had requested.");

        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) >= amountAllowed, "Faucet empty");

        token.transfer(msg.sender, amountAllowed);

        requestAddress[msg.sender] = true;

        emit SendToken(msg.sender, amountAllowed);
        return true;
    }




}
