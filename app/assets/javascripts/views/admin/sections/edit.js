// /app/javascript/views/admin/sections/edit.js

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
  let isValid = validateEditor('rtf-description', 'raw-description')

  if (isValid) {
    const formattingField = form.querySelector('[name="section[formatting]"]');
    const formatting = textToFormatting(formattingField.value);

    isValid = checkJSON(formattingField, formatting)

    if (!isValid) {
      setError('The formatting field does not contain valid JSON. Please fix it before submitting.');
    } else {
      formattingField.value = formatting;
    }
  }

  return isValid;
}
