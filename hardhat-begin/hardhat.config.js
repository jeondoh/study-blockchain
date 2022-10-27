require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: __dirname + "/.env" });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API}`,
      accounts: [`${process.env.METAMASK_PRIVATE_KEY}`],
    },
    ganache: {
      url: "HTTP://127.0.0.1:7545",
      chainID: "5777",
      accounts: [
        "d4159393f0a9ca6a49c1fecfe041bda293aaebe260bc2594f88c39cb808032b0",
      ],
    },
  },
};
