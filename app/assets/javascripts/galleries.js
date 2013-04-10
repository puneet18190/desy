/**
The galleries are containers of media elements, used at any time the user needs to pick an element of a specific type.
<br/><br/>
There are three kinds of gallery, each of them has specific features depending on where it's used. Each instance of a gallery is provided of its specific url route, that performs the speficic javascript actions it requires. For instance, in the image gallery contained inside the {{#crossLinkModule "video-editor"}}{{/crossLinkModule}}, to each image popup (see also {{#crossLink "DialogsGalleries/showImageInGalleryPopUp:method"}}{{/crossLink}}) is attached additional HTML code that contains the input for inserting the duration of the image component. Each gallery is also provided of infinite scroll pagination, which is initialized in the methods of {{/#crossLink "GalleriesInitializers"}}{{/crossLink}}. The complete list of galleries is:
<br/>
<ul>
  <li>
    <b>audio gallery</b>, whose occurrences are
    <ul>
      <li>in Audio Editor, initialized by {{#crossLink "GalleriesInitializers/initializeAudioGalleryInAudioEditor:method"}}{{/crossLink}}</li>
      <li>in Lesson Editor, initialized by {{#crossLink "GalleriesInitializers/initializeAudioGalleryInLessonEditor:method"}}{{/crossLink}}</li>
      <li>in Video Editor, initialized by {{#crossLink "GalleriesInitializers/initializeAudioGalleryInVideoEditor:method"}}{{/crossLink}}</li>
    </ul>
  </li>
  <li>
    <b>image gallery</b>, whose occurrences are
    <ul>
      <li>in Image Editor, initialized by {{#crossLink "GalleriesInitializers/initializeImageGalleryInImageEditor:method"}}{{/crossLink}}</li>
      <li>in Lesson Editor, initialized by {{#crossLink "GalleriesInitializers/initializeImageGalleryInLessonEditor:method"}}{{/crossLink}}</li>
      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink "GalleriesInitializers/initializeMixedGalleryInVideoEditor:method"}}{{/crossLink}}</li>
    </ul>
  </li>
  <li>
    <b>video gallery</b>, whose occurrences are
    <ul>
      <li>in Lesson Editor, initialized by {{#crossLink "GalleriesInitializers/initializeVideoGalleryInLessonEditor:method"}}{{/crossLink}}</li>
      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink "GalleriesInitializers/initializeMixedGalleryInVideoEditor:method"}}{{/crossLink}}</li>
    </ul>
  </li>
</ul>
@module galleries
**/





/**
Scale image size form image gallery popup
@method resizedWidthForImageGallery
@for GalleriesAccessories
@param width {Number} image original width
@param height {Number} image original height
**/
function resizedWidthForImageGallery(width, height) {
  if(height > width) {
    return (420 * width / height) + 20;
  } else {
    return 440;
  }
}





/**
bla bla bla
@method galleriesDocumentReady
@for GalleriesDocumentReady
**/
function galleriesDocumentReady() {
  galleriesDocumentReadyOpen();
  galleriesDocumentReadyClose();
}

/**
bla bla bla
@method galleriesDocumentReadyClose
@for GalleriesDocumentReady
**/
function galleriesDocumentReadyClose() {
  $('body').on('click', '._close_mixed_gallery_in_video_editor', function() {
    closeGalleryInVideoEditor('mixed');
  });
  $('body').on('click', '._close_audio_gallery_in_video_editor', function() {
    closeGalleryInVideoEditor('audio');
    var expanded_audio = $('._audio_expanded_in_gallery');
    if(expanded_audio.length > 0) {
      expanded_audio.removeClass('_audio_expanded_in_gallery');
      var audio_id = expanded_audio.attr('id');
      stopMedia('#' + audio_id + ' audio');
      $('#' + audio_id + ' ._expanded').hide();
    }
  });
  $('body').on('click', '._close_audio_gallery_in_audio_editor', function() {
    closeGalleryInAudioEditor();
    var expanded_audio = $('._audio_expanded_in_gallery');
    if(expanded_audio.length > 0) {
      expanded_audio.removeClass('_audio_expanded_in_gallery');
      var audio_id = expanded_audio.attr('id');
      stopMedia('#' + audio_id + ' audio');
      $('#' + audio_id + ' ._expanded').hide();
    }
  });
  $('body').on('click', '._close_on_click_out', function() {
    $('.ui-dialog-content:visible').each(function() {
      closePopUp($(this).attr('id'));
    });
  });
}

