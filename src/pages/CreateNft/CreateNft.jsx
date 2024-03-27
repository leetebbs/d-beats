import React, { useState } from 'react';
import './CreateNft.css';

const CreateNft = () => {
 const [currentImage, setCurrentImage] = useState();
 const [name , setName] = useState("")
 const [previewImage, setPreviewImage] = useState("");
 const [musicTracks, setMusicTracks] = useState();
 const [progress, setProgress] = useState(0);
 const [message, setMessage] = useState("");

 const selectImage = (event) => {
    const selectedFiles = event.target.files;
    setCurrentImage(selectedFiles?.[0]);
    setPreviewImage(URL.createObjectURL(selectedFiles?.[0]));
    setProgress(0);
 };

 const selectMusicTracks = (event) => {
    setMusicTracks(event.target.files);
 };

 const upload = () => {
    setProgress(0);
    if (!currentImage || !musicTracks) return;

    // Here you would call your API to upload the image and music tracks
    // For demonstration purposes, we'll just simulate the upload process
    setProgress(50); // Simulate upload progress
    setTimeout(() => {
      setProgress(100); // Simulate completion
      setMessage("Upload successful!");
    }, 2000);
 };

 return (
    <div className='createNft_container'>
      <h2>Nft Name</h2>
          <input type="text" placeholder="Name" onChange={(e) => setName(e.target.value)} />
      <div>
        <div>
          <h2>image</h2>
            <input type="file" accept="image/*" onChange={selectImage} />
        </div>
        <div>
          <button
            
            disabled={!currentImage}
            onClick={upload}
          >
            Upload Image
          </button>
        </div>
      </div>
      {previewImage && (
        <div>
          <img className="preview" src={previewImage} alt="" />
        </div>
      )}
      <div>
        <div>
          <label>
            <input type="file" accept="audio/*" multiple onChange={selectMusicTracks} />
          </label>
        </div>
        <div>
          <button
            
            disabled={!musicTracks || musicTracks.length === 0}
            onClick={upload}
          >
            Upload Music Tracks
          </button>
        </div>
      </div>
      {progress > 0 && (
        <div>
          <div
            
            role="progressbar"
            aria-valuenow={progress}
            aria-valuemin={0}
            aria-valuemax={100}
            style={{ width: progress + "%" }}
          >
            {progress}%
          </div>
        </div>
      )}
      {message && (
        <div>
          {message}
        </div>
      )}
    </div>
 );
};

export default CreateNft;
