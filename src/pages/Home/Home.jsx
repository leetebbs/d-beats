import React from 'react'
import "./Home.css"
import coming from "../../assets/images/Coming-soon.jpg"
const Home = () => {
  return (
    <div className='home_container'>
      <img className='coming' src={coming} alt="coming soon" />
    </div>
  )
}

export default Home