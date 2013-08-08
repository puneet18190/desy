/**
The Lesson Editor is used to add and edit slides to a private lesson.
<br/><br/>
When opening the Editor on a lesson, all its slides are appended to a queue, of which it's visible only the portion that surrounds the <b>current slide</b> (the width of such a portion depends on the screen resolution, see {{#crossLink "LessonEditorSlidesNavigation/initLessonEditorPositions:method"}}{{/crossLink}}, {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyResize:method"}}{{/crossLink}} and {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyGeneral:method"}}{{/crossLink}}). The current slide is illuminated and editable, whereas the adhiacent slides are covered by a layer with opacity that prevents the user from editing them: if the user clicks on this layer, the application takes the slide below it as new current slide and moves it to the center of the screen (see {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method"}}{{/crossLink}} and the methods in {{#crossLink "LessonEditorSlidesNavigation"}}{{/crossLink}}): only after this operation, the user can edit that particular slide. To avoid overloading when there are many slides containing media, the slides are instanced all together but their content is loaded only when the user moves to them (see the methods in {{#crossLink "LessonEditorSlideLoading"}}{{/crossLink}}).
<br/><br/>
On the right side of each slide the user finds a list of <b>buttons</b> (initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method"}}{{/crossLink}}): each button corresponds either to an action that can be performed on the slide, either to an action that can be performed to the whole lesson (for instance, save and exit, or edit title description and tags).
<br/><br/>
The <b>tool to navigate the slides</b> is located on the top of the editor: each small square represents a slide (with its position), and passing with the mouse over it the Editor shows a miniature of the corresponding slide (these functionalities are initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method"}}{{/crossLink}}). Clicking on a slide miniature, the application moves to that slide using the function {{#crossLink "LessonEditorSlidesNavigation/slideTo:method"}}{{/crossLink}}. The slides can be sorted dragging with the mouse (using the JQueryUi plugin, initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyJqueryAnimations:method"}}{{/crossLink}} and {{#crossLink "LessonEditorJqueryAnimations/initializeSortableNavs:method"}}{{/crossLink}}).
<br/><br/>
Inside the Editor, there are two operations that require hiding and replacement of the queue of slides: <b>adding a media element to a slide</b> and <b>choosing a new slide</b>. In both these operations, an HTML div is extracted from the main template (where it was hidden), and put in the place of the current slide, hiding the rest of the slides queue, buttons, and slides navigation (operations performed by {{#crossLink "LessonEditorCurrentSlide/hideEverythingOutCurrentSlide:method"}}{{/crossLink}}). For the galleries, the extracted div must be filled by an action called via Ajax (see the module {{#crossLinkModule "galleries"}}{{/crossLinkModule}}), whereas the div with the list of available slides is already loaded with the Editor (see {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyNewSlideChoice:method"}}{{/crossLink}}).
<br/><br/>
To add a media element to a slide, the user picks it from its specific gallery: when he clicks on the button 'plus', the system calls the corresponding subfunction in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyAddMediaElement:method"}}{{/crossLink}}. To avoid troubles due to the replacement of JQuery plugins, video and audio tags, etc, this method always replaces the sources of <b>audio</b> and <b>video</b> tags and calls <i>load()</i>.
<br/><br/>
If the element added is of type <b>image</b>, the user may drag it inside the slide, using {{#crossLink "LessonEditorJqueryAnimations/makeDraggable:method"}}{{/crossLink}}. A set of methods (in the class {{#crossLink "LessonEditorImageResizing"}}{{/crossLink}}) is available to resize the image and the alignment chosen by the user; more specificly, the method {{#crossLink "LessonEditorImageResizing/isHorizontalMask:method"}}{{/crossLink}} is used to understand, depending on the type of slide and on the proportions of the image, if the image is <b>vertical</b> (and then the user can drag it vertically) or <b>horizontal</b> (the user can drag it horizontally).
<br/><br/>
Each slide contains a form linked to the action that updates it, there is no global saving for the whole lesson. The slide is automaticly saved (using the method {{#crossLink "LessonEditorForms/saveCurrentSlide:method"}}{{/crossLink}}) <i>before moving to another slide</i>, <i>before showing the options to add a new slide</i>, and <i>before changing position of a slide</i>. The same function is called by the user when he clicks on the button 'save' on the right of each slide; the buttons <b>save and exit</b> and <b>edit general info</b> are also linked to slide saving, but in this case it's performed with a callback (see again the buttons initialization in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method"}}{{/crossLink}}).
<br/><br/>
The text slides are provided of <b>TinyMCE</b> text editor, initialized in the methods of {{#crossLink "LessonEditorTinyMCE"}}{{/crossLink}}.
@module lesson-editor
**/





/**
Hides buttons, adhiacent slides and slide navigation (used before {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyNewSlideChoice:method"}}{{/crossLink}} and {{#crossLink "LessonEditorGalleries/showGalleryInLessonEditor:method"}}{{/crossLink}}).
@method hideEverythingOutCurrentSlide
@for LessonEditorCurrentSlide
**/
function hideEverythingOutCurrentSlide() {
  var current_slide = $('li._lesson_editor_current_slide');
  $('#heading').children().hide();
  $('._add_new_slide_options_in_last_position').hide();
  $('._not_current_slide').removeClass('_not_current_slide').addClass('_not_current_slide_disabled');
  current_slide.find('.buttons a:not(._hide_add_slide)').css('visibility', 'hidden');
}

/**
Hides the template for selection of new slides.
@method hideNewSlideChoice
@for LessonEditorCurrentSlide
**/
function hideNewSlideChoice() {
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.find('div.slide-content').addClass(current_slide.data('kind'));
  current_slide.find('.box.new_slide').remove();
  if(!current_slide.find('.slide-content').hasClass('cover')) {
    current_slide.find('.slide-content').css('padding', '20px');
  }
  current_slide.find('._hide_add_new_slide_options').removeAttr('class').addClass('addButtonOrange _add_new_slide_options');
  var new_title = current_slide.find('._add_new_slide_options').data('title');
  current_slide.find('._add_new_slide_options').removeAttr('title').attr('title', new_title);
  showEverythingOutCurrentSlide();
}

/**
Opposite of {{#crossLink "LessonEditorCurrentSlide/hideEverythingOutCurrentSlide:method"}}{{/crossLink}}.
@method showEverythingOutCurrentSlide
@for LessonEditorCurrentSlide
**/
function showEverythingOutCurrentSlide() {
  var current_slide = $('li._lesson_editor_current_slide');
  $('#heading').children().show();
  $('._add_new_slide_options_in_last_position').show();
  $('._not_current_slide_disabled').addClass('_not_current_slide').removeClass('_not_current_slide_disabled');
  current_slide.find('.buttons a').css('visibility', 'visible');
}

