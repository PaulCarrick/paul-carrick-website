// /app/javascript/components/RenderSlideShow.jsx

// Render a slide show

import React from "react";
import SlideShow from "./SlideShow";

const RenderSlideShow = ({ images, captions, slideType }) => {
  debugger;
  return (
    <div className="slideshow-container">
      <SlideShow images={images} captions={captions}
                 slideType={slideType || "topic"}/>
    </div>
  );
};

export default RenderSlideShow;
