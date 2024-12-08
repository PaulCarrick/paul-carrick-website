// /app/javascript/views/admin/image_files/index.js

const apiUrl = "/api/v1/image_files/groups";

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

async function addToGroup(imageFileId) {
  try {
    // Fetch groups from the API
    const response = await fetch(apiUrl);
    if (!response.ok) throw new Error("Failed to fetch groups");
    const groups = await response.json();

    // Show popup and populate select
    const group = prompt(
      `Select a group:\n${Object.entries(groups)
        .map(([group, max]) => `${group} (max: ${max})`)
        .join("\n")}`
    );
    if (group && groups[group] !== undefined) {
      const maxSlideOrder = groups[group];

      // Update record via Rails
      await fetch(`/admin/image_files/${imageFileId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        },
        body: JSON.stringify({
          image_file: {
            group: group,
            slide_order: maxSlideOrder + 1,
          },
        }),
      });

      // Reload page to reflect changes
      location.reload();
    }
  } catch (error) {
    alert("An error occurred: " + error.message);
  }
}
