require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({path: __dirname + '/.env'});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.17",
    networks: {
        goerli: {
            url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API}`,
            accounts: [`${process.env.METAMASK_PRIVATE_KEY}`]
        }
    }
};
