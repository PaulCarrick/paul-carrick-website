import React from "react";
import {createRoot} from "react-dom/client";
import App from "./App";

const ReactRailsUJS = require("react_ujs");

import NavMenu from "./NavMenu";
import DisplayContent from "./DisplayContent";
import SlideShow from "./SlideShow";
import PostList from "./PostList";
import PostEditor from "./PostEditor";
import CommentEditor from "./CommentEditor";
import PostDetail from "./PostDetail";
import RenderContent from "./RenderContent";
import ContentBlock from "./ContentBlock";
import RenderImage from "./RenderImage";
import RenderSingleImage from "./RenderSingleImage";
import RenderSlideShow from "./RenderSlideShow";

try {
  ReactRailsUJS.register({
                           NavMenu,
                           DisplayContent,
                           SlideShow,
                           PostList,
                           PostEditor,
                           CommentEditor,
                           PostDetail,
                           RenderContent,
                           ContentBlock,
                           RenderImage,
                           RenderSingleImage,
                           RenderSlideShow,
                         });
}
catch (error) {
  if (!(error instanceof TypeError))
    throw error;
}

document.addEventListener("turbo:load", () => {
  const root = createRoot(
    document.body.appendChild(document.createElement("div"))
  );
  root.render(<App/>);
});
