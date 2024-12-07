// /app/javascript/views/admin/sections/index.js

function clearSort() {
  const currentUrl = new URL(window.location.href);
  const params = currentUrl.searchParams;

  for (const key of params.keys()) {
    if (key.startsWith('sections_sort')) {
      params.delete(key);
    }
    if (key.startsWith('direction')) {
      params.delete(key);
    }
  }

  if (params.toString() !== "")
    document.location.href = `${currentUrl.pathname}?${params.toString()}`;
  else
    document.location.href = currentUrl.pathname;
}

function clearSearchForm(formId) {
  const form = document.getElementById(formId);
  if (!form) {
    console.error(`Form with ID "${formId}" not found.`);
    return;
  }

  // Iterate over all form elements
  Array.from(form.elements).forEach(element => {
    switch (element.type) {
      case 'text':
      case 'search':
      case 'email':
      case 'number':
      case 'password':
      case 'textarea':
        element.value = ''; // Clear text inputs and textareas
        break;
      case 'checkbox':
      case 'radio':
        element.checked = false; // Uncheck checkboxes and radio buttons
        break;
      case 'select-one':
      case 'select-multiple':
        element.selectedIndex = -1; // Deselect options
        break;
      default:
        // For other input types like buttons, files, etc., do nothing
        break;
    }
  });

  const currentUrl = new URL(window.location.href);
  const params = currentUrl.searchParams;

  for (const key of params.keys()) {
    if (key.startsWith('q[')) {
      params.delete(key);
    }
  }

  if (params.toString() !== "")
    document.location.href = `${currentUrl.pathname}?${params.toString()}`;
  else
    document.location.href = currentUrl.pathname;
}
