import React from "react";
import { Outlet } from "react-router-dom";
import Connect from "./Connect";
import "./Navbar.css";
import {useCheckArtist} from "../../hooks/useCheckArtist";
import { Link } from "react-router-dom/dist";

const Navbar = () => {


  const test = useCheckArtist();
  console.log(test)
  return (
    <>
      <div className="navbar_container">
        <h1 className="logo">D-Beats</h1>
        {test === true ? <div className="artist_menu"><Link to="/artist">Artist Portal</Link></div> : null}
        <Connect />
      </div>
      <Outlet />
    </>
  );
};

export default Navbar;
