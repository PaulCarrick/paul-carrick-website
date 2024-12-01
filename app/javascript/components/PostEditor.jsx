import React, { useState } from 'react';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';

const PostEditor = ({ user, post, closeEditor }) => {
  const [title, setTitle] = useState(post?.title || ''); // Use existing title if editing
  const [author, setAuthor] = useState(user.name); // Always set to the current user
  const [content, setContent] = useState(post?.content || ''); // Use existing content if editing
  const [posted, setPosted] = useState(post?.posted || new Date().toISOString()); // Set posted if editing, otherwise use now
  const [visibility, setVisibility] = useState(post?.visibility || ''); // Default visibility

  const handleSubmit = () => {
    const getCsrfToken = () => {
      return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    };

    const url = post
      ? `/api/v1/blog_posts/${post.id}` // Include the ID for updates
      : '/api/v1/blog_posts'; // Create new post

    const method = post ? 'PUT' : 'POST'; // Use PUT for updates, POST for new

    fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken(), // Include the CSRF token here
      },
      body: JSON.stringify({
        blog_post: { title, author, content, posted, visibility }, // Include all fields
      }),
    })
      .then((response) => {
        if (response.ok) {
          console.log('Post saved successfully!');
          closeEditor(); // Close the editor on success
          window.location.href = '/blog'; // Redirect to the blog page
        } else {
          console.error('Failed to save post');
        }
      })
      .catch((error) => console.error('Error:', error));
  };

  return (
    <div>
      <h1>{post ? 'Edit Post' : 'Create a New Post'}</h1>
      <input
        type="text"
        placeholder="Title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        className="form-control mb-2"
      />
      <input
        type="text"
        placeholder="Author"
        value={author}
        className="form-control mb-2"
        readOnly
      />
      <input
        type="hidden"
        value={posted} // Hidden input to hold the DateTime value
        readOnly
      />
      <div className="mb-2">
        <label htmlFor="visibility" className="form-label">Visibility</label>
        <select
          id="visibility"
          value={visibility}
          onChange={(e) => setVisibility(e.target.value)}
          className="form-control"
        >
          <option value="">Select visibility</option>
          <option value="public">Public</option>
          <option value="private">Private</option>
        </select>
      </div>
      <ReactQuill value={content} onChange={setContent} />
      <div className="mt-3">
        <button onClick={handleSubmit} className="btn btn-primary me-2">
          {post ? 'Update' : 'Submit'}
        </button>
        <button onClick={closeEditor} className="btn btn-secondary">
          Cancel
        </button>
      </div>
    </div>
  );
};

export default PostEditor;
