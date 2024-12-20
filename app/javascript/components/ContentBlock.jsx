// /app/javascript/componenets/ContentBlock.jsx

// Render a content block

import React from "react";
import PropTypes from 'prop-types';

const ContentBlock = ({content, options, toggleId, toggleClass}) => {
  return (
    <>
      <div dangerouslySetInnerHTML={{__html: content}}/>
      {options.expanding_rows &&
       <button id={toggleId} className={toggleClass}>Show More</button>}
    </>
  );
}

ContentBlock.propTypes = {
  content: PropTypes.string.isRequired,
  options: PropTypes.shape({
                             expanding_rows: PropTypes.oneOf([true, false, null]),
                           }).isRequired,
  toggleId: PropTypes.string,
  toggleClass: PropTypes.string
};

ContentBlock.defaultProps = {
  toggleId: null,
  toggleClass: ''
};

export default ContentBlock;
