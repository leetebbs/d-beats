import "./App.css";
import Navbar from "./components/Header/Navbar";

import { createWeb3Modal, defaultConfig } from "@web3modal/ethers5/react";

const projectId = process.env.REACT_APP_WALLETCONNECT_ID;

const mainnet = {
  chainId: 1,
  name: "Ethereum",
  currency: "ETH",
  explorerUrl: "https://etherscan.io",
  rpcUrl: process.env.REACT_APP_ETH_RPC_URL,
};
const arbitrum = {
  chainId: 42161,
  name: "Arbitrum",
  currency: "ETH",
  explorerUrl: "https://arbiscan.io",
  rpcUrl: process.env.REACT_APP_ARB_RPC_URL,
};
const arbitrumSepolia = {
  chainId: 421614,
  name: "Arbitrum Sepolia",
  currency: "ETH",
  explorerUrl: "https://sepolia.arbiscan.io",
  rpcUrl: process.env.REACT_APP_ARB_SEPOLIA_RPC_URL,
};

// Create a metadata object
const metadata = {
  name: "DBeats",
  description: "Dbeats for your music needs",
  url: "https://d-beats.vercel.app",
};

// Create Ethers config
const ethersConfig = defaultConfig({
  metadata,
  enableEIP6963: true, // true by default
  enableInjected: true, // true by default
  enableCoinbase: true, // true by default
  defaultChainId: 1, // used for the Coinbase SDK
});

// Create a Web3Modal instance
createWeb3Modal({
  ethersConfig,
  chains: [mainnet, arbitrum, arbitrumSepolia],
  projectId,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
});

function App() {
  return (
    <div className="App">
      <Navbar />
    </div>
  );
}

export default App;
