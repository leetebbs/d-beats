import React, { useEffect, useState } from 'react';
import "./Admin.css";
import { useWeb3ModalAccount } from '@web3modal/ethers5/react';
import { DBeatsFactoryAddress, DBeatsFactoryAbi, artistNftAddress, artistNftAbi,artistNFTURI } from '../../components/config/config';
import { ethers } from 'ethers';

const Admin = () => {
    const { address, chainId, isConnected } = useWeb3ModalAccount();
    const adminAddresses = ["0x1ABc133C222a185fEde2664388F08ca12C208F76","0xdb035c42e12ee11f1D47797954C25EE36C3dC77c"]; //ADMIN_ADDRESSES
    const [isAdmin, setIsAdmin] = useState(false);
    const role = "0xa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775";//ADMIN_ROLE
    const [verifyAddress, setVerifyAddress] = useState("");//set verified address
    const [error, setError] = useState(""); // State for error handling
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const factoryContract = new ethers.Contract(DBeatsFactoryAddress, DBeatsFactoryAbi, signer);
    const artistContract = new ethers.Contract(artistNftAddress, artistNftAbi, signer);
    //check if address is admin
    useEffect(() => {
        if (isConnected) {
            if (adminAddresses.includes(address)) {
                setIsAdmin(true);
            }
        }
        console.log(isAdmin);
    }, [isConnected, address]);

  //grant admin role to verified address
    async function setVerified() {
        try {
            await factoryContract.grantRole(role, verifyAddress);
            console.log("verified");
        } catch (error) {
            console.log(error);
            setError("Failed to verify address. Please try again."); // Set error message
        }
    }

    async function mintArtistNFT() {
        try {
            const tx =  await artistContract.safeMint(verifyAddress, artistNFTURI);
            console.log(tx);
        } catch (error) {
            console.log(error);
        }
    }
    return (
        <div>
            {isAdmin ? <div>
                <div className='admin_container'>
                    <h2>Verify Artist Address</h2>
                    <form>
                        <label>
                            <input className='admin_input' type="text" placeholder='Enter verified address' onChange={(e) => setVerifyAddress(e.target.value)}/>   
                        </label>
                    </form>
                    <button onClick={setVerified}>Verify</button>
                    <button onClick={mintArtistNFT}>Mint</button>
                    {error && <p>{error}</p>} {/* Display error message */}
                </div>
            </div> : <h1>Not Admin</h1>}
        </div>
    );
}

export default Admin;
