// /app/javascript/components/RenderImage.jsx

// Render an Image

import React from "react";
import RenderSlideShow from "./RenderSlideShow";
import RenderSingleImage from "./RenderSingleImage";

const RenderImage = ({content, image, link, options}) => {
  if (options.slide_show_images) {
    return (
      <RenderSlideShow
        images={options.slide_show_images}
        captions={content}
        slideType={options.slide_show_type}
      />
    );
  }
  else {
    return (
      <RenderSingleImage image={image}
                         link={link}
                         options={options}
      />
    );
  }
};

export default RenderImage;
