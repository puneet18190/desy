// funzioni di inizializzazione standard

function initializeImageGalleryInLessonEditor() {
  $('#lesson_editor_image_gallery_container #image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeAudioGalleryInLessonEditor() {
  $('#lesson_editor_audio_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeVideoGalleryInLessonEditor() {
  $('#lesson_editor_video_gallery_container #video_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeVideoEditorMixedGallery() {
  $('#video_editor_mixed_gallery_container #video_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#video_editor_mixed_gallery_container #image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeAudioGalleryInVideoEditor() {
  $('#video_editor_audio_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeAudioGalleryInAudioEditor() {
  $('#audio_editor_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

function initializeImageGalleryInImageEditor() {
  $('#image_gallery_for_image_editor #image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
}

// fino a qui


function resizedWidthForImageGallery(width, height) {
  if(height > width) {
    return (420 * width / height) + 20;
  } else {
    return 440;
  }
}
