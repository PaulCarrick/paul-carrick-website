import React, { useEffect } from "react";
import SlideShow from "./SlideShow";

const parseStyle = (styleString) =>
  styleString.split(";").reduce((styleObj, style) => {
    if (!style.trim()) return styleObj;
    const [key, value] = style.split(":");
    const camelCaseKey = key
      .trim()
      .replace(/-([a-z])/g, (_, char) => char.toUpperCase());
    styleObj[camelCaseKey] = value.trim();
    return styleObj;
  }, {});

const parseOptions = (optionsString) => {
  if (!optionsString || typeof optionsString !== "string") {
    console.error("Input must be a valid JSON string.");
    return null;
  }

  try {
    return JSON.parse(optionsString);
  } catch (error) {
    console.error("Invalid JSON string:", error);
    return null;
  }
};

const setupToggle = (elementId, className) => {
  useEffect(() => {
    const setupLogic = () => {
      const toggleButton = document.getElementById(elementId);
      const rows = document.querySelectorAll(className);

      if (toggleButton && rows.length > 0) {
        // Initially hide rows
        rows.forEach((element) => {
          element.classList.add("collapse"); // Add the Bootstrap `collapse` class
        });

        // Set initial button text
        toggleButton.textContent = "Show More";

        // Add event listeners for show/hide
        rows.forEach((element) => {
          element.addEventListener("show.bs.collapse", () => {
            toggleButton.textContent = "Show Less";
          });

          element.addEventListener("hide.bs.collapse", () => {
            toggleButton.textContent = "Show More";
          });
        });

        // Toggle visibility on button click
        toggleButton.addEventListener("click", () => {
          rows.forEach((element) => {
            element.classList.toggle("show"); // Manually toggle the `show` class
            const isShown = element.classList.contains("show");
            toggleButton.textContent = isShown ? "Show Less" : "Show More";
          });
        });
      }
    };

    // Ensure logic runs after the entire page is fully rendered
    const handleLoad = () => {
      setTimeout(setupLogic, 0); // Delay execution slightly to ensure DOM is complete
    };

    if (document.readyState === "complete") {
      handleLoad();
    } else {
      window.addEventListener("load", handleLoad);
    }

    // Cleanup listeners on unmount
    return () => {
      window.removeEventListener("load", handleLoad);
    };
  }, [elementId, className]);
};

const DisplayContent = ({ content, image, link, format }) => {
  let options = null;

  if (format) options = parseOptions(format);

  if (!options) {
    options = {
      row_style: "text-single",
      row_classes: "align-items-center",
      text_classes: "col-lg-6",
      text_styles: {},
      image_classes: "col-lg-6 d-flex flex-column",
      image_styles: { width: "100%", height: "auto" },
      image_caption: null,
      caption_position: "top",
      caption_classes: "caption-default text-center",
      expanding_rows: null,
      slide_show_images: null,
      slide_show_type: null,
    };
  } else {
    if (!options.row_style) options.row_style = "text-right";
    if (!options.row_classes) options.row_classes = "align-items-center";
    if (!options.text_classes) options.text_classes = "col-lg-6";
    if (!options.image_classes) options.image_classes = "col-lg-6 d-flex flex-column";

    if (!options.text_styles) options.text_styles = {};
    else options.text_styles = parseStyle(options.text_styles);

    if (!options.image_style) options.image_style = { width: "100%", height: "auto" };
    else options.image_style = { ...parseStyle(options.image_style), width: "100%", height: "auto" };

    if (!options.image_styles) options.image_styles = {};
    else options.image_styles = parseStyle(options.image_styles);

    if (!options.caption_classes) options.caption_classes = "text-center";

    if (!options.expanding_rows) options.expanding_rows = null;

    if (!options.slide_show_images) options.slide_show_images = null;

    if (!options.slide_show_type) options.slide_show_type = null;
  }

  const rowClasses = `row ${options.row_classes}`;
  const imageClasses = `${options.image_classes}`;
  const captionClasses = options.caption_classes;

  // Dynamically generate a unique ID for the toggle button
  const toggleId = options.expanding_rows ? `toggle-${Math.random().toString(36).substr(2, 9)}` : null;

  // Extract `expanding_rows` parameters
  let toggleClass = "btn btn-primary my-2"; // Default button class
  if (options.expanding_rows) {
    const [_, className, customClass] = options.expanding_rows.split(",").map((s) => s.trim());
    if (customClass) toggleClass = customClass;
    setupToggle(toggleId, className);
  }

  const renderSlideShow = () => (
    <div className="slideshow-container">
      <SlideShow
        images={options.slide_show_images}
        captions={content}
        slideType={options.slide_show_type ?? "topic"}
      />
    </div>
  );

  const renderImage = () => (
    <div className="image-container d-flex flex-column align-items-center">
      {options.image_caption && options.caption_position === "top" && (
        <div className={captionClasses}>{options.image_caption}</div>
      )}
      {(link != null && (
        <a href={image} target="_blank" rel="noopener noreferrer">
          <img
            src={image}
            alt={image}
            className="img-fluid"
            style={options.image_style}
          />
        </a>
      )) || (
        <img
          src={image}
          alt={image}
          className="img-fluid"
          style={options.image_style}
        />
      )}
      {options.image_caption && options.caption_position !== "top" && (
        <div className={captionClasses}>{options.image_caption}</div>
      )}
    </div>
  );

  if (options.row_style === "text-single") {
    // Single column layout
    return (
      <div className={rowClasses}>
        <div className="col-12">
          {!options.slide_show_images && (
            <div dangerouslySetInnerHTML={{ __html: content }} />
          )}
          {options.expanding_rows && (
            <button id={toggleId} className={toggleClass}>
              Show More
            </button>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className={rowClasses}>
      {options.row_style === "text-left" && (
        <div className={`${options.text_classes} align-self-center`} style={options.text_styles}>
          {/* Render HTML directly */}
          {!options.slide_show_images && (
            <div dangerouslySetInnerHTML={{ __html: content }} />
          )}
          {options.expanding_rows && (
            <button id={toggleId} className={toggleClass}>
              Show More
            </button>
          )}
        </div>
      )}
      <div className={`${imageClasses}`}>
        {options.slide_show_images ? renderSlideShow() : renderImage()}
      </div>
      {!(options.row_style === "text-left") && (
        <div className={`${options.text_classes} align-self-center`} style={options.text_styles}>
          {/* Render HTML directly */}
          {!options.slide_show_images && (
            <div dangerouslySetInnerHTML={{ __html: content }} />
          )}
          {options.expanding_rows && (
            <button id={toggleId} className={toggleClass}>
              Show More
            </button>
          )}
        </div>
      )}
    </div>
  );
};

export default DisplayContent;
