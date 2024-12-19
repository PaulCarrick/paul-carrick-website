// /app/javascript/components/RenderSingleImage.jsx

// Render a single Image

import React from "react";

const RenderSingleImage = ({image, link, options}) => {
  debugger;
  const renderImage = () => {
    if (link) {
      return (
        <a href={link} target="_blank" rel="noopener noreferrer">
          <img src={image} alt={image} className="img-fluid"
               style={options.image_styles}/>
        </a>
      );
    }
    else {
      return (
        <img src={image} alt={image} className="img-fluid"
             style={options.image_styles}/>
      );
    }
  };

  const renderCaption = (captions) => {
    if (captions)
      return (
        <div className={options.caption_classes}>{options.image_caption}</div>);
  }

  return (
    <div className="image-container d-flex flex-column">
      {options.caption_position === "top" && renderCaption()}
      <div>{renderImage()}</div>
      {options.caption_position !== "top" && renderCaption()}
    </div>
  );
};

export default RenderSingleImage;
