// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OtherContract {

    uint256 private _x = 0;

    event Log(uint amount, uint gas);

    // 定义 fallback
    fallback() external payable {}

    // 返回合约 ETF 的余额
    function getBalance() view public returns (uint) {
        return address(this).balance;
    }

    function setX(uint x) payable external {
        _x = x;

        // 如果转入 ETF，则释放 Log
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() view external returns (uint) {
        return _x;
    }
}


contract CallOtherContract {

    // 定义Response事件，输出call返回的结果success和data
    event Response(bool success, bytes data);

    function callSetX(address payable _addr, uint256 x) public payable {
        // call setX()，同时可以发送ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        emit Response(success, data); //释放事件
    }

    function callGetX(address _addr) external returns (uint256){
        // call getX()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success, data); //释放事件
        return abi.decode(data, (uint256));
    }

    function callNonExist(address _addr) external {
        // call getX()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data); //释放事件
    }

    payable(msg.sender).call.value(shares[msg.sender])()

}
