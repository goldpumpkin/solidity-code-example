## Faucet

1. 首先部署 ERC20 合约，获取合约地址
2. 部署 Faucet 合约，并填写 ERC20 的合约地址
3. 调用 ERC20 `mint`  给当前 EOA 用户铸币
4. 调用 ERC20 `transfer` 给 Faucet 合约地址
5. 切换 EOA 账户，调用 `requestToken` 领取代币

## Airdrop

1. 首先部署 ERC20 合约，获取合约地址
2. 部署 Airdrop 合约
3. ERC20 `mint` 给当前 EOA 用户
4. 调用 ERC20 `approve` 给 Airdrop 合约地址授权
5. 调用 Airdrop 合约发放代币方法，本质是 `transferFrom` 方法

