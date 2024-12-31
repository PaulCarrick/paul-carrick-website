// /app/javascript/components/getDefaultOptions.jsx
// noinspection JSCheckFunctionSignatures

// Default options for the DisplayContent

import parseStyle from "./parseStyle";
import PropTypes from "prop-types";

const getDefaultOptions = (
    format          = {},
    textAttributes  = {},
    imageAttributes = {}
) => {
  const formatOptions = (typeof format === "string") ? JSON.parse(format) : JSON.parse(JSON.stringify(format));
  let options = {
    row_style:         "text-single",
    div_ratio:         "",
    row_classes:       "align-items-center",
    text_classes:      null,
    text_styles:       {},
    image_classes:     null,
    image_styles:      { objectFit: "contain" },
    image_caption:     null,
    caption_position:  "top",
    caption_classes:   "caption-default text-center",
    expanding_rows:    null,
    slide_show_images: null,
    slide_show_type:   null,
  };

  if (isPresent(formatOptions)) {
    // Assign options from format
    if (isPresent(formatOptions.row_style)) options.row_style = formatOptions.row_style;
    if (isPresent(formatOptions.div_ratio)) options.div_ratio = formatOptions.div_ratio;
    if (isPresent(formatOptions.row_classes)) options.row_classes = formatOptions.row_classes;
    if (isPresent(formatOptions.text_classes)) options.text_classes = formatOptions.text_classes;
    if (isPresent(formatOptions.image_classes)) options.image_classes = formatOptions.image_classes;
    if (isPresent(formatOptions.image_caption)) options.image_caption = formatOptions.image_caption;
    if (isPresent(formatOptions.expanding_rows)) options.expanding_rows = formatOptions.expanding_rows;
    if (isPresent(formatOptions.slide_show_type)) options.slide_show_type = formatOptions.slide_show_type;
    if (isPresent(formatOptions.caption_classes)) options.caption_classes = formatOptions.caption_classes;
    if (isPresent(formatOptions.caption_position)) options.caption_position = formatOptions.caption_position;
    if (isPresent(formatOptions.slide_show_images)) options.slide_show_images = formatOptions.slide_show_images;

    if (isPresent(formatOptions.text_styles)) {
      if (typeof formatOptions.text_styles === 'string')
        options.text_styles = parseStyle(formatOptions.text_styles);
      else
        options.text_styles = formatOptions.text_styles;
    }

    if (isPresent(formatOptions.image_styles)) {
      if (typeof formatOptions.image_styles === 'string')
        options.image_styles = parseStyle(formatOptions.image_styles);
      else
        options.image_styles = formatOptions.image_styles;
    }
  }
  else {
    if (isPresent(textAttributes)) {
      if (isPresent(textAttributes.margin_top)) options.text_classes = textAttributes.margin_top;
      if (isPresent(textAttributes.margin_left)) options.text_classes = textAttributes.margin_left;
      if (isPresent(textAttributes.margin_bottom)) options.text_classes = textAttributes.margin_bottom;
      if (isPresent(textAttributes.margin_right)) options.text_classes = textAttributes.margin_right;
      if (isPresent(textAttributes.background_color)) options.text_styles = {
        "background-color": textAttributes.background_color
      };
    }

    if (isPresent(imageAttributes)) {
      if (isPresent(imageAttributes.margin_top)) options.image_classes = imageAttributes.margin_top;
      if (isPresent(imageAttributes.margin_left)) options.image_classes = imageAttributes.margin_left;
      if (isPresent(imageAttributes.margin_bottom)) options.image_classes = imageAttributes.margin_bottom;
      if (isPresent(imageAttributes.margin_right)) options.image_classes = imageAttributes.margin_right;
      if (isPresent(imageAttributes.background_color)) options.image_styles = {
        "background-color": imageAttributes.background_color
      }
    }
  }

  if (hasSplitSections(options.row_style)) {
    const [textColumnWidth, imageColumnWidth] = getColumWidths(options.div_ratio, options.row_style);

    if (isPresent(options.text_classes)) {
      options.text_classes = options.text_classes.replace(/\bcol-\w*-\d{1,2}/g, "").trim();
      options.text_classes += " " + textColumnWidth;
    }
    else {
      options.text_classes = textColumnWidth;
    }

    if (isPresent(options.image_classes)) {
      options.image_classes = options.image_classes.replace(/\bcol-\w*-\d{1,2}/g, "").trim();
      options.image_classes += " " + imageColumnWidth;
    }
    else {
      options.image_classes = `d-flex flex-column ${imageColumnWidth}`;
    }
  }

  return new Object(options);
};

