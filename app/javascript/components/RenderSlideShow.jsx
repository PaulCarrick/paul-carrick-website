// /app/javascript/components/RenderSlideShow.jsx

// Render a slide show

import React from "react";
import PropTypes from 'prop-types';
import SlideShow from "./SlideShow";

const RenderSlideShow = ({ images, captions, slideType }) => {
  return (
    <div className="slideshow-container">
      <SlideShow images={images} captions={captions}
                 slideType={slideType || "topic"}/>
    </div>
  );
};

RenderSlideShow.propTypes = {
  images: PropTypes.arrayOf(
    PropTypes.oneOfType([
                          PropTypes.string,
                          PropTypes.object
                        ])
  ).isRequired,
  captions: PropTypes.oneOfType([
                                  PropTypes.arrayOf(PropTypes.string),
                                  PropTypes.string,
                                  PropTypes.null
                                ]),
  slideType: PropTypes.string
};

RenderSlideShow.defaultProps = {
  captions: null,
  slideType: "topic",
};

export default RenderSlideShow;
