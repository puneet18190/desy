/**
* Media element galleries, initialization.
* 
* @module Galleries
*/

/**
* Initialize image gallery in lesson editor.
* Init jScrollPane and get images block.
* 
* @method initializeImageGalleryInLessonEditor
* @for initializeImageGalleryInLessonEditor
*/
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

/**
* Initialize audio gallery in lesson editor.
* Init jScrollPane and get audios block.
* 
* @method initializeAudioGalleryInLessonEditor
* @for initializeAudioGalleryInLessonEditor
*/
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

/**
* Initialize video gallery in lesson editor.
* Init jScrollPane and get videos block.
* 
* @method initializeVideoGalleryInLessonEditor
* @for initializeVideoGalleryInLessonEditor
*/
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

/**
* Initialize all media mixed gallery in video editor.
* Init jScrollPane and get mixed media block.
* 
* @method initializeImageGalleryInLessonEditor
* @for initializeImageGalleryInLessonEditor
*/
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

/**
* Initialize audio gallery in video editor.
* Init jScrollPane and audios block.
* 
* @method initializeImageGalleryInLessonEditor
* @for initializeImageGalleryInLessonEditor
*/
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

/**
* Initialize audio gallery in audio editor.
* Init jScrollPane and get audios block.
* 
* @method initializeAudioGalleryInAudioEditor
* @for initializeAudioGalleryInAudioEditor
*/
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

/**
* Initialize image gallery in image editor.
* Init jScrollPane and get images block.
* 
* @method initializeImageGalleryInImageEditor
* @for initializeImageGalleryInImageEditor
*/
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

/**
* Scale image size form image gallery popup
* 
* @method resizedWidthForImageGallery
* @for resizedWidthForImageGallery
* @param width {Number} image original width
* @param height {Number} image original height
*/
function resizedWidthForImageGallery(width, height) {
  if(height > width) {
    return (420 * width / height) + 20;
  } else {
    return 440;
  }
}
