import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import Navbar from "./components/Header/Navbar";
import Home from "./pages/Home/Home";
import Artist from "./pages/Artist/Artist";
import Create from "./pages/CreateNft/CreateNft";
import Admin from "./pages/Admin/Admin";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import CreateNft from "./pages/CreateNft/CreateNft";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Navbar />,
    children: [
      {
        path: "/",
        element: <Home />,
      },
      {
        path: "/artist",
        element: <Artist />,
      },
      {
        path: "/createNft",
        element: <CreateNft />,
      },
      {
        path: "/admin",
        element: <Admin />,
      },
    ],
  },
]);

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
