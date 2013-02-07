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
  $('#video_editor_mixed_gallery_container #image_gallery_content .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#video_editor_mixed_gallery_container').data('image-page');
    var tot_pages = $('#video_editor_mixed_gallery_container').data('image-tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/videos/galleries/image/new_block?page=' + (page + 1));
    }
  });
}

function initializeAudioGalleryInVideoEditor() {
  $('#video_editor_audio_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#video_editor_audio_gallery_container .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#video_editor_audio_gallery_container').data('page');
    var tot_pages = $('#video_editor_audio_gallery_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/videos/galleries/audio/new_block?page=' + (page + 1));
    }
  });
}

function initializeAudioGalleryInAudioEditor() {
  $('#audio_editor_gallery_container #audio_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#audio_editor_gallery_container .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#audio_editor_gallery_container').data('page');
    var tot_pages = $('#audio_editor_gallery_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/audios/galleries/audio/new_block?page=' + (page + 1));
    }
  });
}

function initializeImageGalleryInImageEditor() {
  $('#image_gallery_for_image_editor #image_gallery_content > div').jScrollPane({
    autoReinitialise: true
  });
  $('#image_gallery_for_image_editor .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#image_gallery_for_image_editor').data('page');
    var tot_pages = $('#image_gallery_for_image_editor').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/images/galleries/image/new_block?page=' + (page + 1));
    }
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
