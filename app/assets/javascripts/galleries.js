function initializeImageGallery() {
  $('#image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeAudioGallery() {
  $('#audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeVideoGallery() {
  $('#video_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeVideoEditorMixedGallery() {
  initializeVideoGallery();
  initializeImageGallery();
}
