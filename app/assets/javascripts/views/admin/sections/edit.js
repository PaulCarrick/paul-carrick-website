// /app/javascript/views/admin/sections/edit.js

function descriptionBlurCallback(value, fieldName) {
  const field = document.getElementById(fieldName);

  if (field) field.value = value;
}

function setRowStyle(field, updatedSection) {
  document.dispatchEvent(
    new CustomEvent("sectionUpdate", {
      detail: { section: updatedSection, rowStyle: field.value },
    })
  );
}

function validate(form) {
  let isValid = validateEditor('rtf-description', 'raw-description')

  return isValid;
}
