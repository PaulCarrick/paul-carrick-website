// /app/javascript/components.DisplayContent.jsx

// Displays the contents of a section

import React from "react";
import PropTypes from 'prop-types';
import RenderContent from "./RenderContent";
import getDefaultOptions from "./getDefaultOptions";
import setupToggle from "./setupToggle";

const DisplayContent = ({
                          content,
                          image,
                          link,
                          format,
                          sectionId
                        }) => {
  let options = getDefaultOptions(format);

  const toggleId = options.expanding_rows
    ? `toggle-${Math.random().toString(36).substr(2, 9)}`
    : null;
  let toggleClass = "btn btn-primary my-2";

  if (options.expanding_rows) {
    const [ _, className, customClass ] = options.expanding_rows
                                                 .split(",")
                                                 .map((s) => s.trim());
    if (customClass) toggleClass = customClass;
    setupToggle(toggleId, className);
  }

  return (
    <div id="contents">
      <RenderContent options={options}
                     content={content}
                     image={image}
                     link={link}
                     sectionId={sectionId}
                     toggleId={toggleId}
                     toggleClass={toggleClass}
      />
    </div>);
};

DisplayContent.propTypes = {
  content: PropTypes.string,
  image: PropTypes.string,
  link: PropTypes.string,
  format: PropTypes.string,
  sectionId: PropTypes.string
};

export default DisplayContent;
