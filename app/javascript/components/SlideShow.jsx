import React, { useState } from 'react';
import PropTypes from 'prop-types';

const SlideShow = ({ images, captions, slideType }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [dropdownValue, setDropdownValue] = useState("");

  const buttonClass = "btn btn-link p-1 text-dark";
  let captionsText = null;
  let captionsTitles = null;

  const handleFirst = () => {
    setCurrentIndex(0);
    updateDropdownValue(0);
  };

  const handleNext = () => {
    if (currentIndex < images.length - 1) {
      setCurrentIndex(currentIndex + 1);
      updateDropdownValue(currentIndex + 1);
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1);
      updateDropdownValue(currentIndex - 1);
    }
  };

  const handleLast = () => {
    setCurrentIndex(images.length - 1);
    updateDropdownValue(images.length - 1);
  };

  const handleDropdownChange = (event) => {
    const selectedValue = event.target.value;
    const index = captionsTitles.findIndex((title) => title === selectedValue);
    if (index !== -1) {
      setCurrentIndex(index);
      setDropdownValue(selectedValue);
    }
  };

  const updateDropdownValue = (index) => {
    if (captionsTitles && captionsTitles[index]) {
      setDropdownValue(captionsTitles[index]);
    }
  };

  const extractTextFromSections = (html) => {
    const matches = html.match(/<section>(.*?)<\/section>/gs);
    return matches ? matches.map((section) => section.replace(/<\/?section>/g, "")) : [];
  };

  const extractTitlesFromSections = (html) => {
    const matches = html.match(/<title>(.*?)<\/title>/gs);
    return matches ? matches.map((title) => title.replace(/<\/?title>/g, "")) : [];
  };

  const addTextAlignLeftClass = (htmlString) => {
    const parser = new DOMParser();
    const doc = parser.parseFromString(htmlString, 'text/html');

    doc.querySelectorAll('p').forEach((p) => {
      p.classList.add('text-start');
    });

    return doc.body.innerHTML;
  };

  if (captions) {
    captionsText = extractTextFromSections(captions);
    captionsTitles = extractTitlesFromSections(captions);
  }

  const uniqueCaptionsTitles = [...new Set(captionsTitles)];

  return (
    <div style={{ textAlign: 'left' }}>
      <div
        style={{
          marginBottom: '1em',
          maxWidth: '100%',
          display: 'inline-block',
          textAlign: 'center',
        }}
      >
        {captionsTitles && captionsTitles[currentIndex] && (
          <p
            className="display-5 fw-bold mb-1 text-dark"
            style={{
              maxWidth: '100%',
              margin: '0 auto',
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
          <div className="text-start">
            <div dangerouslySetInnerHTML={{ __html: addTextAlignLeftClass(captionsText[currentIndex]) }} />
          </div>
        )}
      </div>
      <div>
        {currentIndex + 1} of {images.length} -

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
          value={dropdownValue}
        >
          <option value="" disabled>
            Select a {slideType || "topic"}
          </option>
          {uniqueCaptionsTitles.map((title, index) => (
            <option key={index} value={title}>
              {title}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
};

SlideShow.propTypes = {
  images: PropTypes.arrayOf(
    PropTypes.oneOfType([
                          PropTypes.string,
                          PropTypes.object
                        ])
  ).isRequired,
  captions: PropTypes.string,
  slideType: PropTypes.string
};

SlideShow.defaultProps = {
  captions: null,
  slideType: "topic"
};

export default SlideShow;
