// funzioni di inizializzazione standard

function initializeImageGalleryInLessonEditor() {
  $('#lesson_editor_image_gallery_container #image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#lesson_editor_image_gallery_container .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#lesson_editor_image_gallery_container').data('page');
    var tot_pages = $('#lesson_editor_image_gallery_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/lessons/galleries/image/new_block?page=' + (page + 1));
    }
  });
}

function initializeAudioGalleryInLessonEditor() {
  $('#lesson_editor_audio_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#lesson_editor_audio_gallery_container .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#lesson_editor_audio_gallery_container').data('page');
    var tot_pages = $('#lesson_editor_audio_gallery_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/lessons/galleries/audio/new_block?page=' + (page + 1));
    }
  });
}

function initializeVideoGalleryInLessonEditor() {
  $('#lesson_editor_video_gallery_container #video_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#lesson_editor_video_gallery_container .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#lesson_editor_video_gallery_container').data('page');
    var tot_pages = $('#lesson_editor_video_gallery_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/lessons/galleries/video/new_block?page=' + (page + 1));
    }
  });
}

function initializeMixedGalleryInVideoEditor() {
  $('#video_editor_mixed_gallery_container #video_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#video_editor_mixed_gallery_container #video_gallery_content .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#video_editor_mixed_gallery_container').data('video-page');
    var tot_pages = $('#video_editor_mixed_gallery_container').data('video-tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/videos/galleries/video/new_block?page=' + (page + 1));
    }
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
