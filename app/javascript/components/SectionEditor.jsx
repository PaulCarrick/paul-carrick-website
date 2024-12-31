// /app/javascript/components/SectionEditor
// noinspection JSUnusedLocalSymbols,JSValidateTypes,JSUnresolvedReference
// noinspection RegExpRedundantEscape

// Component to Edit a section Record

import React, {useState, useEffect, useRef} from "react";
import PropTypes from "prop-types";
import HtmlEditor from "./HtmlEditor";
import {backgroundColors} from "./backgroundColors";
import RenderSection from "./RenderSection";
import {hasImageSection, hasSplitSections, isPresent, getColumWidths} from "./getDefaultOptions";

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
    }
    else if (!sectionData) {
      setTimeout(() => {
        window.location.reload();
      }, 1000);
    }
  }, [section, sectionData]);

  // Assign Section Attributes
  const [contentType, setContentType]                   = useState(sectionData.content_type);
  const [sectionName, setSectionName]                   = useState(sectionData.section_name);
  const [sectionOrder, setSectionOrder]                 = useState(sectionData.section_order);
  const [image, setImage]                               = useState(sectionData.image);
  const [link, setLink]                                 = useState(sectionData.link);
  const [formatting, setFormatting]                     = useState(sectionData.formatting);
  const [rowStyle, setRowStyle]                         = useState(sectionData.row_style);
  const [divRatio, setDivRatio]                         = useState(sectionData.div_ratio);
  const [description, setDescription]                   = useState(sectionData.description);
  const [textMarginTop, setTextmarginTop]               = useState(sectionData.text_margin_top);
  const [textMarginLeft, setTextmarginLeft]             = useState(sectionData.text_margin_left);
  const [textMarginBottom, setTextmarginBottom]         = useState(sectionData.text_margin_bottom);
  const [textMarginRight, setTextmarginRight]           = useState(sectionData.text_margin_right);
  const [textBackgroundColor, settTextBackgroundColor]  = useState(sectionData.text_background_color);
  const [imageMarginTop, setImagemarginTop]             = useState(sectionData.image_margin_top);
  const [imageMarginLeft, setImagemarginLeft]           = useState(sectionData.image_margin_left);
  const [imageMarginBottom, setImagemarginBottom]       = useState(sectionData.image_margin_bottom);
  const [imageMarginRight, setImagemarginRight]         = useState(sectionData.image_margin_right);
  const [imageBackgroundColor, setImageBackgroundColor] = useState(sectionData.image_background_color);
  const previousRowStyle = useRef();
  const previousDivRatio = useRef();
  const lastChange = useRef();

  // Assign select lists
  const [availableContentTypesData, setAvailableContentTypesData] = useState(availableContentTypes);
  const [availableImagesData, setAvailableImagesData]             = useState(availableImages);

  // Setup setters for change callback to update the values
  const attributeSetters = {
    contentType:          setContentType,
    sectionName:          setSectionName,
    sectionOrder:         setSectionOrder,
    image:                setImage,
    link:                 setLink,
    rowStyle:             setRowStyle,
    divRatio:             setDivRatio,
    description:          setDescription,
    textMarginTop:        setTextmarginTop,
    textMarginLeft:       setTextmarginLeft,
    textMarginBottom:     setTextmarginBottom,
    textMarginRight:      setTextmarginRight,
    textBackgroundColor:  settTextBackgroundColor,
    imageMarginTop:       setImagemarginTop,
    imageMarginLeft:      setImagemarginLeft,
    imageMarginBottom:    setImagemarginBottom,
    imageMarginRight:     setImagemarginRight,
    imageBackgroundColor: setImageBackgroundColor,
  };

  // Onchange/OnBlur Callback
  const setValue = (newValue, attribute) => {
    const setter = attributeSetters[attribute];

    if (setter) {
      const convertedValue = convertType(newValue, attribute);

      lastChange.current = {
        attribute: attribute,
        value: convertedValue
      };

      setter(convertedValue);
    }
  };

  useEffect(() => {
    if (((previousRowStyle.current !== "text-right") &&
         (previousRowStyle.current !== "text-left")) &&
        ((rowStyle === 'text-right') ||
         (rowStyle === 'text-left'))) {
      if (isPresent(previousDivRatio.current))
        setDivRatio(previousDivRatio.current);
      else
        setDivRatio("50:50");
    }

    previousRowStyle.current = rowStyle;
  }, [rowStyle]);

  useEffect(() => {
    previousDivRatio.current = divRatio;
  }, [divRatio]);

  const imageSection = hasImageSection(rowStyle);
  const splitSection = hasSplitSections(rowStyle)

  if (isPresent(lastChange) && isPresent(lastChange.current)) {
    mapReactValuesToSection(sectionData,
                            lastChange.current.attribute,
                            lastChange.current.value);
  }

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
        {splitSection && renderDivRatio(divRatio, setValue)}
        <div className="row">
          <div className="col-12">
            {renderAttributes(
                imageSection,
                textMarginTop,
                textMarginBottom,
                textMarginRight,
                textMarginLeft,
                textBackgroundColor,
                imageMarginTop,
                imageMarginBottom,
                imageMarginRight,
                imageMarginLeft,
                imageBackgroundColor,
                setValue
            )}
          </div>
        </div>
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

