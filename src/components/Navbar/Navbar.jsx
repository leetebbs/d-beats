import React from 'react'
import { Outlet } from "react-router-dom";
import './Navbar.css'
const Navbar = () => {
  return (
    <>
    <div className='navbar_container'>
      <h1 className='logo'>D-Beats</h1>
      <button>Connect</button>
    </div>
    <Outlet />
    </>
  )
}

export default Navbar