/**
Shows the template for selection of new slides.
@method showNewSlideOptions
@for LessonEditorCurrentSlide
**/
function showNewSlideOptions() {
  stopMediaInCurrentSlide();
  var current_slide_content = $('li._lesson_editor_current_slide .slide-content');
  if(!current_slide_content.hasClass('cover')) {
    current_slide_content.css('padding', '0');
  }
  var html_to_be_replaced = $('#new_slide_option_list').html();
  current_slide_content.prepend(html_to_be_replaced);
  current_slide_content.siblings('.buttons').find('._add_new_slide_options').removeAttr('class').addClass('minusButtonOrange _hide_add_slide _hide_add_new_slide_options');
  var new_title = current_slide_content.siblings('.buttons').find('._hide_add_new_slide_options').data('other-title');
  current_slide_content.siblings('.buttons').find('._hide_add_new_slide_options').removeAttr('title').attr('title', new_title);
  hideEverythingOutCurrentSlide();
}

/**
Stop video and audio playing into the current slide (used before changing slide with {{#crossLink "LessonEditorSlidesNavigation/slideTo:method"}}{{/crossLink}}).
@method stopMediaInCurrentSlide
@for LessonEditorCurrentSlide
**/
function stopMediaInCurrentSlide() {
  var current_slide_id = $('li._lesson_editor_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}

/**
Switches the titles of disabled and enabled buttons when the user reaches the maximum number of allowed slides.
@method switchDisabledMaximumSlideNumberLessonEditor
@for LessonEditorCurrentSlide
**/
function switchDisabledMaximumSlideNumberLessonEditor() {
  var title_disabled = $('._add_new_slide_options').attr('title');
  var title_disabled_last_position = $('._add_new_slide_options_in_last_position').attr('title');
  $('._add_new_slide_options').attr('title', $('._add_new_slide_options').data('disabled-title'));
  $('._add_new_slide_options_in_last_position').attr('title', $('._add_new_slide_options_in_last_position').data('disabled-title'));
  $('._add_new_slide_options').data('disabled-title', title_disabled);
  $('._add_new_slide_options_in_last_position').data('disabled-title', title_disabled_last_position);
}





/**
General initialization of Lesson Editor.
@method lessonEditorDocumentReady
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReady() {
  lessonEditorDocumentReadyGeneral();
  lessonEditorDocumentReadyJqueryAnimations();
  lessonEditorDocumentReadyResize();
  lessonEditorDocumentReadySlidesNavigator();
  lessonEditorDocumentReadySlideButtons();
  lessonEditorDocumentReadyNewSlideChoice();
  lessonEditorDocumentReadyGalleries();
  lessonEditorDocumentReadyAddMediaElement();
  lessonEditorDocumentReadyReplaceMediaElement();
  lessonEditorDocumentReadyTextFields();
}

/**
Initializer of the three functionalities to add an element (image, audio, video).
@method lessonEditorDocumentReadyAddMediaElement
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyAddMediaElement() {
  $body.on('click', '._add_image_to_slide', function(e) {
    e.preventDefault();
    var image_id = $(this).data('image-id');
    closePopUp('dialog-image-gallery-' + image_id);
    removeGalleryInLessonEditor('image');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' .image-id').val(image_id);
    $('#' + place_id + ' .align').val('0');
    var image_url = $(this).data('url');
    var image_width = $(this).data('width');
    var image_height = $(this).data('height');
    var full_place = $('#' + place_id + ' .mask');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' .empty-mask').hide();
    }
    var old_mask = 'horizontal';
    var new_mask = 'vertical';
    var old_orientation = 'width';
    var orientation = 'height';
    var orientation_val = resizeHeight(image_width, image_height, current_slide.data('kind'));
    var to_make_draggable = 'y';
    if(isHorizontalMask(image_width, image_height, current_slide.data('kind'))) {
      old_mask = 'vertical';
      new_mask = 'horizontal';
      old_orientation = 'height';
      orientation = 'width';
      orientation_val = resizeWidth(image_width, image_height, current_slide.data('kind'));
      to_make_draggable = 'x';
    }
    full_place.addClass(new_mask).removeClass(old_mask);
    var img_tag = $('#' + place_id + ' .mask img');
    img_tag.attr('src', image_url);
    img_tag.parent().css('left', 0);
    img_tag.parent().css('top', 0);
    img_tag.removeAttr(old_orientation);
    img_tag.attr(orientation, orientation_val);
    makeDraggable(place_id);
  });
  $body.on('click', '._add_video_to_slide', function(e) {
    e.preventDefault();
    var video_id = $(this).data('video-id');
    closePopUp('dialog-video-gallery-' + video_id);
    removeGalleryInLessonEditor('video');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' .video-id').val(video_id);
    $('#' + place_id + ' .mask .add').hide();
    var video_mp4 = $(this).data('mp4');
    var video_webm = $(this).data('webm');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' .mask');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' .empty-mask').hide();
    }
    $('#' + place_id + ' .mask source[type="video/mp4"]').attr('src', video_mp4);
    $('#' + place_id + ' .mask source[type="video/webm"]').attr('src', video_webm);
    $('#' + place_id + ' video').load();
    $('#' + place_id + ' ._media_player_total_time').html(secondsToDateString(duration));
    var video_player = $('#' + place_id + ' ._empty_video_player, #' + place_id + ' ._instance_of_player');
    if(video_player.data('initialized')) {
      video_player.data('duration', duration);
      $('#' + video_player.attr('id') + ' ._media_player_slider').slider('option', 'max', duration);
    } else {
      video_player.removeClass('_empty_video_player').addClass('_instance_of_player');
      video_player.data('duration', duration);
      initializeMedia(video_player.attr('id'), 'video');
    }
  });
  $body.on('click', '._add_audio_to_slide', function(e) {
    e.preventDefault();
    var audio_id = $(this).data('audio-id');
    var new_audio_title = $('#gallery_audio_' + audio_id+' .titleTrack').text();
    $('#gallery_audio_' + audio_id).removeClass('_audio_expanded_in_gallery');
    stopMedia('#gallery_audio_' + audio_id + ' audio');
    $('#gallery_audio_' + audio_id + ' ._expanded').hide();
    removeGalleryInLessonEditor('audio');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' .audio-id').val(audio_id);
    var audio_m4a = $(this).data('m4a');
    var audio_ogg = $(this).data('ogg');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' .mask');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' .empty-mask').hide();
    }
    $('#' + place_id + ' .mask source[type="audio/mp4"]').attr('src', audio_m4a);
    $('#' + place_id + ' .mask source[type="audio/ogg"]').attr('src', audio_ogg);
    $('#' + place_id + ' audio').load();
    $('#' + place_id + ' ._media_player_total_time').html(secondsToDateString(duration));
    $('#' + place_id + ' .mask .title').text(new_audio_title);
    var audio_player = $('#' + place_id + ' ._empty_audio_player, #' + place_id + ' ._instance_of_player');
    if(audio_player.data('initialized')) {
      audio_player.data('duration', duration);
      $('#' + audio_player.attr('id') + ' ._media_player_slider').slider('option', 'max', duration);
    } else {
      audio_player.removeClass('_empty_audio_player').addClass('_instance_of_player');
      audio_player.data('duration', duration);
      initializeMedia(audio_player.attr('id'), 'audio');
    }
  });
}

/**
Initializer for galleries.
@method lessonEditorDocumentReadyGalleries
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyGalleries() {
  $body.on('click', '.slide-content .image.editable .add', function() {
    showGalleryInLessonEditor(this, 'image');
  });
  $body.on('click', '.slide-content .audio.editable .add', function() {
    stopMediaInCurrentSlide();
    showGalleryInLessonEditor(this, 'audio');
  });
  $body.on('click', '.slide-content .video.editable .add', function() {
    stopMediaInCurrentSlide();
    showGalleryInLessonEditor(this, 'video');
  });
  $body.on('click', '._close_image_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('image');
  });
  $body.on('click', '._close_video_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('video');
  });
  $body.on('click', '._close_audio_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    var current_playing_audio = $('._audio_expanded_in_gallery');
    if(current_playing_audio.length != 0) {
      current_playing_audio.removeClass('_audio_expanded_in_gallery');
      stopMedia('#' + current_playing_audio.attr('id') + ' audio');
      $('#' + current_playing_audio.attr('id') + ' ._expanded').hide();
    }
    removeGalleryInLessonEditor('audio');
  });
  $body.on('click', '#lesson_editor_document_gallery_container #document_gallery .footerButtons .cancel', function() {
    removeGalleryInLessonEditor('document');
    loadDocumentGalleryForSlideInLessonEditor($('#lesson_editor_document_gallery_container').data('slide-id'));
  });
  $body.on('click', '#lesson_editor_document_gallery_container #document_gallery .footerButtons .attach', function() {
    removeGalleryInLessonEditor('document');
    unLoadDocumentGalleryContent($('#lesson_editor_document_gallery_container').data('slide-id'));
    saveCurrentSlide('', false);
  });
  $body.on('click', '#lesson_editor_document_gallery_container .documentInGalleryExternal .documentInGallery:not(".disabled") .add_remove', function() {
    var document_id = $(this).data('document-id');
    var target = $('.attachedExternal .document_attached.not_full').first();
    var new_content = $('<div>' + $('#gallery_document_' + document_id).html() + '</div>');
    new_content.find('.to_be_removed').each(function() {
      $(this).replaceWith($(this).find('u').html());
    });
    target.html(new_content);
    target.removeClass('not_full');
    $('#inputs_for_documents').append('<input type="text" name="' + target.attr('id').replace('_attached', '') + '" value="' + document_id + '" />');
    updateEffectsInsideDocumentGallery();
  });
  $body.on('click', '#lesson_editor_document_gallery_container .document_attached .documentInGallery .add_remove', function() {
    var target = $(this).parents('.document_attached');
    target.html($('#' + target.attr('id') + '_empty').html());
    target.addClass('not_full');
    $('#inputs_for_documents input[name="' + target.attr('id').replace('_attached', '') + '"]').remove();
    updateEffectsInsideDocumentGallery();
  });
  $body.on('keydown', '#lesson_editor_document_gallery_container #document_gallery_filter', function(e) {
    if(e.which == 13) {
      e.preventDefault();
    } else if(e.which != 39 && e.which != 37) {
      var loader = $('#lesson_editor_document_gallery_container .documentsFooter ._loader');
      var letters = $(this).data('letters');
      letters += 1;
      $(this).data('letters', letters);
      loader.show();
      setTimeout(function() {
        var input = $('#lesson_editor_document_gallery_container #document_gallery_filter');
        if(input.data('letters') == letters) {
          loader.hide();
          $.get('/lessons/galleries/document/filter?word=' + input.val());
        }
      }, 1500);
    }
  });
}

/**
General initialization of position (used together with {{#crossLink "LessonEditorSlidesNavigation/initLessonEditorPositions:method"}}{{/crossLink}}).
@method lessonEditorDocumentReadyGeneral
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyGeneral() {
  $('html.lesson-editor-layout ul#slides').css('margin-top', ((($(window).height() - 590) / 2) - 40) + 'px');
  $('html.lesson-editor-layout ul#slides.new').css('margin-top', ((($(window).height() - 590) / 2)) + 'px');
}

/**
Initializer for JQueryUi animations defined in the class {{#crossLink "LessonEditorJqueryAnimations"}}{{/crossLink}}.
@method lessonEditorDocumentReadyJqueryAnimations
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyJqueryAnimations() {
  $('.slide-content .image.editable').each(function() {
    makeDraggable($(this).attr('id'));
  });
  initializeSortableNavs();
  $('#nav_list_menu').jScrollPane({
    autoReinitialise: false
  });
  $('#lesson_subject').selectbox();
  initLessonEditorPositions();
}

/**
Initializer for the template that contains the list of possible slides to be added.
@method lessonEditorDocumentReadyNewSlideChoice
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyNewSlideChoice() {
  $body.on('click', '._add_new_slide', function() {
    hideNewSlideChoice();
    var slide = $('li._lesson_editor_current_slide');
    slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
    var kind = $(this).data('kind');
    var lesson_id = $('#info_container').data('lesson-id');
    var slide_id = slide.data('slide-id');
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/slides/' + slide_id + '/kind/' + kind + '/create/'
    });
  });
}

/**
Initializer for the mouseover and mouseout to replace a media element already added.
@method lessonEditorDocumentReadyReplaceMediaElement
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyReplaceMediaElement() {
  $body.on('mouseover', '.slide-content .image.editable .mask', function() {
    if($(this).find('.alignable').data('rolloverable')) {
      $(this).find('.add').show();
    }
  });
  $body.on('mouseout', '.slide-content .image.editable .mask', function() {
    if($(this).find('.alignable').data('rolloverable')) {
      $(this).find('.add').hide();
    }
  });
  $body.on('mouseover', '.slide-content .video.editable .mask video', function(e) {
    var position = $(this).offset();
    var top = position.top + 59;
    var right = position.left + 291;
    var bottom = position.top + 222;
    var left = position.left + 129;
    if($(this).width() > 420) {
      top = position.top + 179;
      right = position.left + 526;
      bottom = position.top + 371;
      left = position.left + 334;
    }
    if(left <= e.clientX && e.clientX <= right && top <= e.clientY && e.clientY <= bottom) {
      return;
    }
    var granpa = $(this).parents('.mask');
    if(granpa.find('.alignable').data('rolloverable')) {
      granpa.find('.add').show();
    }
  });
  $body.on('mouseout', '.slide-content .video.editable .mask video', function(e) {
    var position = $(this).offset();
    var top = position.top + 59;
    var right = position.left + 291;
    var bottom = position.top + 222;
    var left = position.left + 129;
    if($(this).width() > 420) {
      top = position.top + 179;
      right = position.left + 526;
      bottom = position.top + 371;
      left = position.left + 334;
    }
    if(left <= e.clientX && e.clientX <= right && top <= e.clientY && e.clientY <= bottom) {
      return;
    }
    var granpa = $(this).parents('.mask');
    if(granpa.find('.alignable').data('rolloverable')) {
      granpa.find('.add').hide();
    }
  });
}

/**
Initializer for window resize.
@method lessonEditorDocumentReadyResize
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyResize() {
  $(window).resize(function() {
    $('html.lesson-editor-layout ul#slides').css('margin-top', ((($(window).height() - 590) / 2) - 40) + 'px');
    $('html.lesson-editor-layout ul#slides.new').css('margin-top', ((($(window).height() - 590) / 2)) + 'px');
    if(WW > 1000) {
      $('ul#slides li:first').css('margin-left', (($(window).width() - 900) / 2) + 'px');
      $('ul#slides.new li:first').css('margin-left', (($(window).width() - 900) / 2) + 'px');
    }
    $('#footer').css('top', ($(window).height() - 40) + 'px').css('width', ($(window).width() - 24) + 'px');
    var open_gallery = $('.lesson_editor_gallery_container:visible');
    if(open_gallery.length > 0) {
      centerThis(open_gallery);
    }
  });
}

/**
Initializer for the buttons on the right side of each slide.
@method lessonEditorDocumentReadySlideButtons
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadySlideButtons() {
  $body.on('click', '._hide_add_new_slide_options', function() {
    hideNewSlideChoice();
  });
  $body.on('click', '._save_slide', function(e) {
    saveCurrentSlide('', false);
  });
  $body.on('click', '._save_slide_and_exit', function() {
    saveCurrentSlide('_and_exit', true);
  });
  $body.on('click', '._save_slide_and_edit', function() {
    saveCurrentSlide('_and_edit', true);
  });
  $body.on('click', '._add_new_slide_options', function() {
    if(!$(this).hasClass('disabled')) {
      saveCurrentSlide('', false);
      showNewSlideOptions();
    }
  });
  $body.on('click', '._delete_slide', function() {
    stopMediaInCurrentSlide();
    var slide = $('li._lesson_editor_current_slide');
    slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
    $.ajax({
      type: 'post',
      url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + slide.data('slide-id') + '/delete'
    });
  });
  $body.on('click', '._attach_document', function() {
    showDocumentGalleryInLessonEditor();
  });
}

/**
Initializer for the scroll and all the actions of the slide navigator (see the class {{#crossLink "LessonEditorSlidesNavigation"}}{{/crossLink}}).
@method lessonEditorDocumentReadySlidesNavigator
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadySlidesNavigator() {
  $body.on('mouseover', '#slide-numbers li.navNumbers:not(._add_new_slide_options_in_last_position)', function(e) {
    var tip = $(this);
    var this_tooltip = tip.children('.slide-tooltip');
    if(e.pageX < ($(window).width() / 2)) {
      this_tooltip.show();
    } else {
      this_tooltip.addClass('slide-tooltip-to-left');
      tip.children('.slide-tooltip-to-left').show();
    }
  });
  $body.on('mouseout', '#slide-numbers li.navNumbers:not(._add_new_slide_options_in_last_position)', function(e) {
    var this_tooltip = $(this).children('.slide-tooltip');
    this_tooltip.removeClass('slide-tooltip-to-left');
    this_tooltip.hide();
  });
  $body.on('click', '._slide_nav:not(._lesson_editor_current_slide_nav)', function(e) {
    e.preventDefault();
    stopMediaInCurrentSlide();
    saveCurrentSlide('', false);
    slideTo($(this).data('slide-id'));
  });
  $body.on('click', '._not_current_slide', function(e) {
    e.preventDefault();
    saveCurrentSlide('', false);
    stopMediaInCurrentSlide();
    slideTo($(this).parent().data('slide-id'));
    scrollPaneUpdate(this);
  });
  $body.on('click', '._add_new_slide_options_in_last_position', function() {
    if(!$(this).hasClass('disabled')) {
      saveCurrentSlide('', false);
      var last_slide_id = $("#slide-numbers li.navNumbers:last").find('a').data('slide-id');
      $('#nav_list_menu').data('jsp').scrollToPercentX(100, true);
      if($('#slide_in_lesson_editor_' + last_slide_id).hasClass('_lesson_editor_current_slide')) {
        showNewSlideOptions();
      } else {
        slideTo('' + last_slide_id, showNewSlideOptions);
      }
    }
  });
}

/**
Initializer for the placeholders of text inputs throughout the Lesson Editor.
@method lessonEditorDocumentReadyTextFields
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyTextFields() {
  $body.on('focus', '._lesson_editor_placeholder', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
  $body.on('focus', '#slides._new #title', function() {
    if($('#slides._new #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#slides._new #description', function() {
    if($('#slides._new #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #description_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#slides._update #title', function() {
    if($('#slides._update #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#slides._update #description', function() {
    if($('#slides._update #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #description_placeholder').attr('value', '0');
    }
  });
}





/**
Save current slide. It sends tinyMCE editor content to form data to be serialized, it handles form placeholders.
@method saveCurrentSlide
@for LessonEditorForms
@param action_suffix {String} action suffix to be appended after 'save' (it can be 'save_and_edit' or 'save_and_exit', or just 'save', see also {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:merthod"}}{{/crossLink}})
@param with_loader {Boolean} if true shows the loader while calling ajax
**/
function saveCurrentSlide(action_suffix, with_loader) {
  tinyMCE.triggerSave();
  var temporary = [];
  var temp_counter = 0;
  var current_slide = $('._lesson_editor_current_slide');
  var current_slide_form = current_slide.find('form');
  var math_inputs_class = '_math_image';
  var editor = tinyMCE.get( 'ta-' + current_slide.data('slideId') );
  if (editor) {
    current_slide_form.find('.' + math_inputs_class).remove();
    $(editor.getBody()).find('img.Wirisformula').each(function(i, el) {
      var formula = UrlParser.parse( $(el).attr('src') ).searchObj.formula;
      var input = $( '<input type="hidden" name="math_images[]" />', { 'class': math_inputs_class } ).val( formula );
      current_slide_form.append(input);
    });
  }
  current_slide.find('._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      temporary[temp_counter] = $(this).val();
      temp_counter++;
      $(this).val('');
    }
  });
  if(with_loader) {
    $.ajax({
       type: 'post',
      url: current_slide_form.attr('action') + action_suffix,
       timeout: 5000,
      data: current_slide_form.serialize()
     });
  } else {
    unbindLoader();
    $.ajax({
      type: 'post',
      url: current_slide_form.attr('action') + action_suffix,
      timeout: 5000,
      data: current_slide_form.serialize()
    }).always(bindLoader);
  }
  temp_counter = 0;
  current_slide.find('._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      $(this).val(temporary[temp_counter]);
      temp_counter++;
    }
  });
}





