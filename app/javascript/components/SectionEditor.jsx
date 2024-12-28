// /app/javascript/components/SectionEditor
// noinspection JSUnusedLocalSymbols,JSValidateTypes

// Component to Edit a section Record

import React, {useState, useEffect} from "react";
import PropTypes from "prop-types";
import HtmlEditor from "./HtmlEditor";
import {backgroundColors} from "./backgroundColors";
import RenderSection from "./RenderSection";

const SectionEditor = ({
                         section = null,
                         availableContentTypes = null,
                         availableImages = null
                       }) => {
  // Assign section Record
  const [sectionData, setSectionData] = useState(section);

  // Handle case where section is not yet loaded
  useEffect(() => {
    if (!sectionData && section) {
      setSectionData(section);
    } else if (!sectionData) {
      setTimeout(() => {
        window.location.reload();
      }, 1000);
    }
  }, [section, sectionData]);

  // Assign Section Attributes
  const [contentType, setContentType] = useState(sectionData.content_type);
  const [sectionName, setSectionName] = useState(sectionData.section_name);
  const [sectionOrder, setSectionOrder] = useState(sectionData.section_order);
  const [image, setImage] = useState(sectionData.image);
  const [link, setLink] = useState(sectionData.link);
  const [formatting, setFormatting] = useState(sectionData.formatting);
  const [rowStyle, setRowStyle] = useState(sectionData.row_style);
  const [divRatio, setDivRatio] = useState(sectionData.div_ratio);
  const [description, setDescription] = useState(sectionData.description);
  const [textMarginTop, setTextmarginTop] = useState(sectionData.text_margin_top);
  const [textMarginLeft, setTextmarginLeft] = useState(sectionData.text_margin_left);
  const [textMarginRight, setTextmarginRight] = useState(sectionData.text_margin_right);
  const [textMarginBottom, setTextmarginBottom] = useState(sectionData.text_margin_bottom);
  const [textBackgroundColor, settTxtBackgroundColor] = useState(sectionData.text_background_color);
  const [imageMarginTop, setImagemarginTop] = useState(sectionData.image_margin_top);
  const [imageMarginLeft, setImagemarginLeft] = useState(sectionData.image_margin_left);
  const [imageMarginRight, setImagemarginRight] = useState(sectionData.image_margin_right);
  const [imageMarginBottom, setImagemarginBottom] = useState(sectionData.image_margin_bottom);
  const [imageBackgroundColor, setImageBackgroundColor] = useState(sectionData.image_background_color);

  // Assign select lists
  const [availableContentTypesData, setAvailableContentTypesData] = useState(availableContentTypes);
  const [availableImagesData, setAvailableImagesData] = useState(availableImages);

  // Setup setters for change callback to update the values
  const attributeSetters = {
    contentType: setContentType,
    sectionName: setSectionName,
    sectionOrder: setSectionOrder,
    image: setImage,
    link: setLink,
    rowStyle: setRowStyle,
    divRatio: setDivRatio,
    description: setDescription,
    textMarginTop: setTextmarginTop,
    textMarginLeft: setTextmarginLeft,
    textMarginRight: setTextmarginRight,
    textMarginBottom: setTextmarginBottom,
    textBackgroundColor: settTxtBackgroundColor,
    imageMarginTop: setImagemarginTop,
    imageMarginLeft: setImagemarginLeft,
    imageMarginRight: setImagemarginRight,
    imageMarginBottom: setImagemarginBottom,
    imageBackgroundColor: settTxtBackgroundColor,
  };

  // Onchange/OnBlur Callback
  const setValue = (newValue, attribute) => {
    const setter = attributeSetters[attribute];

    if (setter) {
      const convertedValue = convertType(newValue, attribute);

      mapReactValuesToSection(sectionData, attribute, convertedValue);
      setter(convertedValue);
    }
  };

  // *** Main method ***/
  return (
      <div>
        {renderContentType(contentType, availableContentTypesData, setValue)}
        {renderSectionName(sectionName, setValue)}
        {renderSectionOrder(sectionOrder, setValue)}
        {renderImage(image, availableImagesData, setValue)}
        {renderLink(link, setValue)}
        {renderDescription(description, setValue)}
        {renderRowStyle(rowStyle, setValue)}
        {((rowStyle === "text-left") || (rowStyle === "text-right")) && renderDivRatio(divRatio, setValue)}
        {renderTextAttributes(textMarginTop,
            textMarginBottom,
            textMarginRight,
            textMarginLeft,
            textBackgroundColor)
        }
        {(rowStyle !== null) && (rowStyle !== "") && (rowStyle !== "text-single") && renderImageAttributes(imageMarginTop,
            imageMarginBottom,
            imageMarginRight,
            imageMarginLeft,
            imageBackgroundColor)
        }
        <div className="row mb-2">
          <div id="sectionAttributes" className="w-100 border border-danger border-width-8">
            <RenderSection
                section={sectionData}
            />
          </div>
        </div>
        <div className="row mb-2">
          <div className="col-2" id="promptField">* - Required Fields</div>
          <div className="col-10">
          </div>
        </div>
      </div>
  );
};

