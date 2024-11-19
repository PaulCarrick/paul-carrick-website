import React, { useState } from 'react';

const SlideShow = ({ images, captions, slideType }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const buttonClass = "btn btn-link p-1 text-dark";
  let captionsText = null;
  let captionsTitles = null;

  const handleFirst = () => {
    setCurrentIndex(0);
  };

  const handleNext = () => {
    if (currentIndex < images.length - 1) setCurrentIndex(currentIndex + 1);
  };

  const handlePrev = () => {
    if (currentIndex > 0) setCurrentIndex(currentIndex - 1);
  };

  const handleLast = () => {
    setCurrentIndex(images.length - 1);
  };

  const handleDropdownChange = (event) => {
    const selectedValue = event.target.value;
    const index = captionsTitles.findIndex((title) => title === selectedValue);
    if (index !== -1) {
      setCurrentIndex(index);
    }
  };

  // Extract text content of <p> tags
  const extractTextFromParagraphs = (html) => {
    const matches = html.match(/<p>(.*?)<\/p>/gs);
    return matches ? matches.map((p) => p.replace(/<\/?p>/g, "")) : [];
  };

  // Extract text content of <title> tags
  const extractTitlesFromParagraphs = (html) => {
    const matches = html.match(/<title>(.*?)<\/title>/gs);
    return matches ? matches.map((title) => title.replace(/<\/?title>/g, "")) : [];
  };

  if (captions) {
    captionsText = extractTextFromParagraphs(captions);
    captionsTitles = extractTitlesFromParagraphs(captions);
  }

  // Get unique captionsTitles
  const uniqueCaptionsTitles = [...new Set(captionsTitles)];

  return (
    <div style={{ textAlign: 'center' }}>
      <div
        style={{
          marginBottom: '1em',
          maxWidth: '100%', // Set maxWidth for the container
          display: 'inline-block', // Center the container
          textAlign: 'center',
        }}
      >
        {captionsTitles && captionsTitles[currentIndex] && (
          <p
            className="display-5 fw-bold mb-1 text-dark"
            style={{
              maxWidth: '100%',
              margin: '0 auto', // Center the text
              padding: '0.5em 0',
              fontSize: '1.25em',
            }}
          >
            {captionsTitles[currentIndex]}
          </p>
        )}
        <a href={images[currentIndex]} target="_blank" rel="noopener noreferrer">
          <img
            src={images[currentIndex]}
            alt={`Slide ${currentIndex}`}
            style={{ maxWidth: '100%', maxHeight: '640px', height: 'auto' }}
          />
        </a>
        {captionsText && captionsText[currentIndex] && (
          <p
            style={{
              maxWidth: '100%',
              textAlign: 'left',
              padding: '0.5em 0',
            }}
          >
            {captionsText[currentIndex]}
          </p>
        )}
      </div>
      <div>
        <button className={buttonClass} onClick={handleFirst} disabled={currentIndex === 0}>
          First
        </button>
        <button className={buttonClass} onClick={handlePrev} disabled={currentIndex === 0}>
          Prev
        </button>
        <button className={buttonClass} onClick={handleNext} disabled={currentIndex === images.length - 1}>
          Next
        </button>
        <button className={buttonClass} onClick={handleLast} disabled={currentIndex === images.length - 1}>
          Last
        </button>
        <select
          style={{ marginLeft: '1em' }}
          onChange={handleDropdownChange}
          defaultValue=""
        >
          <option value="" disabled>
            Select a {slideType || "option"}
          </option>
          {uniqueCaptionsTitles.map((title, index) => (
            <option key={index} value={title}>
              {title}
            </option>
          ))}
        </select>
        <p>
          {currentIndex + 1} of {images.length}
        </p>
      </div>
    </div>
  );
};

export default SlideShow;