export function isPresent(variable) {
  if (typeof variable === "undefined") return false;
  if (variable === null) return false;
  if ((typeof variable === "string") && (variable === "")) return false;
  if (Array.isArray(variable) && (variable.length === 0)) return false;
  if ((typeof variable === "object") && (Object.keys(variable).length === 0)) return false;

  return true;
}
export function hasImageSection(rowStyle = "text-single") {
  return (rowStyle !== "text-single") && (rowStyle !== "") && (rowStyle !== null);
}

export function hasSplitSections(rowStyle = "text-single") {
  return (rowStyle === "text-left") || (rowStyle === "text-right");
}

export function getColumWidths(divRatio = "50:50", rowStyle = "text-single") {
  let textColumnWidth  = "col-12";
  let imageColumnWidth = "";

  if (hasSplitSections(rowStyle)) {
    if (divRatio) {
      const match = divRatio.match(/(\d+):(\d+)/);

      if (match) {
        let firstValue  = Math.round((parseInt(match[1], 10) / 100.0) * 12);
        let secondValue = 12 - firstValue;

        textColumnWidth  = `col-${firstValue}`;
        imageColumnWidth = `col-${secondValue}`;
      }
    }
    else {
      textColumnWidth  = "col-6";
      imageColumnWidth = "col-6";
    }
  }
  else {
    if (hasImageSection(rowStyle)) imageColumnWidth = "col-12"
  }

  return [textColumnWidth, imageColumnWidth]
}

export function updateFormatting(format,
                                 fieldName,
                                 value,
                                 rowStyle = 'text-single',
                                 divRatio = "50:50",
                                 mode = "update", ) {
  const textField = /^text/.test(fieldName);
  const imageField = /^image/.test(fieldName);
  const textOrImageField = textField || imageField;
  const [ textColumnWidth, imageColumnWidth ] = getColumWidths(divRatio, rowStyle);

  if ((mode !== "update") || !textOrImageField) {
    format[fieldName] = value;
  }
  else {
    const attributeField = textField ? "text_classes" : "image_classes";

    // Strip out the existing classes
    format[attributeField] = format[attributeField].replace(/\bcol-\w*-\d{1,2}|\bcol-\d{1,2}\b/g, "").trim();
  }

  // Strip out the existing col classes
  format.text_classes  = format.text_classes.replace(/\bcol-\w*-\d{1,2}|\bcol-\d{1,2}\b/g, "").trim();
  format.image_classes = format.image_classes.replace(/\bcol-\w*-\d{1,2}|\bcol-\d{1,2}\b/g, "").trim();
  format.text_classes  = `${format.text_classes} ${textColumnWidth}`;
  format.image_classes = `${format.image_classes} col-${imageColumnWidth}`;

  return format;
}

getDefaultOptions.propTypes = {
  format:  PropTypes.shape({
                                 row_style:         PropTypes.string,
                                 row_classes:       PropTypes.string,
                                 text_classes:      PropTypes.string,
                                 text_styles:       PropTypes.any,
                                 image_classes:     PropTypes.string,
                                 image_styles:      PropTypes.any,
                                 image_caption:     PropTypes.string,
                                 caption_position:  PropTypes.string,
                                 caption_classes:   PropTypes.string,
                                 expanding_rows:    PropTypes.string,
                                 slide_show_images: PropTypes.any,
                                 slide_show_type:   PropTypes.string,
                               }),
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
};

export default getDefaultOptions;
