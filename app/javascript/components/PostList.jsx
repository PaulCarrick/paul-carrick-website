import React, { useEffect, useState } from 'react';
import moment from 'moment';
import PostEditor from './PostEditor'; // Import your PostEditor component

const PostList = ({ permit_editing = false }) => {
  const [posts, setPosts] = useState([]);
  const [expandedPosts, setExpandedPosts] = useState({});
  const [showEditor, setShowEditor] = useState(false); // State to toggle PostEditor

  useEffect(() => {
    fetch('/api/v1/blog_posts?include_comments=true')
      .then((response) => response.json())
      .then((data) => setPosts(data));
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

  return (
    <div>
      <h1 className={"text-dark"}>Blog Entries</h1>
      {posts.map((post) => (
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
                    ? post.content.substring(0, 100) + "... "
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
      {showEditor && (
        <PostEditor closeEditor={closeEditor} />
      )}
    </div>
  );
};

export default PostList;
