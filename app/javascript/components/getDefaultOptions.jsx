// /app/javascript/components/getDefaultOptions.jsx
// noinspection JSCheckFunctionSignatures

// Default options for the DisplayContent

import parseStyle from "./parseStyle";

const getDefaultOptions = (format = "{}") => {
  let options = format;

  if (!options) {
    options = {
      row_style: "text-single",
      row_classes: "align-items-center",
      text_classes: "col-lg-6",
      text_styles: {},
      image_classes: "col-lg-6 d-flex flex-column",
      image_styles: { objectFit: "contain"},
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
    ? {...parseStyle(options.image_styles)}
    : {objectFit: "contain"};
  options.caption_classes = options.caption_classes || "text-center";
  options.expanding_rows = options.expanding_rows || null;
  options.slide_show_images = options.slide_show_images || null;
  options.slide_show_type = options.slide_show_type || null;

  return options;
};

export default getDefaultOptions;
