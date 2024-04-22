// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20 is IERC20 {

    // 事件重复定义了，仅展示
    // event Transfer(address indexed from, address indexed to, uint256 value);
    // event Approve(address indexed owner, address indexed spender, uint256 value);

    // balance
    mapping(address => uint256) public override balanceOf;

    // totalSupply
    uint256 public override totalSupply;

    // allowance
    mapping(address => mapping(address => uint256)) public override allowance;

    // name
    string public name;

    // symbol
    string public symbol;

    // decimal
    uint8 public decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    // transfer
    function transfer(address recipient, uint amount) external override returns (bool)  {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    // transferFrom - 调用者是被授权方
    function transferFrom(address sender, address recipient, uint amount) external override returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    // mint - not ERC20 function
    function mint(uint256 amount) external public {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // burn - not ERC20 function
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}
