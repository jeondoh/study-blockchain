const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(
    `Account balance(eth): ${ethers.utils.formatEther(
      (await deployer.getBalance()).toBigInt()
    )}`
  );

  const Token = await ethers.getContractFactory("Token");
  const startTime = new Date();
  const contract = await Token.deploy().catch((error) => console.log(error));
  const { chainId, hash, gasPrice, gasLimit, nonce } =
    contract.deployTransaction;
  await contract.deployed();
  const endTime = new Date();
  const resultTime = endTime - startTime;
  const resultSecond = (resultTime / 1000) % 60;
  console.log(resultSecond);

  if (resultSecond >= 30) {
    console.log("시간초과 함수종료");
    process.exit(0);
  }

  console.log(`Token Address : ${contract.address}`);
  console.log(`chainId : ${chainId}`);
  console.log(`nonce : ${nonce}`);
  console.log(`hash : ${hash}`);
  console.log(`gasPrice : ${ethers.utils.formatEther(gasPrice)}`);
  console.log(`gasLimit : ${gasLimit}`);
  console.log(
    `gas Total(eth) : ${ethers.utils.formatEther(gasPrice.mul(gasLimit))}`
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