/**
Loads the documents from the slide to the gallery.
@method loadDocumentGalleryContent
@for LessonEditorGalleries
@param slide_id {Number} the id of the slide
**/
function loadDocumentGalleryContent(slide_id) {
  $('#inputs_for_documents').html($('#slide_in_lesson_editor_' + slide_id + ' .inputs_for_documents').html());
  for(var i = 1; i < 4; i++) {
    var doc = $('#document_' + i + '_attached_in_slide_' + slide_id);
    if(doc.length > 0) {
      $('#document_' + i + '_attached').html(doc.html()).removeClass('not_full');
    } else {
      $('#document_' + i + '_attached').html($('#document_' + i + '_attached_empty').html()).addClass('not_full');
    }
  }
}

/**
Loads the specific gallery for documents relative to a slide. The gallery is supposed to have already been loaded previously, by {{#crossLink "LessonEditorGalleries/showDocumentGalleryInLessonEditor:method"}}{{/crossLink}}
@method loadDocumentGalleryForSlideInLessonEditor
@for LessonEditorGalleries
@param slide_id {Number} the id of the slide
**/
function loadDocumentGalleryForSlideInLessonEditor(slide_id) {
  loadDocumentGalleryContent(slide_id);
  updateEffectsInsideDocumentGallery(slide_id);
  $('#lesson_editor_document_gallery_container').data('slide-id', slide_id);
}

