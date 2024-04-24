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

    // 实现 IERC721 的 balanceOf，利用 _balances 变量查询 owner 地址的 balance。
    function balanceOf(address owner) external view override returns(uint) {
        require(owner != address(0), "owner = zero address");
        return _balances[owner];
    }

    // 实现 IERC721 的 ownerOf，利用 _owners 变量查询 tokenId 的 owner。
    function ownerOf(uint tokenId) public view override returns(address owner) {
        owner = _owners[tokenId];
        require(owner != address(0), "token doesn't exist");
    }

    // 实现 IERC721 的 isApprovedForAll，利用 _operatorApprovals 变量查询 owner 地址是否将所持 NFT 批量授权给了 operator 地址。
    function isApprovedForAll(address owner, address operator) external view override returns(bool) {
        return _operatorApprovals[owner][operator];
    }

    // 实现 IERC721 的 setApprovalForAll，将持有代币全部授权给 operator 地址。调用 _setApprovalForAll 函数。
    function serApprovedForAll(address operator, bool approved) external override {
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // 实现 IERC721 的 getApproved，利用 _tokenApprovals 变量查询 tokenId 的授权地址。
    function getApproved(uint tokenId) external view override returns(address) {
        require(_owners[tokenId] != address(0), "token doesn't exist");
        return _tokenApprovals[tokenId];
    }

    function _approve(address owner, address to, uint tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function approve(address to, uint tokenId) external override {
        address owner = _owners[tokenId];
        require(owner == msg.sender || _operatorApprovals[owner][msg.sender], "not owner nor approved for all");
        _approve(owner, to, tokenId);
    }

    function _isApprovedOrOwner(address owner, address spender, uint tokenId) private view returns(bool) {
        return (spender == owner || _operatorApprovals[owner][spender] || _tokenApprovals[tokenId] == spender);
    }

    function _transfer(address owner, address from, address to, uint tokenId) private {
        require(from == owner,  "not owner");
        require(to != address(0), "transfer to the zero address");

        _approve(owner, address(0), tokenId);

         _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
}
