// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract ERC721 is IERC721, IERC721Metadata{

    using Address for address;
    using Strings for string;

    string public override name;
    string public override symbol;

    // token belong to owner
    mapping(uint => address) private _owners;
    // owner has the number of tokenId
    mapping(address => uint) private _balances;
    // tokenID 到授权地址的授权映射
    mapping(uint => address) private _tokenApprovals;
    // owner 地址批量授权
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    // 实现 IERC165 接口 supportsInterface
    function supportInterface(byte4 interfaceId) external pure override returns(bool) {
        return  interfaceId == type(IERC721).interfaceId ||
                interfaceId == type(IERC165).interfaceId ||
                interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf(address owner) external view override returns(uint) {
        require(owner != address(0), "owner = zero address");
        return _balances[owner];
    }



}
