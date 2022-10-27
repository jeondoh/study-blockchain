const { ethers } = require("hardhat");
const { rpcLog } = require("hardhat/internal/core/jsonrpc/types/output/log");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(
    `Account balance(eth): ${ethers.utils.formatEther(
      (await deployer.getBalance()).toBigInt()
    )}`
  );

  const Token = await ethers.getContractFactory("Token");
  const contract = await Token.deploy().catch((error) => console.log(error));
  const { chainId, hash, gasPrice, gasLimit, nonce } =
    contract.deployTransaction;

  console.log(`Token Address : ${contract.address}`);
  console.log(`chainId : ${chainId}`);
  console.log(`nonce : ${nonce}`);
  console.log(`hash : ${hash}`);
  console.log(`gasPrice : ${gasPrice}`);
  console.log(`gasLimit : ${gasLimit}`);
  console.log(
    `gas Total(eth) : ${ethers.utils.formatEther(gasPrice.mul(gasLimit))}`
  );

  await contract.deployed();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
