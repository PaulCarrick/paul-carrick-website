// /app/javascript/views/admin/image_files/edit.js

// Fetch groups from the API
async function fetchGroups() {
  const groupSelectContainer = document.getElementById("group-select-container");

  try {
    const response = await fetch("/api/v1/image_files/groups");

    if (!response.ok) {
      throw new Error("Failed to fetch groups");
    }
    const data = await response.json();
    populateGroupSelect(data);

    groupSelectContainer.style.display = 'block';
  } catch (error) {
    console.error("Error fetching groups:", error);
  }
}

// Populate the select dropdown with group options
function populateGroupSelect(groups) {
  const groupSelect = document.getElementById("group-select");

  groupSelect.innerHTML = ""; // Clear existing options

  const blankOption = document.createElement("option");
  blankOption.value = "";
  blankOption.dataset.maxSlideOrder = null;
  blankOption.textContent = "";
  groupSelect.appendChild(blankOption);

  for (const [group, maxSlideOrder] of Object.entries(groups)) {
    const option = document.createElement("option");
    option.value = group;
    option.dataset.maxSlideOrder = maxSlideOrder; // Store max slide order as a data attribute
    option.textContent = `${group} (Max Slide Order: ${maxSlideOrder})`;
    groupSelect.appendChild(option);
  }
}

function groupChanged() {
  const groupSelect = document.getElementById("group-select");
  const selectedOption = groupSelect.options[groupSelect.selectedIndex];
  const selectedGroup = selectedOption.value;
  const maxSlideOrder = parseInt(selectedOption.dataset.maxSlideOrder, 10);
  const groupField = document.getElementById("group-field");
  const slideOrderField = document.getElementById("slide-order-field");

  // Set the group field and slide order field
  groupField.value = selectedGroup;
  slideOrderField.value = maxSlideOrder + 1;
}

async function validateHtml(field, fieldName) {
  const htmlContent = field.value;

  // Call the API to validate HTML
  const response = await fetch('/api/v1/validate_html', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content // CSRF token for Rails
    },
    body: JSON.stringify({html: htmlContent, field: fieldName})
  });

  // Handle the response
  if (response.ok) {
    field.classList.remove('invalid');
    return true;
  } else {
    const result = await response.json();
    alert(`HTML Validation Errors:\n${result.errors.join('\n')}`);
    field.classList.add('invalid'); // Add error styling
    return false;
  }
}

async function checkHTML(field) {
  const fieldName = field.getAttribute("name"); // Get the field name dynamically

  // Call validateHtml to check the HTML content
  const isValid = await validateHtml(field, fieldName);
  const errorArea = document.getElementById('error_area');

  if (!isValid) {
    if (errorArea)
      errorArea.innerHTML = `<p style="color: red;">The HTML content is invalid. Please correct it.</p>`;
  } else {
    if (errorArea)
      errorArea.innerHTML = ``;
  }
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
