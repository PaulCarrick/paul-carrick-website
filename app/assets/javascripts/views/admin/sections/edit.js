// /app/javascript/views/admin/sections/edit.js

function setError(errorMessage) {
  const errorArea = document.getElementById('error-area');

  if (errorArea)
    errorArea.innerHTML = '<p style="color: red;">' + errorMessage + '</p>';
}

function checkJSON(formatting) {
  const errorArea = document.getElementById('error-area');

  try {
    JSON.parse(formatting);

    if (errorArea)
      errorArea.innerHTML = ``;

    return true;
  } catch (error) {
    if (error instanceof SyntaxError) {

      if (errorArea)
        errorArea.innerHTML = `<p style="color: red;">The JSON content is invalid: ${error.message}</p><p>${formatting}</p>`;
    } else {
      console.error("Unexpected Error in parsing JSON:", error.message);
    }

    return false;
  }
}

function checkHtml(field) {
  let results = true;
  let errorMessage = null;

  if (!field || !field.value)
    return results;

  try {
    const parser = new DOMParser();
    const doc = parser.parseFromString(field.value, 'text/html');

    if (doc.querySelector('parsererror')) {
      errorMessage = 'The HTML content is invalid. Please correct it.';
      results = false;

      field.classList.add('invalid');
    } else {
      results = true;
    }
  } catch (e) {
    errorMessage = `HTML Validation Errors:<br>${e.toString()}`;

    field.classList.add('invalid');

    results = false;
  }

  if (errorMessage)
    setError(errorMessage);

  return results;
}

function textToFormatting(text) {
  if (!text)
    return "";

  const options = text.split("\n");

  if (options === "")
    return options;

  let results = "{\n";

  for (const option of options) {
    let [optionName, optionValue] = option.split(/:(.+)/);

    if (!(optionName && optionValue))
      continue;

    optionName = optionName.trim();
    optionValue = optionValue.trim();

    if (results !== "{\n")
      results += ",\n    ";
    else
      results += "    ";

    results += '"' + optionName + '": "' + optionValue + '"';
  }

  results += "\n}"

  return results;
}

function validate(form) {
  const formattingField = form.querySelector('[name="section[formatting]"]');
  const descriptionField = document.getElementById('rtf-editor')
  let isValid = checkHtml(descriptionField);

  if (isValid) {
    const formatting = textToFormatting(formattingField.value);

    isValid = checkJSON(formatting)

    if (!isValid) {
      setError('The formatting field does not contain valid JSON. Please fix it before submitting.');
    } else {
      formattingField.value = formatting;
    }
  }

  return isValid;
}

function toggleEditor(button, rtfEditorId, rawEditorId) {
  const rtfEditor = document.getElementById(rtfEditorId);
  const rawEditor = document.getElementById(rawEditorId);

  if (rtfEditor.style.display === "none") {
    rtfEditor.style.display = "block";
    rawEditor.style.display = "none";
    button.textContent = "Raw HTML";
  } else {
    rtfEditor.style.display = "none";
    rawEditor.style.display = "block";
    button.textContent = "HTML";
  }
}
