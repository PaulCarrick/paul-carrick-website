import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

const ReactRailsUJS = require("react_ujs");

import NavMenu from "./NavMenu";
import DisplayContent from "./DisplayContent";
import SlideShow from "./SlideShow";

try {
    ReactRailsUJS.register({
        NavMenu,
        DisplayContent,
        SlideShow,
    });
} catch (error) {
    if (error instanceof TypeError) {
        console.error("Caught a TypeError:", error.message);
    } else {
        // Re-throw other errors to handle them elsewhere
        throw error;
    }
}

document.addEventListener("turbo:load", () => {
    const root = createRoot(
        document.body.appendChild(document.createElement("div"))
    );
    root.render(<App />);
});
