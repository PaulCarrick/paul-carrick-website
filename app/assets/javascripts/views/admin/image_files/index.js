// /app/javascript/views/admin/image_files/index.js

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
