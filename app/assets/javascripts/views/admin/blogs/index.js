// /app/javascript/views/admin/blogs/index.js

document.addEventListener("click", function (event) {
  if (event.target.matches("[data-action='expand-content']")) {
    event.preventDefault();

    const postId = event.target.dataset.postId;
    const contentSpan = document.querySelector(`#post-content-${postId}`);

    contentSpan.innerHTML = event.target.dataset.content;
    event.target.style.display = "none";
  }
});

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
