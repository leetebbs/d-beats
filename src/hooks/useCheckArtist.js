import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { useWeb3ModalAccount } from '@web3modal/ethers5/react';
import { artistNftAddress, artistNftAbi } from "../components/config/config";

export function useCheckArtist() {
    const { address, chainId, isConnected } = useWeb3ModalAccount();
    const [isArtist, setIsArtist] = useState(false);

    useEffect(() => {
        if (isConnected) {
            const check = async () => {
                try {
                    const provider = new ethers.providers.JsonRpcProvider(process.env.REACT_APP_ARB_SEPOLIA_RPC_URL);
                    const contract = new ethers.Contract(artistNftAddress, artistNftAbi, provider);
                    const result = await contract.balanceOf(address);
                    console.log(result.toString());
                    if (result.gt(0)) {
                        setIsArtist(true);
                    }
                } catch (error) {
                    console.error("Error checking artist status:", error);
                }
            };
            check();
        }
    }, [address, isConnected]);

    return isArtist;
}