/**
bla bla bla
@method galleriesDocumentReadyOpen
@for GalleriesDocumentReady
**/
function galleriesDocumentReadyOpen() {
  $('body').on('click','._image_gallery_thumb', function(e) {
    e.preventDefault();
    showImageInGalleryPopUp($(this).data('image-id'));
  });
  $('body').on('click','._video_gallery_thumb', function(e) {
    e.preventDefault();
    if(!$(this).hasClass('_disabled')) {
      showVideoInGalleryPopUp($(this).data('video-id'));
    }
  });
  $('body').on('click', '._audio_gallery_thumb._enabled ._compact', function(e) {
    if(!$(e.target).hasClass('_select_audio_from_gallery')) {
      var parent_id = $(this).parent().attr('id');
      var obj = $('#' + parent_id + ' ._expanded');
      if(obj.is(':visible')) {
        $('#' + parent_id).removeClass('_audio_expanded_in_gallery');
        stopMedia('#' + parent_id + ' audio');
        obj.hide('blind', {}, 500);
      } else {
        var currently_open = $('._audio_expanded_in_gallery');
        if(currently_open.length != 0) {
          currently_open.removeClass('_audio_expanded_in_gallery');
          stopMedia('#' + currently_open.attr('id') + ' audio');
          $('#' + currently_open.attr('id') + ' ._expanded').hide('blind', {}, 500);
        }
        $('#' + parent_id).addClass('_audio_expanded_in_gallery');
        var instance_id = $('#' + parent_id + ' ._empty_audio_player, #' + parent_id + ' ._instance_of_player').attr('id');
        if(!$('#' + instance_id).data('initialized')) {
          var button = $(this).find('._select_audio_from_gallery');
          var duration = button.data('duration');
          $('#' + instance_id + ' source[type="audio/mp4"]').attr('src', button.data('m4a'));
          $('#' + instance_id + ' source[type="audio/ogg"]').attr('src', button.data('ogg'));
          $('#' + instance_id + ' audio').load();
          $('#' + instance_id + ' ._media_player_total_time').html(secondsToDateString(duration));
          $('#' + instance_id).data('duration', duration);
          $('#' + instance_id).removeClass('_empty_audio_player').addClass('_instance_of_player');
          initializeMedia(instance_id, 'audio');
        }
        obj.show('blind', {}, 500, function() {
          setTimeout(function() {
            var actual = $('#audio_gallery_content > div').data('jsp').getContentPositionY();
            $('#audio_gallery_content > div').data('jsp').scrollToY(actual + 55, true);
          }, 300);
        });
      }
    }
  });
}





/**
Initialize audio gallery in audio editor. Init jScrollPane and get audios block.
@method initializeAudioGalleryInAudioEditor
@for GalleriesInitializers
**/
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
Initialize audio gallery in lesson editor. Init jScrollPane and get audios block.
@method initializeAudioGalleryInLessonEditor
@for GalleriesInitializers
**/
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
Initialize audio gallery in video editor. Init jScrollPane and audios block.
@method initializeAudioGalleryInVideoEditor
@for GalleriesInitializers
**/
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
Initialize image gallery in image editor. Init jScrollPane and get images block.
@method initializeImageGalleryInImageEditor
@for GalleriesInitializers
**/
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
Initialize image gallery in lesson editor. Init jScrollPane and get images block.
@method initializeImageGalleryInLessonEditor
@for GalleriesInitializers
**/
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
Initialize all media mixed gallery in video editor. Init jScrollPane and get mixed media block.
@method initializeMixedGalleryInVideoEditor
@for GalleriesInitializers
**/
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
Initialize video gallery in lesson editor. Init jScrollPane and get videos block.
@method initializeVideoGalleryInLessonEditor
@for GalleriesInitializers
**/
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