function renderSelect(id, value, options, setValue) {
  return (
      <select
          id={id}
          value={value ? value : ""}
          onChange={(event) => setValue(event.target.value, id)}
      >
        <option value="">Select an option</option>
        {options.map((option, index) => (
            <option key={index} value={option.value}>
              {option.label}
            </option>
        ))}
      </select>
  );
}

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
                onChange={(event) => setValue(
                    event.target.value,
                    "sectionName"
                )}
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
                onChange={(event) => setValue(
                    event.target.value,
                    "sectionOrder"
                )}
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
                onChange={(event) => setValue(
                    event.target.value,
                    "link"
                )}
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
                onChange={(value) => setValue(
                    value,
                    "description"
                )}
                onBlur={(value) => setValue(
                    value,
                    "description"
                )}
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
            {renderSelect("rowStyle", rowStyle, rowStyleOptions(), setValue)}
          </div>
        </div>
      </div>
  );
}

function rowStyleOptions() {
  return (
      [
        {
          label: "Only Text",
          value: "text-single",
        },
        {
          label: "Text on the Top",
          value: "text-top",
        },
        {
          label: "Text on the Left",
          value: "text-left",
        },
        {
          label: "Text on the Bottom",
          value: "text-bottom",
        },
        {
          label: "Text on the Right",
          value: "text-right",
        },
      ]
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
                onChange={(event) => setValue(
                    event.target.value,
                    "divRatio"
                )}
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
                20 Percent Text - 80 Percent Image
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

function renderAttributeRow(
    label,
    setValue,
    textId,
    textValue,
    textOptions,
    imageSection = false,
    imageId      = null,
    imageValue   = null,
    imageOptions = []
) {
  return (
      <div className="row mb-2">
        <div className="col-2">{label}</div>
        <div className="col-5">
          {renderSelect(textId, textValue, textOptions, setValue)}
        </div>
        <div className="col-5">
          {imageSection && renderSelect(imageId, imageValue, imageOptions, setValue)}
        </div>
      </div>
  );
}

function renderAttributes(
    imageSection,
    textMarginTop,
    textMarginBottom,
    textMarginRight,
    textMarginLeft,
    textBackgroundColor,
    imageMarginTop,
    imageMarginBottom,
    imageMarginRight,
    imageMarginLeft,
    imageBackgroundColor,
    setValue
) {
  const marginTopOptions    = getMarginOptions("top");
  const marginLeftOptions   = getMarginOptions("left");
  const marginBottomOptions = getMarginOptions("bottom");
  const marginRightOptions  = getMarginOptions("right");

  return (
      <>
        <div className="row mb-2">
          <div className="col-2"></div>
          <div className="col-5 text-center">
            Text
          </div>
          <div className="col-5 text-center">
            {imageSection && "Image"}
          </div>
        </div>
        {
          renderAttributeRow(
              "Top Margin",
              setValue,
              "textMarginTop",
              textMarginTop,
              marginTopOptions,
              imageSection,
              "imageMarginTop",
              imageMarginTop,
              marginTopOptions
          )
        }
        {
          renderAttributeRow(
              "Left Margin",
              setValue,
              "textMarginLeft",
              textMarginLeft,
              marginLeftOptions,
              imageSection,
              "imageMarginLeft",
              imageMarginLeft,
              marginLeftOptions
          )
        }
        {
          renderAttributeRow(
              "Bottom Margin",
              setValue,
              "textMarginBottom",
              textMarginBottom,
              marginBottomOptions,
              imageSection,
              "imageMarginBottom",
              imageMarginBottom,
              marginBottomOptions
          )
        }
        {
          renderAttributeRow(
              "Right Margin",
              setValue,
              "textMarginRight",
              textMarginRight,
              marginRightOptions,
              imageSection,
              "imageMarginRight",
              imageMarginRight,
              marginRightOptions
          )
        }
        {
          renderAttributeRow(
              "Background Color",
              setValue,
              "textBackgroundColor",
              textBackgroundColor,
              backgroundColors,
              imageSection,
              "imageBackgroundColor",
              imageBackgroundColor,
              backgroundColors
          )
        }
      </>
  );
}

// *** Utility Functions ***/

function getMarginOptions(marginType) {
  const prefixes = {
    none:   "",
    top:    "mt-",
    bottom: "mb-",
    left:   "ms-",
    right:  "me-",
  };

  const labelPrefixes = {
    none:   "",
    top:    "Margin Top",
    bottom: "Margin Bottom",
    left:   "Margin Left",
    right:  "Margin Right",
  };

  const prefix = prefixes[marginType];
  const label  = labelPrefixes[marginType];

  return prefix
         ? Array.from({ length: 6 }, (_, i) => (
          {
            value: `${prefix}${i}`,
            label: i === 0 ? "None" : `${label} - #${i}`,
          }
      ))
         : [];
}

function setFormattingElement(sectionData, fieldName, regex, newValue, elementType = "classes") {
  const formatting = sectionData.formatting;
  const fieldType  = (elementType === "styles") ?
                     /^image/.test(fieldName) ? "image_styles" : "text_styles"
                                                :
                     /^image/.test(fieldName) ? "image_classes" : "text_classes";

  if (formatting[fieldType]) {
    formatting[fieldType] = formatting[fieldType].replace(regex, "").trim(); // Strip out old Value
    formatting[fieldType] += " " + newValue; // Add new value in
  }
  else {
    formatting[fieldType] = newValue; // Add new value in
  }
}

function setFormattingClassElement(sectionData, fieldName, newValue) {
  switch (true) {
    case /mt\-(\d)/.test(newValue):
      setFormattingElement(sectionData, fieldName, /mt\-(\d+)/, newValue);
      break;
    case /mb\-(\d)/.test(newValue):
      setFormattingElement(sectionData, fieldName, /mb\-(\d+)/, newValue);
      break;
    case /ms\-(\d)/.test(newValue):
      setFormattingElement(sectionData, fieldName, /ms\-(\d+)/, newValue);
      break;
    case /me\-(\d)/.test(newValue):
      setFormattingElement(sectionData, fieldName, /me\-(\d+)/, newValue);
      break;
    case /col\-\d{1,2}/.test(newValue):
      setFormattingElement(sectionData, fieldName, /col\-\w*\-?\d{1,2}/g, newValue);
      break;
  }
}

function setFormattingStyleElement(sectionData, fieldName, newValue) {
  switch (true) {
    case /background\-color:\s*(.+)\s*;?/.test(newValue):
      setFormattingElement(
          sectionData,
          fieldName,
          /background\-color:\s*(.+)\s*;?/,
          newValue,
          "styles"
      );
      break;
  }
}

function mapReactValuesToSection(sectionData, attribute, value) {
  let textColumnWidth;
  let imageColumnWidth;

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
      [textColumnWidth, imageColumnWidth] = getColumWidths(sectionData.div_ratio, value)

      setFormattingClassElement(sectionData, "textColumnWidth", textColumnWidth);
      setFormattingClassElement(sectionData, "imageColumnWidth", imageColumnWidth);

      sectionData.row_style            = value;
      sectionData.formatting.row_style = value;

      break;
    case "divRatio":
      [textColumnWidth, imageColumnWidth] = getColumWidths(value, sectionData.row_style)

      setFormattingClassElement(sectionData, "textColumnWidth", textColumnWidth);
      setFormattingClassElement(sectionData, "imageColumnWidth", imageColumnWidth);

      sectionData.div_ratio = value;
      sectionData.formatting.div_ratio = value;

      break;
    case 'textMarginTop':
      sectionData.text_attributes.margin_top = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'textMarginBottom':
      sectionData.text_attributes.margin_bottom = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'textMarginLeft':
      sectionData.text_attributes.margin_left = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'textMarginRight':
      sectionData.text_attributes.margin_right = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'imageMarginTop':
      sectionData.image_attributes.margin_top = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'imageMarginBottom':
      sectionData.image_attributes.margin_bottom = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'imageMarginLeft':
      sectionData.image_attributes.margin_left = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'imageMarginRight':
      sectionData.image_attributes.margin_right = value;
      setFormattingClassElement(sectionData, attribute, value);
      break;
    case 'textBackgroundColor':
      sectionData.text_attributes.background_color = value;
      setFormattingStyleElement(sectionData, attribute, `background-color: ${value};`);
      break;
    case 'imageBackgroundColor':
      sectionData.image_attributes.background_color = value;
      setFormattingStyleElement(sectionData, attribute, `background-color: ${value};`);
      break;
  }
}

function stringOrValue(value) {
  if (typeof value === "string")
    return value;
  else
    return value.value;
}

function convertType(value, attribute) {
  switch (attribute) {
    case "contentType":
      return stringOrValue(value);
    case "sectionName":
      return value;
    case "sectionOrder":
      if (value === null)
        return null;
      else
        return parseInt(value, 10);
    case "image":
      return stringOrValue(value);
    case "link":
      return value;
    case "rowStyle":
      return stringOrValue(value);
    case "divRatio":
      return stringOrValue(value);
    case "description":
      return value;
    case "textMarginTop":
      return stringOrValue(value);
    case "textMarginLeft":
      return stringOrValue(value);
    case "textMarginBottom":
      return stringOrValue(value);
    case "textMarginRight":
      return stringOrValue(value);
    case "textBackgroundColor":
      return stringOrValue(value);
    case "imageMarginTop":
      return stringOrValue(value);
    case "imageMarginLeft":
      return stringOrValue(value);
    case "imageMarginBottom":
      return stringOrValue(value);
    case "imageMarginRight":
      return stringOrValue(value);
    case "imageBackgroundColor":
      return stringOrValue(value);
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
  section:               PropTypes.shape({
                                           content_type:     PropTypes.string,
                                           section_name:     PropTypes.string,
                                           section_order:    PropTypes.number,
                                           image:            PropTypes.string,
                                           link:             PropTypes.string,
                                           description:      PropTypes.string,
                                           row_style:        PropTypes.string,
                                           text_attributes:  PropTypes.shape({
                                                                               margin_top:       PropTypes.string,
                                                                               margin_left:      PropTypes.string,
                                                                               margin_right:     PropTypes.string,
                                                                               margin_bottom:    PropTypes.string,
                                                                               background_color: PropTypes.string,
                                                                             }),
                                           image_attributes: PropTypes.shape({
                                                                               margin_top:       PropTypes.string,
                                                                               margin_left:      PropTypes.string,
                                                                               margin_right:     PropTypes.string,
                                                                               margin_bottom:    PropTypes.string,
                                                                               background_color: PropTypes.string,
                                                                             }),
                                         }),
  availableContentTypes: PropTypes.arrayOf(PropTypes.string),
  availableImages:       PropTypes.arrayOf(PropTypes.string),
};

export default SectionEditor;