/**
Hides media gallery for selected type.
@method removeGalleryInLessonEditor
@for LessonEditorGalleries
@param sti_type {String} gallery type
**/
function removeGalleryInLessonEditor(sti_type) {
  $('#lesson_editor_' + sti_type + '_gallery_container').hide();
  $('li._lesson_editor_current_slide .slide-content').children().show();
  showEverythingOutCurrentSlide();
}

/**
Resets the filter of documents in the gallery.
@method resetDocumentGalleryFilter
@for LessonEditorGalleries
@param callback {Function} to be called after ajax
@param otherwise {Function} to be called if there is no filter to reset
**/
function resetDocumentGalleryFilter(callback, otherwise) {
  var input = $('#lesson_editor_document_gallery_container #document_gallery_filter');
  if(input.val() != '') {
    input.val('');
    input.data('letters', 0);
    $.ajax({
      type: 'get',
      url: '/lessons/galleries/document/filter?word=',
      complete: function() {
        if(callback != undefined) {
          callback();
        }
      }
    });
  } else {
    if(callback != undefined) {
      callback();
    }
    if(otherwise != undefined) {
      otherwise();
    }
  }
}

/**
Shows document gallery.
@method showDocumentGalleryInLessonEditor
@for LessonEditorGalleries
**/
function showDocumentGalleryInLessonEditor() {
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
  hideEverythingOutCurrentSlide();
  var gallery_container = $('#lesson_editor_document_gallery_container');
  if(gallery_container.data('loaded')) {
    if(gallery_container.data('slide-id') != current_slide.data('slide-id')) {
      var slide_id = current_slide.data('slide-id');
      loadDocumentGalleryContent(slide_id);
      $('#lesson_editor_document_gallery_container').data('slide-id', slide_id);
      resetDocumentGalleryFilter(function() {
        gallery_container.show();
        $('li._lesson_editor_current_slide .slide-content').children().hide();
        current_slide.find('layer').remove();
      }, updateEffectsInsideDocumentGallery);
    } else {
      resetDocumentGalleryFilter(function() {
        gallery_container.show();
        $('li._lesson_editor_current_slide .slide-content').children().hide();
        current_slide.find('layer').remove();
      });
    }
  } else {
    $.ajax({
      type: 'get',
      url: '/lessons/galleries/document'
    });
  }
}

