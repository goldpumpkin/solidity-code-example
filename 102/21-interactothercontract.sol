// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract OtherContract {

    uint256 private _x = 0;

    event Log(uint amount, uint gas);

    // 返回合约 ETF 的余额
    function getBalance() view public  returns (uint) {
        return  address(this).balance;
    }

    function setX(uint x) payable external  {
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

contract CallContract {

    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    // 合约类型可以转为 address
    function callGetX(OtherContract _Address) external view returns (uint x) {
        x =  (_Address).getX();
    }

    // 创建合约的引用
    function callGetX2(address _Address) external view returns (uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    // 调用其他合约并转账
    function setXTransferETH(address _Address, uint256 amount) payable  external  {
        OtherContract(_Address).setX{value: msg.value}(amount);
    }

}