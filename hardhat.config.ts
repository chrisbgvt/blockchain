import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-network-helpers";
import "@nomicfoundation/hardhat-chai-matchers/withArgs";
import '@nomiclabs/hardhat-ethers';

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.18',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    // rinkeby: {
    //   url: process.env.DEPLOY_ENDPOINT_RINKEBY,
    //   accounts: [process.env.DEPLOY_ACC_RINKEBY as string],
    // },
    // mainnet: {
    //   url: process.env.DEPLOY_ENDPOINT_MAIN,
    //   accounts: [process.env.DEPLOY_ACC_MAIN as string],
    // },
  },
};

export default config;
