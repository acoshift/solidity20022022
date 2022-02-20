import * as dotenv from "dotenv";

import { HardhatUserConfig, task, subtask } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
const { getEtherscanEndpoints } = require("@nomiclabs/hardhat-etherscan/dist/src/network/prober")

dotenv.config();

// 0x8c981C9CbAeD63CD509b9Acf5c8FB1E9fCf76BAf

const chainConfig: any = {
  reitestnet: {
    chainId: 55556,
    urls: {
      apiURL: "https://testnet.reiscan.com/api",
      browserURL: "https://testnet.reiscan.com/",
    }
  }
};

subtask('verify:get-etherscan-endpoint').setAction(async (_, { network }) =>
  getEtherscanEndpoints(network.provider, network.name, chainConfig)
);

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    reitestnet: {
      url: "https://rei-testnet-rpc.moonrhythm.io",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: 'hello',
  },
};

export default config;
