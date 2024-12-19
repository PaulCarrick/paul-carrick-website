// /app/javascript/components/RenderContent.jsx

// Render the content of a section

import React from "react";
import ContentBlock from "./ContentBlock";
import RenderImage from "./RenderImage";

const RenderContent = ({
                         options,
                         content,
                         image,
                         link,
                         sectionId,
                         toggleId,
                         toggleClass
                       }) => {
  debugger;
  const rowClasses = `row ${options.row_classes}`;
  let text = content;
  let captions = null;

  if (options.slide_show_images) {
    captions = content;
    text = null;
  }

  switch (options.row_style) {
    case "text-left":
      return (
        <>
          <div className={rowClasses} {...(sectionId ? {id: sectionId} : {})}>
            <div className={options.text_classes} style={options.text_styles}>
              <ContentBlock content={text}
                            options={options}
                            toggleId={toggleId}
                            toggleClass={toggleClass}
              />
            </div>
            <div className={options.image_classes} style={options.image_styles}>
              <RenderImage content={captions} image={image} link={link} options={options}/>
            </div>
          </div>
        </>
      );
    case "text-right":
      return (
        <>
          <div className={rowClasses} {...(sectionId ? {id: sectionId} : {})}>
            <div className={options.image_classes} style={options.image_styles}>
              <RenderImage content={captions} image={image} link={link} options={options}/>
            </div>
            <div className={options.text_classes} style={options.text_styles}>
              <ContentBlock content={text}
                            options={options}
                            toggleId={toggleId}
                            toggleClass={toggleClass}
              />
            </div>
          </div>
        </>
      );
    case "text-single":
      return (
        <div className={rowClasses} {...(sectionId ? {id: sectionId} : {})}>
          <ContentBlock content={text}
                        options={options}
                        toggleId={toggleId}
                        toggleClass={toggleClass}
          />
        </div>
      );
    case "text-top":
      return (
        <>
          <div className={rowClasses} {...(sectionId ? {id: sectionId} : {})}>
            <ContentBlock content={text}
                          options={options}
                          toggleId={toggleId}
                          toggleClass={toggleClass}
            />
          </div>
          <div className={rowClasses}>
            <RenderImage content={captions}
                         image={image}
                         link={link}
                         options={options}/>
          </div>
        </>
      );
    case "text-bottom":
      return (
        <>
          <div className={rowClasses}>
            <RenderImage content={captions}
                         image={image}
                         link={link}
                         options={options}/>
          </div>
          <div className={rowClasses}>
            <ContentBlock content={text}
                          options={options}
                          toggleId={toggleId}
                          toggleClass={toggleClass}
            />
          </div>
        </>
      );
    default:
      return null;
  }
};

export default RenderContent;
