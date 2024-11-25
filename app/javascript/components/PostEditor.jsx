import React, {useState} from 'react';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';

const PostEditor = () => {
  const [title, setTitle] = useState('');
  const [author, setAuthor] = useState('');
  const [content, setContent] = useState('');

  const handleSubmit = () => {
    fetch('/api/v1/blog_posts', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        blog_post: {title, author, content}, // Nest under blog_posts
      }),
    })
      .then((response) => {
        if (response.ok) {
          console.log('Post created successfully!');
          // Redirect to the /blog page
          window.location.href = '/blog';
        } else {
          console.error('Failed to create post');
        }
      })
      .catch((error) => console.error('Error:', error));
  };

  return (
    <div>
      <h1>Create a New Post</h1>
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
        onChange={(e) => setAuthor(e.target.value)}
        className="form-control mb-2"
      />
      <ReactQuill value={content} onChange={setContent}/>
      <button onClick={handleSubmit} className="btn btn-primary mt-3">
        Submit
      </button>
    </div>
  );
};

export default PostEditor;