// *** Render Functions ***/

function renderContentType(contentType, availableContentTypesData, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Content Type:</div>
        <div className="col-10">
          <div id="contentTypeDiv">
            <select
                id="contentType"
                value={contentType}
                onChange={(event) => setValue(event.target.value, "contentType")}
            >
              <option value="">Select an option</option>
              {availableContentTypesData.map((option, index) => (
                  <option key={index} value={option}>
                    {option}
                  </option>
              ))}
            </select>
          </div>
        </div>
      </div>
  );
}

function renderSectionName(sectionName, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Section Name:</div>
        <div className="col-10">
          <div id="sectionNameDiv">
            <input
                type="text"
                id="sectionName"
                value={sectionName ? sectionName : ""}
                placeholder="Enter the name for the section (optional; used for section focus)"
                onChange={(event) => setValue(event.target.value,
                    "sectionName")}
            />
          </div>
        </div>
      </div>
  );
}

function renderSectionOrder(sectionOrder, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Section Order:</div>
        <div className="col-10">
          <div id="sectionOrderDiv">
            <input
                type="number"
                id="sectionOrder"
                value={sectionOrder ? sectionOrder : 1}
                placeholder="Enter the order of the section (1 is first)"
                onChange={(event) => setValue(event.target.value,
                    "sectionOrder")}
            />
          </div>
        </div>
      </div>
  );
}

function renderImage(image, availableImagesData, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Image:</div>
        <div className="col-10">
          <div id="imageDiv">
            <select
                id="image"
                value={image}
                onChange={(event) => setValue(event.target.value, "image")}
            >
              <option value="">Select an option</option>
              {availableImagesData.map((option, index) => (
                  <option key={index} value={option}>
                    {option}
                  </option>
              ))}
            </select>
          </div>
        </div>
      </div>
  );
}

function renderLink(link, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">URL:</div>
        <div className="col-10">
          <div id="linkDiv">
            <input
                type="text"
                id="link"
                value={link ? link : ""}
                placeholder="Enter the URL to be opend when an image is cliecked (optional)"
                onChange={(event) => setValue(event.target.value,
                    "link")}
            />
          </div>
        </div>
      </div>
  );
}

function renderDescription(description, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Content:</div>
        <div className="col-10">
          <div id="description">
            <HtmlEditor
                id="description"
                value={description}
                placeholder="Enter the text to be display in the text part of the section"
                onChange={(value) => setValue(value,
                    "description")}
                onBlur={(value) => setValue(value,
                    "description")}
                theme="snow"
            />
          </div>
        </div>
      </div>
  );
}

function renderRowStyle(rowStyle, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Row Style:</div>
        <div className="col-10">
          <div id="rowStyle">
            <select
                id="rowStyle"
                value={rowStyle ? rowStyle : ""}
                onChange={(event) => setValue(event.target.value,
                    "rowStyle")}
            >
              <option key="" value={null}>
              </option>
              <option key="text-single" value="text-single">
                Only Text
              </option>
              <option key="text-top" value="text-top">
                Text on the Top
              </option>
              <option key="text-bottom" value="text-bottom">
                Text on the Bottom
              </option>
              <option key="text-left" value="text-left">
                Text on the Left
              </option>
              <option key="text-right" value="text-right">
                Text on the Right
              </option>
            </select>
          </div>
        </div>
      </div>
  );
}

function renderDivRatio(divRatio, setValue) {
  return (
      <div className="row mb-2">
        <div className="col-2">Div Ratio:</div>
        <div className="col-10">
          <div id="divRatio">
            <select
                id="divRatio"
                value={divRatio ? divRatio : ""}
                onChange={(event) => setValue(event.target.value,
                    "divRatio")}
            >
              <option key="" value={null}>
              </option>
              <option key="50:50" value="50:50">
                50 percent Text - 50 Percent Image
              </option>
              <option key="90:10" value="90:10">
                90 Percent Text - 10 Percent Image
              </option>
              <option key="80:20" value="80:20">
                80 Percent Text - 20 Percent Image
              </option>
              <option key="70:30" value="70:30">
                70 Percent Text - 30 Percent Image
              </option>
              <option key="60:40" value="60:40">
                60 Percent Text - 40 Percent Image
              </option>
              <option key="40:60" value="40:60">
                40 Percent Text - 60 Percent Image
              </option>
              <option key="30:70" value="30:70">
                30 Percent Text - 70 Percent Image
              </option>
              <option key="20:80" value="20:80">
                30 Percent Text - 70 Percent Image
              </option>
              <option key="10:90" value="10:90">
                10 Percent Text - 90 Percent Image
              </option>
            </select>
          </div>
        </div>
      </div>
  );
}