/**
Shows media gallery for selected type.
@method showGalleryInLessonEditor
@for LessonEditorGalleries
@param obj {String} HTML selector for the button that opens the gallery (used to extract the position of the current slide)
@param sty_type {String} gallery type
**/
function showGalleryInLessonEditor(obj, sti_type) {
  $('#info_container').data('current-media-element-position', $(obj).data('position'));
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
  hideEverythingOutCurrentSlide();
  var gallery_container = $('#lesson_editor_' + sti_type + '_gallery_container');
  if(gallery_container.data('loaded')) {
    gallery_container.show();
    $('li._lesson_editor_current_slide .slide-content').children().hide();
    current_slide.find('layer').remove();
  } else {
    $.ajax({
      type: 'get',
      url: '/lessons/galleries/' + sti_type
    });
  }
}

/**
Unloads the documents to the slide.
@method unLoadDocumentGalleryContent
@for LessonEditorGalleries
@param slide_id {Number} the id of the slide
**/
function unLoadDocumentGalleryContent(slide_id) {
  $('#slide_in_lesson_editor_' + slide_id + ' .inputs_for_documents').html($('#inputs_for_documents').html());
  $('#document_1_attached_in_slide_' + slide_id + ', #document_2_attached_in_slide_' + slide_id + ', #document_3_attached_in_slide_' + slide_id).remove();
  for(var i = 1; i < 4; i++) {
    var doc = $('#document_' + i + '_attached');
    if(!doc.hasClass('not_full')) {
      var new_content = '<div id="document_' + i + '_attached_in_slide_' + slide_id + '">' + doc.html() + '</div>';
      $('#slide_in_lesson_editor_' + slide_id + ' .hidden_html_for_documents').append(new_content)
    }
  }
}

