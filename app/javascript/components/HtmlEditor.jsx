// /app/javascript/components/HtmlEditor.jsx

// Use Quil (a WYSIWYG Editor) to edit text

import React, { useState, useRef } from "react";
import PropTypes from "prop-types";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const HtmlEditor = ({
                      id = "",
                      value = "",
                      placeholder = "Enter text here...",
                      onChange = null,
                      onBlur = null }) => {
  const [isHtmlView, setIsHtmlView] = useState(false); // Toggle for raw HTML view
  const [editorContent, setEditorContent] = useState(value || ""); // Store editor content
  const quillRef = useRef(null);

  const toggleView = () => {
    if (isHtmlView) {
      // Switching back to Quill editor
      const quill = quillRef.current?.getEditor();
      if (quill) {
        quill.clipboard.dangerouslyPasteHTML(editorContent); // Update Quill with the raw HTML
      }
    } else {
      // Switching to HTML view
      const quill = quillRef.current?.getEditor();
      if (quill) {
        setEditorContent(quill.root.innerHTML); // Update raw HTML content
      }
    }
    setIsHtmlView(!isHtmlView);
  };

  const handleChange = (content) => {
    setEditorContent(content); // Keep local state updated

    if (typeof onChange === "function") {
      onChange(content, id);
    } else if (onChange && typeof onChange === "string") {
      const callable = new Function("editorContent", "id", onChange);
      callable(content, id);
    }
  };

  const handleBlur = () => {
    const quill = quillRef.current?.getEditor();
    const content = quill?.root.innerHTML;

    if (typeof onBlur === "function") {
      onBlur(content, id);
    } else if (onBlur && typeof onBlur === "string") {
      const callable = new Function("editorContent", "id", onBlur);
      callable(content, id);
    }
  };

  return (
    <div>
      <button onClick={toggleView} className="btn btn-primary mb-2">
        {isHtmlView ? "Switch to Editor View" : "Switch to HTML View"}
      </button>
      {isHtmlView ? (
        <textarea
          value={editorContent}
          onChange={(e) => setEditorContent(e.target.value)}
          onBlur={handleBlur}
          className="form-control"
          placeholder="Edit raw HTML here"
          rows={10}
        />
      ) : (
         <ReactQuill
           ref={quillRef}
           theme="snow"
           id={id}
           value={editorContent}
           onChange={handleChange}
           onBlur={handleBlur}
           className="form-control"
           placeholder={placeholder}
         />
       )}
    </div>
  );
};

HtmlEditor.propTypes = {
  id: PropTypes.string.isRequired,
  value: PropTypes.string,
  placeholder: PropTypes.string,
  onChange: PropTypes.oneOfType([PropTypes.func, PropTypes.string]),
  onBlur: PropTypes.oneOfType([PropTypes.func, PropTypes.string]),
};

export default HtmlEditor;