function renderTextAttributes(textMarginTop, textMarginBottom, textMarginRight, textMarginLeft, textBackgroundColor) {
  return (
      <div className="row mb-2">
        <div className="col-2">Row Style:</div>
        <div className="col-10">
          <div id="textMarginTop">
            <select
                id="rowStyle"
                value={rowStyle ? rowStyle : ""}
                onChange={(event) => setValue(event.target.value,
                    "rowStyle")}
            >
              <option key="" value={null}>
              </option>
              <option key="text-single" value="text-single">
                Only Text
              </option>
              <option key="text-top" value="text-top">
                Text on the Top
              </option>
              <option key="text-bottom" value="text-bottom">
                Text on the Bottom
              </option>
              <option key="text-left" value="text-left">
                Text on the Left
              </option>
              <option key="text-right" value="text-right">
                Text on the Right
              </option>
            </select>
          </div>
        </div>
      </div>
  );
}

// *** Utility Functions ***/

function getMarginOptions(marginType) {
  const prefixes = {
    none: "",
    top: "mt-",
    bottom: "mb-",
    left: "ms-",
    right: "me-",
  };

  const labelPrefixes = {
    none: "",
    top: "Margin Top",
    bottom: "Margin Bottom",
    left: "Margin Left",
    right: "Margin Right",
  };

  const prefix = prefixes[marginType];
  const label = labelPrefixes[marginType];

  return prefix
      ? Array.from({length: 5}, (_, i) => ({
        value: `${prefix}${i + 1}`,
        label: `${label} - #${i + 1}`,
      }))
      : [];
}


function mapReactValuesToSection(sectionData, attribute, value) {
  const formatting = sectionData.formatting

  switch (attribute) {
    case "contentType":
      sectionData.content_type = value;
      break;
    case "sectionName":
      sectionData.section_name = value;
      break;
    case "sectionOrder":
      sectionData.section_order = value;
      break;
    case "image":
      sectionData.image = value;
      break;
    case "link":
      sectionData.link = value;
      break;
    case "description":
      sectionData.description = value;
      break;
    case "formatting":
      sectionData.formatting = value;
      break;
    case "rowStyle":
      sectionData.row_style = value;
      formatting.row_style = value;
      break;
    case "divRatio":
      let image_classes = formatting.image_classes;
      let text_classes = formatting.text_classes;

      // Strip out the existing col classes
      formatting.text_classes = formatting.text_classes.replace(/\bcol-\w*-\d{1,2}|\bcol-\d{1,2}\b/g, "").trim();
      formatting.image_classes = formatting.image_classes.replace(/\bcol-\w*-\d{1,2}|\bcol-\d{1,2}\b/g, "").trim();

      if (value && value !== "") {
        let match = value.match(/(\d+):(\d+)/);

        if (match) {
          let firstValue = Math.round((parseInt(match[1], 10) / 100.0) * 12);
          let secondValue = 12 - firstValue;

          formatting.text_classes = `${formatting.text_classes} col-${firstValue}`;
          formatting.image_classes = `${formatting.image_classes} col-${secondValue}`;
        }
      }

      sectionData.div_ratio = value;
      break;
    case "imageAttributes":
      sectionData.image_attributes = value;
      break;
    case "textAttributes":
      sectionData.text_attributes = value;
      break;
  }
}

function convertType(value, attribute) {
  switch (attribute) {
    case "contentType":
      if (typeof (value) === "string")
        return (value);
      else
        return (value.value);
    case "sectionName":
      return (value);
    case "sectionOrder":
      if (value === null)
        return null;
      else
        return (parseInt(value, 10));
    case "image":
      if (typeof (value) === "string")
        return (value);
      else
        return (value.value);
    case "link":
      return (value);
    case "rowStyle":
      if (typeof (value) === "string")
        return (value);
      else
        return (value.value);
    case "divRatio":
      if (typeof (value) === "string")
        return (value);
      else
        return (value.value);
    case "description":
      return (value);
    default:
      return null;
  }
}

function arrayToOptions(stringArray) {
  let options = []

  for (const text of stringArray) {
    options.push({
      label: text,
      value: text,
    });
  }

  return options;
}

SectionEditor.propTypes = {
  section: PropTypes.shape({
    content_type: PropTypes.string,
    section_name: PropTypes.string,
    section_order: PropTypes.number,
    image: PropTypes.string,
    link: PropTypes.string,
    description: PropTypes.string,
    row_style: PropTypes.string,
    text_margin_top: PropTypes.string,
    text_margin_left: PropTypes.string,
    text_margin_right: PropTypes.string,
    text_margin_bottom: PropTypes.string,
    text_background_color: PropTypes.string,
    image_margin_top: PropTypes.string,
    image_margin_left: PropTypes.string,
    image_margin_right: PropTypes.string,
    image_margin_bottom: PropTypes.string,
    image_background_color: PropTypes.string,
  }),
  availableContentTypes: PropTypes.arrayOf(PropTypes.string),
  availableImages: PropTypes.arrayOf(PropTypes.string),
};

export default SectionEditor;