/**
Updates the faded documents and the gallery is locked if three documents are loaded.
@method updateEffectsInsideDocumentGallery
@for LessonEditorGalleries
**/
function updateEffectsInsideDocumentGallery() {
  var inputs = $('#inputs_for_documents input');
  var ids = new Array();
  inputs.each(function() {
    ids.push($(this).val());
  });
  $('.documentsExternal .documentInGallery.disabled').each(function() {
    $(this).removeClass('disabled');
  });
  for(var i = 0; i < ids.length; i++) {
    $('#gallery_document_' + ids[i] + ' .documentInGallery').addClass('disabled');
  }
  if(!$('#lesson_editor_document_gallery_container #document_gallery').data('empty')) {
    if(inputs.length == 3) {
      $('.documentsExternal .for-scroll-pain').hide();
      $('.documentsExternal #empty_document_gallery').show();
      $('.documentsFooter .triangolo, .documentsFooter .footerLeft').hide();
    } else {
      $('.documentsExternal .for-scroll-pain').show();
      $('.documentsExternal #empty_document_gallery').hide();
      $('.documentsFooter .triangolo, .documentsFooter .footerLeft').show();
    }
  }
  var container = $('#lesson_editor_document_gallery_container');
  $('.document_attached .documentInGallery .add_remove').attr('title', container.data('title-remove'));
  $('.documentInGalleryExternal .documentInGallery:not(.disabled) .add_remove').attr('title', container.data('title-add'));
  $('.documentInGalleryExternal .documentInGallery.disabled .add_remove').attr('title', '');
}





/**
Check if image ratio is bigger then kind ratio.
@method isHorizontalMask
@for LessonEditorImageResizing
@param image_width {Number} width of the image
@param image_height {Number} height of the image
@param kind {String} type image into slide, accepts values: cover, image1, image2, image3, image4
@return {Boolean} true if the image is horizontal, false if vertical
**/
function isHorizontalMask(image_width, image_height, kind) {
  var ratio = image_width / image_height;
  var slideRatio = 0;
  switch(kind) {
    case 'cover': slideRatio = 1.6;
    break;
    case 'image1': slideRatio = 1;
    break;
    case 'image2': slideRatio = 0.75;
    break;
    case 'image3': slideRatio = 1.55;
    break;
    case 'image4': slideRatio = 1.55;
    break;
    default: slideRatio = 1.5;
  }
  return (ratio >= slideRatio);
}

/**
Gets scaled height to slide images.
@method resizeHeight
@for LessonEditorImageResizing
@param image_width {Number} width of the image
@param image_height {Number} height of the image
@param kind {String} type image into slide, accepts values: cover, image1, image2, image3, image4
@return {Number} scaled height
**/
function resizeHeight(width, height, kind) {
  switch(kind) {
    case 'cover': slideWidth = 900;
    break;
    case 'image1': slideWidth = 420;
    break;
    case 'image2': slideWidth = 420;
    break;
    case 'image3': slideWidth = 860;
    break;
    case 'image4': slideWidth = 420;
    break;
    default: slideWidth = 900;
  }
  return parseInt((height * slideWidth) / width) + 1;
}

/**
Gets scaled width to slide images.
@method resizeWidth
@for LessonEditorImageResizing
@param image_width {Number} width of the image
@param image_height {Number} height of the image
@param kind {String} type image into slide, accepts values: cover, image1, image2, image3, image4
@return {Number} scaled width
**/
function resizeWidth(width, height, kind) {
  switch(kind) {
    case 'cover': slideHeight = 560;
    break;
    case 'image1': slideHeight = 420;
    break;
    case 'image2': slideHeight = 550;
    break;
    case 'image3': slideHeight = 550;
    break;
    case 'image4': slideHeight = 265;
    break;
    default: slideHeight = 590;
  }
  return parseInt((width * slideHeight) / height) + 1;
}





/**
Inizializes jQueryUI <b>sortable</b> function on top navigation numbers, so that they can be sorted (see also {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method"}}{{/crossLink}} and {{#crossLink "LessonEditorSlidesNavigation"}}{{/crossLink}}).
@method initializeSortableNavs
@for LessonEditorJqueryAnimations
**/
function initializeSortableNavs() {
  $('#heading, #heading .scroll-pane').css('width', (parseInt($(window).outerWidth()) - 50) + 'px');
  var slides_numbers = $('#slide-numbers');
  var slides_amount = slides_numbers.find('li.navNumbers').length;
  slides_numbers.css('width', '' + ((parseInt(slides_amount + 1) * 32) - 28) + 'px');
  var add_last_button = $('._add_new_slide_options_in_last_position');
  if(parseInt(slides_numbers.css('width')) < (parseInt($(window).outerWidth()) - 100)) {
    add_last_button.css('left', '' + (slides_numbers.find('li.navNumbers').last().position().left + 40) + 'px');
  }
  slides_numbers.sortable({
    items: '._slide_nav_sortable',
    axis: 'x',
    stop: function(event, ui) {
      var previous = ui.item.prev();
      var new_position = 0;
      var old_position = parseInt(ui.item.find('a._slide_nav').html());
      if(parseInt(previous.find('a._slide_nav').html()) == 1) {
        new_position = 2;
      } else {
        var previous_item_position = parseInt(previous.find('a._slide_nav').html());
        if(old_position > previous_item_position) {
          new_position = previous_item_position + 1;
        } else {
          new_position = previous_item_position;
        }
      }
      saveCurrentSlide('', false);
      if(old_position != new_position) {
        stopMediaInCurrentSlide();
        $.ajax({
          type: 'post',
          url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + ui.item.find('a._slide_nav').data('slide-id') + '/move/' + new_position
        });
      } else {
        slideTo(ui.item.find('a._slide_nav').data('slide-id'));
      }
    }
  });
}

