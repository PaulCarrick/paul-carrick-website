// /app/javascripts/components/RenderContent.jsx

// Component to Display Section Records

import React from "react";
import DisplayContent from "./DisplayContent";

const RenderSection = ({
                         section = null,
                       }) => {
  const sectionData = JSON.parse(JSON.stringify(section)); // Dup Section so changes don't propagate

  if (typeof sectionData.formatting === "string") sectionData.formatting = JSON.parse(renderSection.formatting)

  const contents = buildContents(sectionData);
  const sections = [];

  processVideoImages(contents);

  contents.forEach(content => {
    sections.push(renderSection(content))
  });

  return (sections);
}

// Utility Functions

function renderSection(content) {
  return (
      <div className="row mb-2">
        <div id="sectionAttributes" className="w-100 border border-danger border-width-8">
          <DisplayContent
              content={content.description}
              image={content.image}
              link={content.link}
              format={content.formatting}
              sectionId={content.sectionName}
              textAttributes={content.text_attributes}
              imageAttributes={content.image_attributes}
          />
        </div>
      </div>
  );
}

function buildContents(section) {
  const contents = [];
  const subSection = process_section(section)

  contents.push(section)

  if (subSection) contents.push(subSection);

  return contents;
}

function process_section(section) {
  if (!section.image) return;

  const [images, description, formatting, subsection] = processImage(section);

  section.image = images;
  section.description = description;
  section.formatting = formatting;

  return subsection
}

function processImage(section) {
  let images = section.image.slice().trim();
  let description = section.description;
  let formatting = section.formatting;
  let subsection = null;

  const imageGroupRegex = /^\s*ImageGroup:\s*(.+)\s*$/;
  const imageFileRegex = /^\s*ImageFile:\s*(.+)\s*$/;
  const imageSectionRegex = /^\s*ImageSection:\s*(.+)\s*$/;
  const imageArrayRegex = /^\s*\[\s*(.+?)\s*\]\s*$/m;

  if (imageGroupRegex.test(images)) {
    const match = images.match(imageGroupRegex);

    [images, description, formatting] = handleImageGroup(match[1], formatting);
  } else if (imageFileRegex.test(images)) {
    const match = images.match(imageFileRegex);

    images = handleSingleImageFile(section, match[1]);
  } else if (imageSectionRegex.test(images)) {
    const match = images.match(imageSectionRegex);

    [images, description, subsection, formatting] = handleImageSection(section, match[1], formatting);
  } else if (imageArrayRegex.test(images)) {
    const match = images.match(imageArrayRegex);

    [images, formatting] = handleImageArray(match[1], formatting);
  } else {
    images = images.image_url;
  }

  return [images, description, formatting, subsection];
}

function handleImageGroup(group, formatting) {
  const imageFiles = imageFilesFindByGroup(group)

  if (imageFiles && (imageFiles.length > 0)) {
    const formatting = addImagesToFormatting(formatting, imageFiles);

    return [null, "", formatting];
  } else {
    return [missingImageUrl(), "", formatting];
  }
}

function handleSingleImageFile(section, name) {
  const imageFile = imageFileFindByName(name);
  const results = imageFile.image_url

  section.link = results;

  return results;
}

function handleImageSection(section, name, formatting) {
  const imageFile = imageFileFindByName(name);

  if (imageFile.image_url) {
    const description = `<div class='display-4 fw-bold mb-1 text-dark'>${imageFile.caption}</div>`;

    section.link = imageFile.image_url;

    const [subsection, updatedFormatting] = buildSubsection(section, imageFile, formatting);

    return [imageFile.image_url, description, subsection, updatedFormatting];
  } else {
    return [missingImageUrl(), "", null, null];
  }
}

function buildSubsection(section, imageFile, formatting) {
  const subsection = JSON.parse(JSON.stringify(section));

  subsection.link = null;
  subsection.image = null;
  subsection.formatting = flipFormattingSide(formatting);
  subsection.description = imageFile.description;

  if (formatting && 'expanding_rows' in formatting)
    delete formatting.expanding_rows;

  return [subsection, formatting];
}

function handleImageArray(imageList, formatting) {
  const images = imageList.split(",").map(imageName => imageFileFindByName(imageName.trim()));

  return [null, addImagesToFormatting(formatting, images)];
}

function processVideoImages(contents) {
  contents.forEach(content => {
    const match = content.description.match(/VideoImage:\s*"(.+)"/);

    if (match) replaceVideoImageTag(content, match[1]);
  });
}

function replaceVideoImageTag(content, name) {
  const imageFile = imageFileFindByName(name)
  const imageUrl = imageFile.image_url;

  if (imageUrl) {
    let label = imageFile.caption;

    if (!label)
      label = imageFile.name;

    const videoTag = `<a href="#" onclick="showVideoPlayer('${imageUrl}')">${label}</a>`;

    content.description = content.description.replace(/VideoImage:\s*"(.+)"/, videoTag);
  }
}

function swapClasses(formatting) {
  if (formatting.text_classes && formatting.image_classes) {
    formatting.image_classes = formatting.image_classes.replace(/w-\d{2,3}/g, "");

    const temp = formatting.image_classes;
    formatting.image_classes = formatting.text_classes;
    formatting.text_classes = temp;
  }

  if (formatting.row_classes) {
    formatting.row_classes = formatting.row_classes.replace(/mt-\d|pt-\d/g, "");
  }

  return formatting;
}

function flipFormattingSide(formatting) {
  let newFormatting = JSON.parse(JSON.stringify(formatting));

  if (!formatting || Object.keys(formatting).length === 0) {
    return {row_style: "text-right"};
  }

  if (newFormatting.row_style === "text-left") {
    newFormatting.row_style = "text-right";
    swapClasses(newFormatting);
  } else {
    newFormatting.row_style = "text-left";
    swapClasses(newFormatting);
  }

  return newFormatting;
}

function addImagesToFormatting(formatting, images) {
  formatting.slide_show_images = images.map(image => ({
    image_url: image.image_url,
    caption: image.caption,
    description: image.description
  }));

  return formatting;
}

function imageFilesFindByGroup(group) {
  getImageFiles(`q[group_eq]=${group}`).then((data) => {
    return data;
  });
}

function imageFileFindByName(name) {
  const imageData = getImageFiles(`q[name_eq]=${name}`);

  if (imageData && (imageData.length > 0))
    return imageData[0];
  else
    return missingImageFile();
}

function missingImageFile(name = "Unknown") {
  const imageFile = {
    name: "Missing File",
    caption: "Missing File",
    description: `We could not find an image named: ${name}.`,
    mime_type: "image/jpeg",
    group: null,
    image_url: missingImageUrl(),
  }

  return imageFile;
}

function missingImageUrl() {
  const rootPath = `${location.protocol}//${location.host}`;

  return `${rootPath}/images/missing-image.jpg`;
}

function getImageFiles(query) {
  try {
    const xhr = new XMLHttpRequest();

    xhr.open("GET", `/api/v1/image_files?${query}`, false);
    xhr.send();

    if (xhr.status === 200)
      return(JSON.parse(xhr.responseText));
    else
      return [missingImageFile("Unknown")];
  } catch (err) {
    return [missingImageFile("Unknown")];
  }
}

import PropTypes from 'prop-types';

RenderSection.propTypes = {
  section: PropTypes.shape({
    content_type: PropTypes.string,
    section_name: PropTypes.string,
    section_order: PropTypes.number,
    image: PropTypes.string,
    link: PropTypes.string,
    formatting: PropTypes.any,
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
  }).isRequired, // Use `.isRequired` here
};

export default RenderSection;
