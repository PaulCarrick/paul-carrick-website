// /app/assets/javascripts/views/shared/utilities
var editorMode = "rtf";

function handleEditorChange(content, id) {
    if (!content || !id) return;

    const hiddenFieldName = id.replace(/-/g, "_");
    const hiddenField     = document.getElementById(hiddenFieldName);

    if (hiddenField) hiddenField.value = content;
}

function reloadPage(delay) {
    setTimeout(() => {
        window.location.reload();
    }, delay);
}

function setEditorModeFlag(flag) {
    editorMode = flag;
}

function getEditorModeFlag() {
    return editorMode;
}

function setError(errorMessage) {
    const errorArea = document.getElementById('error-area');

    if (errorArea)
        errorArea.innerHTML = '<p style="color: red;">' + errorMessage + '</p>';
}

function clearError() {
    const errorArea = document.getElementById('error-area');

    if (errorArea)
        errorArea.innerHTML = '';
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
    else
        clearError();

    return results;
}

function checkJSON(field, jsonText) {
    let results = true;
    let errorMessage = null;

    if (!field || !field.value)
        return results;

    try {
        JSON.parse(jsonText ? jsonText : field.value);
    } catch (e) {
        errorMessage = `JSON Validation Errors:<br>${e.toString()}`;

        field.classList.add('invalid');

        results = false;
    }

    if (errorMessage)
        setError(errorMessage);
    else
        clearError();

    return results;
}

function showVideoPlayer(src) {
    const videoPlayer = document.getElementById('videoPlayer');
    const videoElement = document.getElementById('videoElement');

    if (!(videoPlayer && videoElement))
        return;

    videoElement.src = src;
    videoPlayer.style.display = 'block';
}

function closeVideoPlayer() {
    // Get the video player div and video element
    const videoPlayer = document.getElementById('videoPlayer');
    const videoElement = document.getElementById('videoElement');

    if (!(videoPlayer && videoElement))
        return;

    videoElement.pause();

    videoElement.src = '';
    videoPlayer.style.display = 'none';
}

function copyEditorData(rtfEditorId, rawEditorId) {
    const rtfEditor = document.getElementById(rtfEditorId);
    const rawEditor = document.getElementById(rawEditorId);
    let result = false;

    if (rtfEditor && rawEditor) {
        if (getEditorModeFlag() === 'rtf')
            rawEditor.value = rtfEditor.value;
        else
            rtfEditor.value = rawEditor.value;

        result = true;
    }

    return result;
}

function toggleEditor(button, rtfEditorContainerId, rtfEditorId, rawEditorContainerId, rawEditorId) {
    const rtfEditorContainer = document.getElementById(rtfEditorContainerId);
    const rawEditorContainer = document.getElementById(rawEditorContainerId);
    let result = copyEditorData(rtfEditorId, rawEditorId);

    if (getEditorModeFlag() === 'rtf') { // We are in RTF switching to raw
        rtfEditorContainer.style.display = "none";
        rawEditorContainer.style.display = "block";
        button.textContent = "RTF Editor";

        setEditorModeFlag('raw');
    } else {// We are in Raw switching to RTF
        rtfEditorContainer.style.display = "block";
        rawEditorContainer.style.display = "none";
        button.textContent = "Raw HTML";

        setEditorModeFlag('rtf');
    }

    return result;
}

function validateEditor(rtfEditorId, rawEditorId) {
    let isValid = copyEditorData(rtfEditorId, rawEditorId);

    if (isValid) {
        const editorField = document.getElementById(rtfEditorId);

        isValid = checkHtml(editorField);
    }

    return isValid;
}

function clearSort() {
    const currentUrl = new URL(window.location.href);
    const params = currentUrl.searchParams;
    const new_params = {};
    let existingParams = false;

    for (const key of params.keys()) {
        if (!key.startsWith('sort') && !key.startsWith('direction') && !key.startsWith('clear_sort')) {
            new_params[key] = params[key];
            existingParams = true
        }
    }

    if (existingParams)
        document.location.href = `${currentUrl.pathname}?${new_params.toString()}&clear_sort=true`;
    else
        document.location.href = currentUrl.pathname + "?clear_sort=true";
}

function clearSearch() {
    const currentUrl = new URL(window.location.href);
    const params = currentUrl.searchParams;
    const new_params = {};
    let existingParams = false;

    for (const key of params.keys()) {
        if (!key.startsWith('q[') && !key.startsWith('clear_search')) {
            new_params[key] = params[key];
            existingParams = true
        }
    }

    if (existingParams)
        document.location.href = `${currentUrl.pathname}?${new_params.toString()}&clear_search=true`;
    else
        document.location.href = currentUrl.pathname + "?clear_search=true";
}

function clearForm(formId) {
    const form = document.getElementById(formId);

    if (!form) {
        console.error(`Form with ID "${formId}" not found.`);
        return;
    }

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
}

function setSelectedForArray(group, fields) {
    const selectedRadio = document.querySelector(`input[name="${group}"]:checked`);

    if (!selectedRadio) return;

    fields.forEach((fieldId) => {
        const hiddenField = document.getElementById(fieldId);

        if (hiddenField)
            hiddenField.value = (fieldId === selectedRadio.value).toString();
        else
            console.warn(`Hidden field with ID "${fieldId}" not found.`);
    });
}

function setupRadioGroupArray(group, fields) {
    let selectedField = null;

    fields.forEach((fieldId) => {
        const hiddenField = document.getElementById(fieldId);

        if (hiddenField && hiddenField.value === "true")
            selectedField = fieldId;
    });

    if (!selectedField) {
        console.warn("No hidden field is set to true.");
        return;
    }

    const radioToSelect = document.querySelector(`input[name="${group}"][value="${selectedField}"]`);

    if (radioToSelect)
        radioToSelect.checked = true;
    else
        console.warn(`Radio button with value "${selectedField}" not found in group "${group}".`);
}