/**
Inizializes jQueryUI <b>draggable</b> function on slide image containers (to understand if the draggable is vertical or horizontal it uses {{#crossLink "LessonEditorImageResizing/isHorizontalMask:method"}}{{/crossLink}}).
@method makeDraggable
@for LessonEditorJqueryAnimations
@param place_id {String} HTML id for the container to make draggable
**/
function makeDraggable(place_id) {
  var full_place = $('#' + place_id + ' .mask');
  var axe = 'x';
  if(full_place.hasClass('vertical')) {
    axe = 'y';
  }
  var image = $('#' + place_id + ' .mask img');
  var side = '';
  var maskedImgWidth;
  var maskedImgHeight;
  var dist;
  if(axe == 'x') {
    maskedImgWidth = image.attr('width');
    dist = maskedImgWidth - full_place.width();
    side = 'left';
  } else {
    maskedImgHeight = image.attr('height');
    side = 'top';
    dist = maskedImgHeight - full_place.height();
  }
  $('#' + place_id + ' .mask .alignable').draggable({
    axis: axe,
    cursor: 'move',
    distance: 10,
    start: function() {
      $('#' + place_id + ' .mask img').css('cursor', 'move');
      $('#' + place_id + ' .alignable').data('rolloverable', false);
      $('#' + place_id + ' span').hide();
    },
    stop: function() {
      $('#' + place_id + ' .mask img').css('cursor', 'url(https://mail.google.com/mail/images/2/openhand.cur), move');
      $('#' + place_id + ' .alignable').data('rolloverable', true);
      $('#' + place_id + ' span').show();
      var thisDrag = $(this);
      var offset = thisDrag.css(side);
      if(parseInt(offset) > 0) {
        offset = 0;
        if(side == 'left') {
          thisDrag.animate({
            left: '0'
          }, 100);
        } else {
          thisDrag.animate({
            top: '0'
          }, 100);
        }
      } else {
        if(parseInt(offset) < -(parseInt(dist))) {
          offset = -parseInt(dist);
          if(side == 'left') {
            thisDrag.animate({
              left: '-' + dist + 'px'
            }, 100);
          } else {
            thisDrag.animate({
              top: '-' + dist + 'px'
            }, 100);
          }
        }
      }
      $('#' + place_id + ' .align').val(parseInt(offset));
    }
  });
}





/**
Asynchronously loads current slide, previous and following.
@method loadSlideAndAdhiacentInLessonEditor
@for LessonEditorSlideLoading
@param slide_id {Number} id in the database of the current slide, used to extract the HTML id
**/
function loadSlideAndAdhiacentInLessonEditor(slide_id) {
  var slide = $('#slide_in_lesson_editor_' + slide_id);
  loadSlideInLessonEditor(slide);
  loadSlideInLessonEditor(slide.prev());
  loadSlideInLessonEditor(slide.next());
}

/**
Asynchronous slide loading. It checks if the slide has been loaded or not.
@method loadSlideInLessonEditor
@for LessonEditorSlideLoading
@param slide {Object} slide to be loaded
**/
function loadSlideInLessonEditor(slide) {
  if(slide.length > 0 && !slide.data('loaded')) {
    $.ajax({
      type: 'get',
      url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + slide.data('slide-id') + '/load'
    });
  }
}





/**
Initialize slides position to center.
@method initLessonEditorPositions
@for LessonEditorSlidesNavigation
**/
function initLessonEditorPositions() {
  WW = parseInt($(window).outerWidth());
  WH = parseInt($(window).outerHeight());
  $('#main').css('width', WW);
  $('ul#slides').css('width', (($('ul#slides li').length + 2) * 1000));
  $('ul#slides').css('top', ((WH / 2) - 295) + 'px');
  $('ul#slides.new').css('top', ((WH / 2) - 335) + 'px');
  $('#footer').css('top', (WH - 40) + 'px').css('width', (WW - 24) + 'px');
  if(WW > 1000) {
    $('ul#slides li:first').css('margin-left', ((WW - 900) / 2) + 'px');
    $('ul#slides.new li:first').css('margin-left', ((WW - 900) / 2) + 'px');
  }
}

/**
Re-initialize slides position to center after ajax events.
@method reInitializeSlidePositionsInLessonEditor
@for LessonEditorSlidesNavigation
**/
function reInitializeSlidePositionsInLessonEditor() {
  $('ul#slides').css('width', (($('ul#slides li').length + 2) * 1000));
  $('ul#slides li').each(function(index){
    $(this).data('position', (index + 1));
  });
}

/**
Scrolls navigation scrollPane ({{#crossLink "LessonEditorSlidesNavigation"}}{{/crossLink}}) when moving to another slide.
@method scrollPaneUpdate
@for LessonEditorSlidesNavigation
@param trigger_element {String} HTML selector for the element which triggers the scroll
@return {Boolean} false, probably to stop further actions
**/
function scrollPaneUpdate(trigger_element) {
  var not_current = $(trigger_element);
  if($('.slides.active').data('position') < not_current.parent('li').data('position')) {
    $('#nav_list_menu').data('jsp').scrollByX(30);
  } else {
    $('#nav_list_menu').data('jsp').scrollByX(-30);
  }
  return false;
}

/**
Moves to a slide, update current slide in top navigation.
@method slideTo
@for LessonEditorSlidesNavigation
@param slide_id {Number} id in the database of the slide, used to extract the HTML id
@param callback {Object} callback function, to be executed after the slide (for instance, this function is used to call {{#crossLink "LessonEditorCurrentSlide/showNewSlideOptions:method"}}{{/crossLink}})
**/
function slideTo(slide_id, callback) {
  loadSlideAndAdhiacentInLessonEditor(slide_id);
  var slide = $('#slide_in_lesson_editor_' + slide_id);
  var position = slide.data('position');
  if (position == 1) {
    marginReset = 0;
  } else {
    marginReset = (-((position - 1) * 1010)) + 'px';
  }
  $('ul#slides').animate({
    marginLeft: marginReset
  }, 1500, function() {
    if(typeof(callback) != 'undefined') {
      callback();
    }
  });
  $('ul#slides li').animate({
    opacity: 0.4,
  }, 150, function() {
    $(this).find('.buttons').fadeOut();
    if($(this).find('layer').length == 0) {
      $(this).prepend('<layer class="_not_current_slide"></layer>');
    } else {
      if($(this).find('layer._not_current_slide_disabled').length > 0) {
        $(this).find('layer._not_current_slide_disabled').removeClass('_not_current_slide_disabled').addClass('_not_current_slide');
      }
    }
    $('a._lesson_editor_current_slide_nav').removeClass('_lesson_editor_current_slide_nav active');
    $('#slide_in_nav_lesson_editor_' + slide_id).addClass('_lesson_editor_current_slide_nav active');
  });
  $('ul#slides li:eq(' + (position - 1) + ')').animate({
    opacity: 1,
  }, 500, function() {
    $(this).find('.buttons').fadeIn();
    $(this).find('layer').remove();
    $('li._lesson_editor_current_slide').removeClass('_lesson_editor_current_slide active');
    $('#slide_in_lesson_editor_' + slide_id).addClass('_lesson_editor_current_slide active');
  });
}





