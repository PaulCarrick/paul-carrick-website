import React, { useState, useEffect } from 'react';

const SlideShow = ({ images, captions, slideType }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [dropdownValue, setDropdownValue] = useState(""); // Controlled state for dropdown
  const [imageGroup, setImageGroup] = useState(null); // Default value for imageGroup
  const [fetchedImages, setFetchedImages] = useState([]);
  const [captionsTitles, setCaptionsTitles] = useState([]);
  const [captionsText, setCaptionsText] = useState([]);

  const buttonClass = "btn btn-link p-1 text-dark";

  useEffect(() => {
    if (images.search(/^\s*ImageGroup:\s*(.+)\s*$/)) {
      const match = images.match(/^\s*ImageGroup:\s*(.+)\s*$/);

      if (match) {
        setImageGroup(match[1]);
        fetch(`/api/v1/image_files?q[group_eq]=${match[1]}`)
          .then((response) => response.json())
          .then((data) => {
            const fetchedImages = [];
            const fetchedTitles = [];
            const fetchedTexts = [];

            data.forEach((record) => {
              fetchedImages.push(record.image_url);
              fetchedTitles.push(record.caption);
              fetchedTexts.push(record.description);
            });

            setFetchedImages(fetchedImages);
            setCaptionsTitles(fetchedTitles);
            setCaptionsText(fetchedTexts);
          })
          .catch((error) => {
            console.error("Error fetching image group data:", error);
          });
      }
    }
  }, [images]);

  const handleFirst = () => {
    setCurrentIndex(0);
    updateDropdownValue(0);
  };

  const handleNext = () => {
    if (currentIndex < fetchedImages.length - 1) {
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
    setCurrentIndex(fetchedImages.length - 1);
    updateDropdownValue(fetchedImages.length - 1);
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

  if (captions && !imageGroup) {
    setCaptionsText(extractTextFromSections(captions));
    setCaptionsTitles(extractTitlesFromSections(captions));
  }

  const uniqueCaptionsTitles = [...new Set(captionsTitles)];

  return (
    <div style={{ textAlign: 'center' }}>
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
        <a href={fetchedImages[currentIndex]} target="_blank" rel="noopener noreferrer">
          <img
            src={fetchedImages[currentIndex]}
            alt={`Slide ${currentIndex}`}
            style={{ maxWidth: '100%', maxHeight: '640px', height: 'auto' }}
          />
        </a>

        {captionsText && captionsText[currentIndex] && (
          <div dangerouslySetInnerHTML={{ __html: addTextAlignLeftClass(captionsText[currentIndex]) }} />
        )}
      </div>
      <div>
        <button className={buttonClass} onClick={handleFirst} disabled={currentIndex === 0}>
          First
        </button>
        <button className={buttonClass} onClick={handlePrev} disabled={currentIndex === 0}>
          Prev
        </button>
        <button className={buttonClass} onClick={handleNext} disabled={currentIndex === fetchedImages.length - 1}>
          Next
        </button>
        <button className={buttonClass} onClick={handleLast} disabled={currentIndex === fetchedImages.length - 1}>
          Last
        </button>
        <select
          style={{ marginLeft: '1em' }}
          onChange={handleDropdownChange}
          value={dropdownValue} // Controlled value for dropdown
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
          {currentIndex + 1} of {fetchedImages.length}
        </p>
      </div>
    </div>
  );
};

export default SlideShow;
