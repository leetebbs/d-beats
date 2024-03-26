import React, { useState} from 'react'
import { Link } from 'react-router-dom/dist'
import "./Artist.css"
import ArtistCard from '../../components/ArtistCard/ArtistCard'
const Artist = () => {
// create a hook to fetch data from the nft smartcontract
//create a hook to fetch data from marketplace smartcontract to display sales and listing data to artist
  const dummyData = [
    {
      id: 1,
      uri: "https://bafybeigasec73g4h2i4tkwdfr3uy4ncd3phd63b55ujcmbp74hqu2vrhne.ipfs.nftstorage.link/soundbound.json",
    },
    {
      id: 1,
      uri: "https://bafybeigasec73g4h2i4tkwdfr3uy4ncd3phd63b55ujcmbp74hqu2vrhne.ipfs.nftstorage.link/soundbound.json",
    },
    {
      id: 1,
      uri: "https://bafybeigasec73g4h2i4tkwdfr3uy4ncd3phd63b55ujcmbp74hqu2vrhne.ipfs.nftstorage.link/soundbound.json",
    }
  ]
    
  return (
    <div className='artist_container'>
      <h1>Artist Portal</h1>
      <button><Link to="/createNft">Create NFT</Link></button>
      <div className='collection_section'>
        {dummyData.map((data, index) => {
          return (
            <div className='collection' key={index}>
              <ArtistCard data={data} />
            </div>
          )
        })}
      </div>
    </div> 
  )
}

export default Artist