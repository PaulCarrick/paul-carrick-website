import React, { useEffect, useState } from 'react';
import moment from 'moment';
import PostEditor from './PostEditor';

const PostList = ({ permit_editing = false }) => {
  const [posts, setPosts] = useState([]);
  const [filteredPosts, setFilteredPosts] = useState([]);
  const [expandedPosts, setExpandedPosts] = useState({});
  const [searchTerm, setSearchTerm] = useState('');
  const [showEditor, setShowEditor] = useState(false);

  useEffect(() => {
    fetch('/api/v1/blog_posts?include_comments=true')
      .then((response) => response.json())
      .then((data) => {
        setPosts(data);
        setFilteredPosts(data); // Initialize filteredPosts with all posts
      });
  }, []);

  const DateTimeDisplay = ({ dateTime }) => {
    const formattedDate = moment(dateTime).local().format('MMM Do YYYY HH:mm');
    return formattedDate;
  };

  const toggleExpand = (postId) => {
    setExpandedPosts((prevState) => ({
      ...prevState,
      [postId]: !prevState[postId],
    }));
  };

  const openEditor = () => {
    setShowEditor(true);
  };

  const closeEditor = () => {
    setShowEditor(false);
  };

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchTerm.trim() === '') {
      setFilteredPosts(posts);
    } else {
      const filtered = posts.filter((post) =>
        post.content.toLowerCase().includes(searchTerm.toLowerCase())
      );
      setFilteredPosts(filtered);
    }
  };

  return (
    <div>
      <h1 className="text-dark">Blog Entries</h1>
      {filteredPosts.map((post) => (
        <div key={post.id} className="ps-3 mb-3">
          <div className="row ps-3">
            <div className="col-lg-12">
              <h2>{post.title}</h2>
              {DateTimeDisplay({ dateTime: post.posted })} - {post.author}
            </div>
          </div>
          <div className="row ps-5 pt-3">
            <div className="col-lg-12">
              {expandedPosts[post.id] ? (
                <>
                  {post.content}
                  <button
                    onClick={() => toggleExpand(post.id)}
                    className="btn btn-link"
                  >
                    Show Less
                  </button>
                </>
              ) : (
                <>
                  {post.content.length > 100
                    ? post.content.substring(0, 100) + '... '
                    : post.content}
                  {post.content.length > 100 && (
                    <button
                      onClick={() => toggleExpand(post.id)}
                      className="btn btn-link"
                    >
                      Read More
                    </button>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
      ))}

      {/* Add Post Button */}
      {permit_editing && !showEditor && (
        <div className="mt-3">
          <button onClick={openEditor} className="btn btn-primary">
            Add Post
          </button>
        </div>
      )}

      {/* Render PostEditor */}
      {showEditor && <PostEditor closeEditor={closeEditor} />}

      {/* Search Form */}
      <div className="mt-3">
        <form onSubmit={handleSearch}>
          <div className="mb-3">
            <label htmlFor="search" className="form-label">
              Search For:
            </label>
            <input
              type="text"
              id="search"
              className="form-control"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Enter search term"
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Search
          </button>
        </form>
      </div>
    </div>
  );
};

export default PostList;
