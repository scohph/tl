import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from "dotenv";
import "hardhat-deploy";
import type { HardhatUserConfig } from "hardhat/config";
import { resolve } from "path";

import "@nomiclabs/hardhat-etherscan";
import "./tasks/accounts";

const dotenvConfigPath: string = process.env.DOTENV_CONFIG_PATH || "./.env";
dotenvConfig({ path: resolve(__dirname, dotenvConfigPath) });

// Ensure that we have all the environment variables we need.
const mnemonic: string | undefined = process.env.MNEMONIC;
if (!mnemonic) {
  throw new Error("Please set your MNEMONIC in a .env file");
}

const privatekey: string | undefined = process.env.PRIVATE_KEY;
if (!privatekey) {
  throw new Error("Please set your private key in a .env file");
}

const chainIds = {
  ganache: 1337,
  hardhat: 31337,
  chiliz: 88888,
  sepolia: 11155111,
  spicy: 88882,
  arbSep: 421614,
};

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",

  gasReporter: {
    currency: "USD",
    enabled: process.env.REPORT_GAS ? true : false,
    excludeContracts: [],
    src: "./contracts",
  },
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
      chainId: chainIds.hardhat,
    },
    chiliz: {
      chainId: chainIds.chiliz,
      url: "https://rpc.chiliz.com",
      accounts: [privatekey],
    },
    spicy: {
      chainId: chainIds.spicy,
      url: "https://spicy-rpc.chiliz.com",
      accounts: [privatekey],
    },
    sepolia: {
      chainId: chainIds.sepolia,
      url: "https://ethereum-sepolia.rpc.subquery.network/public",
      accounts: [privatekey],
    },
    arbSepolia: {
      chainId: chainIds.arbSep,
      url: "https://sepolia-rollup.arbitrum.io/rpc",
      accounts: [privatekey],
    },

    ganache: {
      accounts: {
        mnemonic,
      },
      chainId: chainIds.ganache,
      url: "http://localhost:8545",
    },
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
    tests: "./test",
  },
  solidity: {
    version: "0.8.27",
    settings: {
      evmVersion: "paris",
      metadata: {
        bytecodeHash: "none",
      },
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  typechain: {
    outDir: "types",
    target: "ethers-v5",
  },
};

export default config;