/**
TinyMCE callback to clean spans containing classes for font size: these classes are attached to the first ol, ul, p
@method cleanTinyMCESpanTagsFontSize
@for LessonEditorTinyMCE
@param editor {Object} tinyMCE instance
**/
function cleanTinyMCESpanTagsFontSize(editor) {
  var spans = $(editor.getBody()).find('span.size1, span.size2, span.size3, span.size4, span.size5, span.size6');
  var sizes = ['size1', 'size2', 'size3', 'size4', 'size5', 'size6'];
  var sizes_class = sizes.join(' ');
  if(spans.length > 0) {
    spans.each(function() {
      var my_sizes = $(this).attr('class').split(' ').filter(function(i) {
        return sizes.indexOf(i) > -1;
      }).join(' ');
      $(this).removeClass(my_sizes);
      $(this).parents('.mceContentBody ul, .mceContentBody ol, .mceContentBody p').removeClass(sizes_class).addClass(my_sizes);
    });
  }
}

/**
Initialize tinyMCE editor for a single textarea.
@method initTinymce
@for LessonEditorTinyMCE
@param tiny_id {String} HTML id of the tinyMCE textarea
**/
function initTinymce(tiny_id) {
  var plugins = 'pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,';
  plugins += 'insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,';
  plugins += 'noneditable,visualchars,nonbreaking,xhtmlxtras,template,tiny_mce_wiris';
  var buttons = 'fontsizeselect,forecolor,justifyleft,justifycenter,justifyright,justifyfull,';
  buttons += 'bold,italic,underline,numlist,bullist,link,unlink,charmap,tiny_mce_wiris_formulaEditor';
  tinyMCE.init({
    mode: 'exact',
    elements: tiny_id,
    theme: 'advanced',
    editor_selector: 'tinymce',
    skin: 'desy',
    plugins: plugins,
    paste_preprocess: function(pl, o) {
      o.content = stripTagsForCutAndPaste(o.content, '');
    },
    theme_advanced_buttons1: buttons,
    theme_advanced_toolbar_location: 'external',
    theme_advanced_toolbar_align: 'left',
    theme_advanced_statusbar_location: false,
    theme_advanced_resizing: true,
    theme_advanced_font_sizes: '13px=.size1,17px=.size2,21px=.size3,25px=.size4,29px=.size5,35px=.size6',
    setup: function(ed) {
      ed.onInit.add(function(ed, e) {
        $('#' + tiny_id + '_ifr').attr('scrolling', 'no');
      });
      ed.onNodeChange.add(function(ed, cm, e) {
        cleanTinyMCESpanTagsFontSize(ed);
      });
      ed.onKeyUp.add(function(ed, e) {
        handleTinyMCEOveflow(ed, tiny_id);
      });
      ed.onClick.add(function(ed, e) {
        var textarea = $('#' + tiny_id);
        if(textarea.data('placeholder')) {
          ed.setContent('');
          textarea.data('placeholder', false);
        }
      });
    }
  });
}

/**
TinyMCE callback to show warning when texearea content exceeds the available space. Adds a red border to the textarea.This function is used in tinyMCE setup ({{#crossLink "LessonEditorTinyMCE/initTinymce:method"}}{{/crossLink}}).
@method handleTinyMCEOveflow
@for LessonEditorTinyMCE
@param inst {Object} tinyMCE instance
@param tiny_id {Number} HTML id of the tinyMCE textarea
**/
function handleTinyMCEOveflow(inst, tiny_id) {
  var maxH = 420;
  if($('textarea#' + tiny_id).parents('.slide-content.audio').length > 0) {
    maxH = 329;
  }
  if(inst.getBody().scrollHeight > maxH) {
    $('#' + tiny_id + '_tbl').css('border-left', '1px solid red').css('border-right', '1px solid red');
    $('#' + tiny_id + '_tbl tr.mceFirst td').css('border-top', '1px solid red');
    $('#' + tiny_id + '_tbl tr.mceLast td').css('border-bottom', '1px solid red');
  } else {
    $('#' + tiny_id + '_tbl').css('border-left', '1px solid #EFEFEF').css('border-right', '1px solid #EFEFEF');
    $('#' + tiny_id + '_tbl tr.mceFirst td').css('border-top', '1px solid #EFEFEF');
    $('#' + tiny_id + '_tbl tr.mceLast td').css('border-bottom', '1px solid #EFEFEF');
  }
}

/**
Function to strip tags in a text pasted inside TinyMCE.
@method stripTagsForCutAndPaste
@for LessonEditorTinyMCE
@param str {String} string to be stripped
@param allowed_tags {Array} allowed HTML tags
**/
function stripTagsForCutAndPaste(str, allowed_tags) {
  var key = '', allowed = false;
  var matches = [];
  var allowed_array = [];
  var allowed_tag = '';
  var i = 0;
  var k = '';
  var html = '';
  var replacer = function (search, replace, str) {
    return str.split(search).join(replace);
  };
  if (allowed_tags) {
    allowed_array = allowed_tags.match(/([a-zA-Z0-9]+)/gi);
  }
  str += '';
  matches = str.match(/(<\/?[\S][^>]*>)/gi);
  for(key in matches) {
    if(isNaN(key)) {
      continue;
    }
    html = matches[key].toString();
    allowed = false;
    for(k in allowed_array) {
      allowed_tag = allowed_array[k];
      i = -1;
      if(i != 0) {
        i = html.toLowerCase().indexOf('<' + allowed_tag + '>');
      }
      if(i != 0) {
        i = html.toLowerCase().indexOf('<' + allowed_tag + ' ');
      }
      if(i != 0) {
        i = html.toLowerCase().indexOf('</' + allowed_tag);
      }
      if(i == 0) {
        allowed = true;
        break;
      }
    }
    if(!allowed) {
      str = replacer(html, '', str);
    }
  }
  return str;
}
