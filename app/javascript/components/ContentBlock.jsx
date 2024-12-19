// /app/javascript/componenets/ContentBlock.jsx

// Render a content block

import React from "react";

const ContentBlock = ({content, options, toggleId, toggleClass}) => {
  return (
    <>
      <div dangerouslySetInnerHTML={{__html: content}}/>
      {options.expanding_rows &&
       <button id={toggleId} className={toggleClass}>Show More</button>}
    </>
  );
}

export default ContentBlock;
