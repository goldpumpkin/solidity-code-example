// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract C {

    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}


contract B {

    uint public num;
    address public sender;

    // 通过 Call 函数调用
    function callSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) =
        _addr.call(abi.encodeWithSignature("setVars(uint256)", _num));
    }

    function delegateCallSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) =
        _addr.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
    }


}
