import React, { useEffect } from "react";
import SlideShow from "./SlideShow";

// Helper to parse inline styles
const parseStyle = (styleString) => {
  if (!styleString || typeof styleString !== "string") return {};
  return styleString.split(";").reduce((styleObj, style) => {
    const [key, value] = style.split(":");
    if (!key || !value) return styleObj;
    const camelCaseKey = key.trim().replace(/-([a-z])/g, (_, char) => char.toUpperCase());
    styleObj[camelCaseKey] = value.trim();
    return styleObj;
  }, {});
};

// Helper to set up toggle functionality
const setupToggle = (elementId, className) => {
  useEffect(() => {
    const toggleButton = document.getElementById(elementId);
    const rows = document.querySelectorAll(className);

    if (!toggleButton || rows.length === 0) return;

    rows.forEach((element) => element.classList.add("collapse"));
    toggleButton.textContent = "Show More";

    const toggleText = (isShown) => (toggleButton.textContent = isShown ? "Show Less" : "Show More");

    toggleButton.addEventListener("click", () => {
      rows.forEach((element) => {
        element.classList.toggle("show");
        toggleText(element.classList.contains("show"));
      });
    });

    return () => toggleButton.removeEventListener("click", toggleText);
  }, [elementId, className]);
};

// Default options for the component
const getDefaultOptions = (format) => {
  try {
    return {
      ...{
        row_style: "text-single",
        row_classes: "align-items-center",
        text_classes: "col-lg-6",
        text_styles: {},
        image_classes: "col-lg-6 d-flex flex-column",
        image_styles: { width: "100%", height: "auto" },
        caption_classes: "caption-default text-center",
        expanding_rows: null,
        slide_show_images: null,
        slide_show_type: null,
      },
      ...JSON.parse(format),
    };
  } catch {
    console.error("Invalid JSON string for format");
    return {};
  }
};

const RenderSlideShow = ({ images, captions, slideType }) => (
  <div className="slideshow-container">
    <SlideShow images={images} captions={captions} slideType={slideType || "topic"} />
  </div>
);

const RenderImage = ({ image, link, options }) => (
  <div className="image-container d-flex flex-column">
    {options.image_caption && options.caption_position === "top" && (
      <div className={options.caption_classes}>{options.image_caption}</div>
    )}
    {link ? (
      <a href={image} target="_blank" rel="noopener noreferrer">
        <img src={image} alt={image} className="img-fluid" style={options.image_styles} />
      </a>
    ) : (
      <img src={image} alt={image} className="img-fluid" style={options.image_styles} />
    )}
    {options.image_caption && options.caption_position !== "top" && (
      <div className={options.caption_classes}>{options.image_caption}</div>
    )}
  </div>
);

const ContentBlock = ({ content, options, toggleId, toggleClass }) => (
  <div className={options.text_classes} style={options.text_styles}>
    <div dangerouslySetInnerHTML={{ __html: content }} />
    {options.expanding_rows && <button id={toggleId} className={toggleClass}>Show More</button>}
  </div>
);

const DisplayContent = ({ content, image, link, format, sectionId }) => {
  const options = getDefaultOptions(format);
  const toggleId = options.expanding_rows
    ? `toggle-${Math.random().toString(36).substr(2, 9)}`
    : null;
  const toggleClass = options.expanding_rows?.split(",")[2]?.trim() || "btn btn-primary my-2";

  if (options.expanding_rows) setupToggle(toggleId, options.expanding_rows.split(",")[1].trim());

  const rowClasses = `row ${options.row_classes}`;

  const renderContent = () => {
    switch (options.row_style) {
      case "text-single":
        return (
          <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
            <ContentBlock content={content} options={options} toggleId={toggleId} toggleClass={toggleClass} />
          </div>
        );
      case "text-top":
        return (
          <>
            <div className={rowClasses} {...(sectionId ? { id: sectionId } : {})}>
              <ContentBlock content={content} options={options} toggleId={toggleId} toggleClass={toggleClass} />
            </div>
            <div className={rowClasses}>
              {options.slide_show_images ? (
                <RenderSlideShow
                  images={options.slide_show_images}
                  captions={content}
                  slideType={options.slide_show_type}
                />
              ) : (
                <RenderImage image={image} link={link} options={options} />
              )}
            </div>
          </>
        );
      case "text-bottom":
        return (
          <>
            <div className={rowClasses}>
              {options.slide_show_images ? (
                <RenderSlideShow
                  images={options.slide_show_images}
                  captions={content}
                  slideType={options.slide_show_type}
                />
              ) : (
                <RenderImage image={image} link={link} options={options} />
              )}
            </div>
            <div className={rowClasses}>
              <ContentBlock content={content} options={options} toggleId={toggleId} toggleClass={toggleClass} />
            </div>
          </>
        );
      default:
        return null;
    }
  };

  return <div id="contents">{renderContent()}</div>;
};

export default DisplayContent;
