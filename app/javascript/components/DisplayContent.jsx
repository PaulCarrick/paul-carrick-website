import React, { useEffect } from "react";
import SlideShow from "./SlideShow";

// Helper to parse inline styles
const parseStyle = (styleString) => {
  if (!styleString) return {};
  if (!styleString["split"] !== "function") return {};
  return styleString.split(";").reduce((styleObj, style) => {
    if (!style.trim()) return styleObj;
    const [key, value] = style.split(":");
    const camelCaseKey = key
      .trim()
      .replace(/-([a-z])/g, (_, char) => char.toUpperCase());
    styleObj[camelCaseKey] = value.trim();
    return styleObj;
  }, {});
};

// Helper to set up toggle functionality
const setupToggle = (elementId, className) => {
  useEffect(() => {
    const setupLogic = () => {
      const toggleButton = document.getElementById(elementId);
      const rows = document.querySelectorAll(className);

      if (toggleButton && rows.length > 0) {
        rows.forEach((element) => {
          element.classList.add("collapse");
        });

        toggleButton.textContent = "Show More";

        rows.forEach((element) => {
          element.addEventListener("show.bs.collapse", () => {
            toggleButton.textContent = "Show Less";
          });

          element.addEventListener("hide.bs.collapse", () => {
            toggleButton.textContent = "Show More";
          });
        });

        toggleButton.addEventListener("click", () => {
          rows.forEach((element) => {
            element.classList.toggle("show");
            const isShown = element.classList.contains("show");
            toggleButton.textContent = isShown ? "Show Less" : "Show More";
          });
        });
      }
    };

    const handleLoad = () => {
      setTimeout(setupLogic, 0);
    };

    if (document.readyState === "complete") {
      handleLoad();
    } else {
      window.addEventListener("load", handleLoad);
    }

    return () => {
      window.removeEventListener("load", handleLoad);
    };
  }, [elementId, className]);
};

// Main component
const DisplayContent = ({
                          content,
                          image,
                          link,
                          format,
                          sectionId,
                          user,
                        }) => {
  let options = null;

  if (format) {
    try {
      options = JSON.parse(format);
    } catch (parse_error) {
      console.error("Invalid JSON string for format:", parse_error);
    }
  }

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
  }

  // Ensure all required options have default values
  options.row_style = options.row_style || "text-single";
  options.row_classes = options.row_classes || "align-items-center";
  options.text_classes = options.text_classes || "col-lg-6";
  options.text_styles = options.text_styles
    ? parseStyle(options.text_styles)
    : {};
  options.image_classes = options.image_classes || "col-lg-6 d-flex flex-column";
  options.image_styles = options.image_styles
    ? { ...parseStyle(options.image_styles) }
    : { width: "100%", height: "auto" };
  options.caption_classes = options.caption_classes || "text-center";
  options.expanding_rows = options.expanding_rows || null;
  options.slide_show_images = options.slide_show_images || null;
  options.slide_show_type = options.slide_show_type || null;

  const rowClasses = `row ${options.row_classes}`;
  const imageClasses = options.image_classes;
  const captionClasses = options.caption_classes;

  const toggleId = options.expanding_rows
    ? `toggle-${Math.random().toString(36).substr(2, 9)}`
    : null;
  let toggleClass = "btn btn-primary my-2";

  if (options.expanding_rows) {
    const [_, className, customClass] = options.expanding_rows
      .split(",")
      .map((s) => s.trim());
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
    <div className="image-container d-flex flex-column">
      {options.image_caption && options.caption_position === "top" && (
        <div className={captionClasses}>{options.image_caption}</div>
      )}
      {(link && (
        <a href={image} target="_blank" rel="noopener noreferrer">
          <img
            src={image}
            alt={image}
            className="img-fluid"
            style={options.image_styles}
          />
        </a>
      )) || (
        <img
          src={image}
          alt={image}
          className="img-fluid"
          style={options.image_styles}
        />
      )}
      {options.image_caption && options.caption_position !== "top" && (
        <div className={captionClasses}>{options.image_caption}</div>
      )}
    </div>
  );

  if (options.row_style === "text-single") {
    return (
      <div id="contents">
        <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
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
      </div>
    );
  }

  if (options.row_style === "text-top") {
    return (
      <div id="contents">
        <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
          <div className="col-12">
            <div dangerouslySetInnerHTML={{ __html: content }} />
            {options.expanding_rows && (
              <button id={toggleId} className={toggleClass}>
                Show More
              </button>
            )}
          </div>
        </div>
        <div className={rowClasses}>
          <div className="col-12">
            {options.slide_show_images ? renderSlideShow() : renderImage()}
          </div>
        </div>
      </div>
    );
  }

  if (options.row_style === "text-bottom") {
    return (
      <div id="contents">
        <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
          <div className="col-12">
            {options.slide_show_images ? renderSlideShow() : renderImage()}
          </div>
        </div>
        <div className={rowClasses}>
          <div className="col-12">
            <div dangerouslySetInnerHTML={{ __html: content }} />
            {options.expanding_rows && (
              <button id={toggleId} className={toggleClass}>
                Show More
              </button>
            )}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div id="contents">
      <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
        {options.row_style === "text-left" && (
          <div
            className={`${options.text_classes} align-self-center`}
            style={options.text_styles}
          >
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
          <div
            className={`${options.text_classes} align-self-center`}
            style={options.text_styles}
          >
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
    </div>
  );
};

export default DisplayContent;
