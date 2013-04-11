/**
The Lesson Editor is used to add and edit slides to a private lesson.
<br/><br/>
When opening the Editor on a lesson, all its slides are appended to a queue, of which it's visible only the portion that surrounds the <b>current slide</b> (the width of such a portion depends on the screen resolution, see {{#crossLink "LessonEditorSlidesNavigation/initLessonEditorPositions:method"}}{{/crossLink}}, {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyResize:method"}}{{/crossLink}} and {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyGeneral:method"}}{{/crossLink}}). The current slide is illuminated and editable, whereas the adhiacent slides are covered by a layer with opacity that prevents the user from editing them: if the user clicks on this layer, the application takes the slide below it as new current slide and moves it to the center of the screen (see {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method"}}{{/crossLink}} and the methods in {{#crossLink "LessonEditorSlidesNavigation"}}{{/crossLink}}): only after this operation, the user can edit that particular slide. To avoid overloading when there are many slides containing media, the slides are instanced all together but their content is loaded only when the user moves to them (see the methods in {{#crossLink "LessonEditorSlideLoading"}}{{/crossLink}}).
<br/><br/>
On the right side of each slide the user finds a list of <b>buttons</b> (initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method"}}{{/crossLink}}): each button corresponds either to an action that can be performed on the slide, either to an action that can be performed to the whole lesson (for instance, save and exit, or edit title description and tags).
<br/><br/>
The tool to navigate the slides is located on the top of the editor: each small square represents a slide (with its position), and passing with the mouse over it the Editor shows a miniature of the corresponding slide (these functionalities are initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method"}}{{/crossLink}}). Clicking on a slide miniature, the application moves to that slide using the function {{#crossLink "LessonEditorSlidesNavigation/slideTo:method"}}{{/crossLink}}. The slides can be sorted dragging with the mouse (using the JQueryUi plugin, initialized in {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyJqueryAnimations:method"}}{{/crossLink}} and {{#crossLink "LessonEditorJqueryAnimations/initializeSortableNavs:method"}}{{/crossLink}}).
Inside the Editor, there are two operations that require hiding and replacement of the queue of slides: <b>adding a media element to a slide</b> and </b>choosing a new slide<b/>. In both these operations, an HTML div is extracted from the main template (where it was hidden), and put in the place of the current slide, hiding the rest of the slides queue, buttons, and slides navigation (operations performed by {{#crossLink "LessonEditorCurrentSlide/hideEverythingOutCurrentSlide:method"}}{{/crossLink}}). For the galleries, the extracted div must be filled by an action called via Ajax (see the module {{#crossLinkModule "galleries"}}{{/crossLinkModule}}), whereas the div with the list of available slides is already loaded with the Editor (see {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyNewSlideChoice:method"}}{{/crossLink}}).
<br/><br/>

@module lesson-editor
**/





/**
Hide page elements around current slide on new slide selection
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
Hide new slide selection
@method hideNewSlideChoice
@for LessonEditorCurrentSlide
**/
function hideNewSlideChoice() {
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.find('div.slide-content').addClass(current_slide.data('kind'));
  current_slide.find('.box.new_slide').remove();
  current_slide.find('._hide_add_new_slide_options').removeAttr('class').addClass('addButtonOrange _add_new_slide_options');
  showEverythingOutCurrentSlide();
}

/**
Restore page elements around current slide after new slide selection
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
Hide new slide selection
@method showNewSlideChoice
@for LessonEditorCurrentSlide
**/
function showNewSlideOptions() {
  stopMediaInCurrentSlide();
  var current_slide_content = $('li._lesson_editor_current_slide .slide-content');
  current_slide_content.removeClass('cover title video1 video2 audio image1 image2 image3 image4 text');
  var html_to_be_replaced = $('#new_slide_option_list').html();
  current_slide_content.prepend(html_to_be_replaced);
  current_slide_content.siblings('.buttons').find('._add_new_slide_options').removeAttr('class').addClass('minusButtonOrange _hide_add_slide _hide_add_new_slide_options');
  hideEverythingOutCurrentSlide();
}

/**
Stop video and audio playing into current slide, usually only one kind of media is present into current slide
@method stopMediaInCurrentSlide
@for LessonEditorCurrentSlide
**/
function stopMediaInCurrentSlide() {
  var current_slide_id = $('li._lesson_editor_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}





/**
bla bla bla
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
bla bla bla
@method lessonEditorDocumentReadyAddMediaElement
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyAddMediaElement() {
  $('body').on('click', '._add_image_to_slide', function(e) {
    e.preventDefault();
    var image_id = $(this).data('image-id');
    closePopUp('dialog-image-gallery-' + image_id);
    removeGalleryInLessonEditor('image');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' ._input_image_id').val(image_id);
    $('#' + place_id + ' ._input_align').val('0');
    var image_url = $(this).data('url');
    var image_width = $(this).data('width');
    var image_height = $(this).data('height');
    var full_place = $('#' + place_id + ' ._full_image_in_slide');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' ._empty_image_in_slide').hide();
    }
    var old_mask = '_mask_x';
    var new_mask = '_mask_y';
    var old_orientation = 'width';
    var orientation = 'height';
    var orientation_val = resizeHeight(image_width, image_height, current_slide.data('kind'));
    var to_make_draggable = 'y';
    if(isHorizontalMask(image_width, image_height, current_slide.data('kind'))) {
      old_mask = '_mask_y';
      new_mask = '_mask_x';
      old_orientation = 'height';
      orientation = 'width';
      orientation_val = resizeWidth(image_width, image_height, current_slide.data('kind'));
      to_make_draggable = 'x';
    }
    full_place.addClass(new_mask).removeClass(old_mask);
    var img_tag = $('#' + place_id + ' ._full_image_in_slide img');
    img_tag.attr('src', image_url);
    img_tag.parent().css('left', 0);
    img_tag.parent().css('top', 0);
    img_tag.removeAttr(old_orientation);
    img_tag.attr(orientation, orientation_val);
    makeDraggable(place_id);
  });
  $('body').on('click', '._add_video_to_slide', function(e) {
    e.preventDefault();
    var video_id = $(this).data('video-id');
    closePopUp('dialog-video-gallery-' + video_id);
    removeGalleryInLessonEditor('video');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' ._input_video_id').val(video_id);
    var video_mp4 = $(this).data('mp4');
    var video_webm = $(this).data('webm');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' ._full_video_in_slide');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' ._empty_video_in_slide').hide();
    }
    $('#' + place_id + ' ._full_video_in_slide source[type="video/mp4"]').attr('src', video_mp4);
    $('#' + place_id + ' ._full_video_in_slide source[type="video/webm"]').attr('src', video_webm);
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
    $('#' + place_id + ' ._rolloverable').data('rolloverable', true);
  });
  $('body').on('click', '._add_audio_to_slide', function(e) {
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
    $('#' + place_id + ' ._input_audio_id').val(audio_id);
    var audio_m4a = $(this).data('m4a');
    var audio_ogg = $(this).data('ogg');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' ._full_audio_in_slide');
    if(!full_place.is(':visible')) {
      full_place.show();
      $('#' + place_id + ' ._empty_audio_in_slide').hide();
    }
    $('#' + place_id + ' ._full_audio_in_slide source[type="audio/mp4"]').attr('src', audio_m4a);
    $('#' + place_id + ' ._full_audio_in_slide source[type="audio/ogg"]').attr('src', audio_ogg);
    $('#' + place_id + ' audio').load();
    $('#' + place_id + ' ._media_player_total_time').html(secondsToDateString(duration));
    $('#' + place_id + ' ._full_audio_in_slide .audio_title').text(new_audio_title);
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
bla bla bla
@method lessonEditorDocumentReadyGalleries
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyGalleries() {
  $('body').on('click', '._show_image_gallery_in_lesson_editor', function() {
    showGalleryInLessonEditor(this, 'image');
  });
  $('body').on('click', '._show_audio_gallery_in_lesson_editor', function() {
    stopMediaInCurrentSlide();
    showGalleryInLessonEditor(this, 'audio');
  });
  $('body').on('click', '._show_video_gallery_in_lesson_editor', function() {
    stopMediaInCurrentSlide();
    showGalleryInLessonEditor(this, 'video');
  });
  $('body').on('click', '._close_image_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('image');
  });
  $('body').on('click', '._close_video_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('video');
  });
  $('body').on('click', '._close_audio_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    var current_playing_audio = $('._audio_expanded_in_gallery');
    if(current_playing_audio.length != 0) {
      current_playing_audio.removeClass('_audio_expanded_in_gallery');
      stopMedia('#' + current_playing_audio.attr('id') + ' audio');
      $('#' + current_playing_audio.attr('id') + ' ._expanded').hide();
    }
    removeGalleryInLessonEditor('audio');
  });
}

/**
bla bla bla
@method lessonEditorDocumentReadyGeneral
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyGeneral() {
  $('html.lesson-editor-layout ul#slides').css('margin-top', ((($(window).height() - 590) / 2) - 40) + 'px');
  $('html.lesson-editor-layout ul#slides.new').css('margin-top', ((($(window).height() - 590) / 2)) + 'px');
  $('.slide-content.cover .title').css('margin-left', 'auto');
  $('html.lesson-editor-layout ul#slides input').attr('autocomplete', 'off');
}

/**
bla bla bla
@method lessonEditorDocumentReadyJqueryAnimations
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyJqueryAnimations() {
  $('._image_container_in_lesson_editor').each(function() {
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
bla bla bla
@method lessonEditorDocumentReadyNewSlideChoice
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyNewSlideChoice() {
  $('body').on('click', '._add_new_slide', function() {
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
bla bla bla
@method lessonEditorDocumentReadyReplaceMediaElement
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyReplaceMediaElement() {
  $('body').on('mouseover', '._full_image_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' ._rolloverable');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').show();
    }
  });
  $('body').on('mouseout', '._full_image_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' ._rolloverable');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').hide();
    }
  });
}

/**
bla bla bla
@method lessonEditorDocumentReadyResize
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyResize() {
  $(window).resize(function() {
    $('html.lesson-editor-layout ul#slides').css('margin-top', ((($(window).height() - 590) / 2) - 40) + 'px');
    $('html.lesson-editor-layout ul#slides.new').css('margin-top', ((($(window).height() - 590) / 2)) + 'px');
    if(WW > 1000) {
      $('ul#slides li:first').css('margin-left', (($(window).width() - 900) / 2) + 'px')
      $('ul#slides.new li:first').css('margin-left', (($(window).width() - 900) / 2) + 'px');
    }
    $('#footer').css('top', ($(window).height() - 40) + 'px').css('width', ($(window).width() - 24) + 'px');
  });
}

/**
bla bla bla
@method lessonEditorDocumentReadySlideButtons
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadySlideButtons() {
  $('body').on('click', '._hide_add_new_slide_options', function() {
    hideNewSlideChoice();
  });
  $('body').on('click', '._save_slide', function(e) {
    saveCurrentSlide();
  });
  $('body').on('click', '._save_slide_and_exit', function() {
    tinyMCE.triggerSave();
    var temporary = new Array();
    var temp_counter = 0;
    $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
      if($(this).data('placeholder')) {
        temporary[temp_counter] = $(this).val();
        temp_counter++;
        $(this).val('');
      }
    });
    $.ajax({
      type: 'post',
      url: $('._lesson_editor_current_slide form').attr('action') + '_and_exit',
      timeout: 5000,
      data: $('._lesson_editor_current_slide form').serialize()
    });
    temp_counter = 0;
    $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
      if($(this).data('placeholder')) {
        $(this).val(temporary[temp_counter]);
        temp_counter++;
      }
    });
  });
  $('body').on('click', '._save_slide_and_edit', function() {
    tinyMCE.triggerSave();
    var temporary = new Array();
    var temp_counter = 0;
    $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
      if($(this).data('placeholder')) {
        temporary[temp_counter] = $(this).val();
        temp_counter++;
        $(this).val('');
      }
    });
    $.ajax({
      type: 'post',
      url: $('._lesson_editor_current_slide form').attr('action') + '_and_edit',
      timeout: 5000,
      data: $('._lesson_editor_current_slide form').serialize()
    });
    temp_counter = 0;
    $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
      if($(this).data('placeholder')) {
        $(this).val(temporary[temp_counter]);
        temp_counter++;
      }
    });
  });
  $('body').on('click', '._add_new_slide_options', function() {
    if(!$(this).hasClass('disabled')) {
      saveCurrentSlide();
      showNewSlideOptions();
    }
  });
  $('body').on('click', '._delete_slide', function() {
    stopMediaInCurrentSlide();
    var slide = $('li._lesson_editor_current_slide');
    slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
    $.ajax({
      type: 'post',
      url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + slide.data('slide-id') + '/delete'
    });
  });
}

/**
bla bla bla
@method lessonEditorDocumentReadySlidesNavigator
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadySlidesNavigator() {
  $('body').on('mouseover', '#slide-numbers li.navNumbers:not(._add_new_slide_options_in_last_position)', function(e) {
    var tip = $(this);
    var this_tooltip = tip.children('.slide-tooltip');
    if(e.pageX < ($(window).width() / 2)) {
      this_tooltip.show();
    } else {
      this_tooltip.addClass('slide-tooltip-to-left');
      tip.children('.slide-tooltip-to-left').show();
    }
  });
  $('body').on('mouseout', '#slide-numbers li.navNumbers:not(._add_new_slide_options_in_last_position)', function(e) {
    var this_tooltip =$(this).children('.slide-tooltip');
    this_tooltip.removeClass('slide-tooltip-to-left');
    this_tooltip.hide();
  });
  $('body').on('click', '._slide_nav:not(._lesson_editor_current_slide_nav)', function(e) {
    e.preventDefault();
    stopMediaInCurrentSlide();
    saveCurrentSlide();
    slideTo($(this).data('slide-id'));
  });
  $('body').on('click', '._not_current_slide', function(e) {
    e.preventDefault();
    saveCurrentSlide();
    stopMediaInCurrentSlide();
    slideTo($(this).parent().data('slide-id'));
    scrollPaneUpdate(this);
  });
  $('body').on('click', '._add_new_slide_options_in_last_position', function() {
    if(!$(this).hasClass('disabled')) {
      saveCurrentSlide();
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
bla bla bla
@method lessonEditorDocumentReadyTextFields
@for LessonEditorDocumentReady
**/
function lessonEditorDocumentReadyTextFields() {
  $('body').on('focus', '._lesson_editor_placeholder', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
  $('body').on('focus', '#slides._new #title', function() {
    if($('#slides._new #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #title_placeholder').attr('value', '0');
    }
  });
  $('body').on('focus', '#slides._new #description', function() {
    if($('#slides._new #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #description_placeholder').attr('value', '0');
    }
  });
  $('body').on('focus', '#slides._update #title', function() {
    if($('#slides._update #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #title_placeholder').attr('value', '0');
    }
  });
  $('body').on('focus', '#slides._update #description', function() {
    if($('#slides._update #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #description_placeholder').attr('value', '0');
    }
  });
}





/**
Save current slide. It sends tinyMCE editor content to form data to be serialized, it handles form placeholders. Uses: [submitCurrentSlideForm](../classes/submitCurrentSlideForm.html#method_submitCurrentSlideForm)
@method saveCurrentSlide
@for LessonEditorForms
**/
function saveCurrentSlide() {
  tinyMCE.triggerSave();
  var temporary = new Array();
  var temp_counter = 0;
  $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      temporary[temp_counter] = $(this).val();
      temp_counter++;
      $(this).val('');
    }
  });
  submitCurrentSlideForm();
  temp_counter = 0;
  $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      $(this).val(temporary[temp_counter]);
      temp_counter++;
    }
  });
}

/**
Submit serialized form data for current slide
@method submitCurrentSlideForm
@for LessonEditorForms
**/
function submitCurrentSlideForm() {
  $.ajax({
    type: 'post',
    url: $('._lesson_editor_current_slide form').attr('action'),
    timeout:5000,
    data: $('._lesson_editor_current_slide form').serialize(),
    beforeSend: unbindLoader()
  }).always(bindLoader);
}





/**
Hide media gallery for selected type
@method removeGalleryInLessonEditor
@for LessonEditorGalleries
@param sty_type {String} gallery type
**/
function removeGalleryInLessonEditor(sti_type) {
  $('#lesson_editor_' + sti_type + '_gallery_container').hide();
  $('li._lesson_editor_current_slide .slide-content').children().show();
  showEverythingOutCurrentSlide();
}

/**
Show media gallery for selected type clicking on slide green plus button
@method showGalleryInLessonEditor
@for LessonEditorGalleries
@param obj {String} gallery type
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
Check if image ratio is bigger then kind ratio
@method isHorizontalMask
@for LessonEditorImageResizing
@param image_width {Number}
@param image_height {Number}
@param kind {String} type image into slide, acceptes values: cover, image1, image2, image3, image4
@return {Boolean} true if image ratio is bigger then kind ratio
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
Sets scaled height to slide images
@method resizeHeight
@for LessonEditorImageResizing
@param image_width {Number}
@param image_height {Number}
@param kind {String} type image into slide, acceptes values: cover, image1, image2, image3, image4
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
  return (height * slideWidth) / width;
}

/**
Sets scaled width to slide images
@method resizeWidth
@for LessonEditorImageResizing
@param image_width {Number}
@param image_height {Number}
@param kind {String} type image into slide, acceptes values: cover, image1, image2, image3, image4
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
  return (width * slideHeight) / height;
}





/**
Inizialize jQueryUI _sortable_ function on top navigation numbers, so that they can be sorted
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
      saveCurrentSlide();
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
Inizialize jQueryUI _draggable_ function on slide image containers.
@method makeDraggable
@for LessonEditorJqueryAnimations
@param place_id {Number} media element id
**/
function makeDraggable(place_id) {
  var full_place = $('#' + place_id + ' ._full_image_in_slide');
  var axe = 'x';
  if(full_place.hasClass('_mask_y')) {
    axe = 'y';
  }
  var image = $('#' + place_id + '  ._full_image_in_slide img');
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
  $('#' + place_id + ' ._full_image_in_slide ._rolloverable').draggable({
    axis: axe,
    distance: 10,
    start: function() {
      $('#' + place_id + ' ._rolloverable').data('rolloverable', false);
      $('#' + place_id + ' span').hide();
    },
    stop: function() {
      $('#' + place_id + ' ._rolloverable').data('rolloverable', true);
      $('#' + place_id + ' span').show();
      var thisDrag = $(this);
      var offset = thisDrag.css(side);
      if(parseInt(offset) > 0) {
        offset = 0;
        if(side=='left') {
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
          if(side=='left') {
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
      $('#' + place_id + ' ._input_align').val(parseInt(offset));
    }
  });
}





/**
Asynchronously loads current slide, previous and following if any of these aren't loaded yet. Uses: [loadSlideInLessonEditor](../classes/loadSlideInLessonEditor.html#method_loadSlideInLessonEditor)
@method loadSlideAndAdhiacentInLessonEditor
@for LessonEditorSlideLoading
@param slide_id {Number} slide id
**/
function loadSlideAndAdhiacentInLessonEditor(slide_id) {
  var slide = $('#slide_in_lesson_editor_' + slide_id);
  loadSlideInLessonEditor(slide);
  loadSlideInLessonEditor(slide.prev());
  loadSlideInLessonEditor(slide.next());
}

/**
Asynchronous slide loading. It is called when the current slide is not loaded yet.
@method loadSlideInLessonEditor
@for LessonEditorSlideLoading
@param slide {String} slide object id
**/
function loadSlideInLessonEditor(slide) {
  if(slide.length > 0 && !slide.data('loaded')) {
    $.ajax({
      type: 'get',
      url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + slide.data('slide-id') + '/load'
    })
  }
}





/**
Initialize slides position to center
@method initLessonEditorPositions
@for LessonEditorSlidesNavigation
**/
function initLessonEditorPositions() {
  WW = parseInt($(window).outerWidth());
  WH = parseInt($(window).outerHeight());
  $('#main').css('width', WW);
  $('ul#slides').css('width', (($('ul#slides li').length + 2) * 1000));
  $('ul#slides').css('top', ((WH / 2) - 295) + 'px');
  $('ul#slides.new').css('top', ((WH / 2) - 335) + 'px')
  $('#footer').css('top', (WH - 40) + 'px').css('width', (WW - 24) + 'px')
  if(WW > 1000) {
    $('ul#slides li:first').css('margin-left', ((WW - 900) / 2) + 'px')
    $('ul#slides.new li:first').css('margin-left', ((WW - 900) / 2) + 'px');
  }
}

/**
Re-initialize slides position to center after ajax events
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
Update top scrollPane when moving to another slide
@method scrollPaneUpdate
@for LessonEditorSlidesNavigation
@param trigger_element {String} element which triggers the scroll, class or id
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
Slide to current slide, update current slide in top navigation. Uses: [loadSlideAndAdhiacentInLessonEditor](../classes/loadSlideAndAdhiacentInLessonEditor.html#method_loadSlideAndAdhiacentInLessonEditor)
@method slideTo
@for LessonEditorSlidesNavigation
@param slide_id {Number} slide id
@param callback {Object} callback function
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
Initialize tinyMCE editor for a single textarea Uses: [tinyMceKeyDownCallbacks](../classes/tinyMceKeyDownCallbacks.html#method_tinyMceKeyDownCallbacks) and [tinyMceCallbacks](../classes/tinyMceCallbacks.html#method_tinyMceCallbacks) 
@method initTinymce
@for LessonEditorTinyMCE
@param tiny_id {Number} tinyMCE textarea id
**/
function initTinymce(tiny_id) {
  var plugins = 'pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,';
  plugins += 'insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,';
  plugins += 'noneditable,visualchars,nonbreaking,xhtmlxtras,template,tiny_mce_wiris';
  var buttons = 'fontsizeselect,forecolor,justifyleft,justifycenter,justifyright,justifyfull,';
  buttons += 'bold,italic,underline,numlist,bullist,link,unlink,tiny_mce_wiris_formulaEditor';
  tinyMCE.init({
    mode: 'exact',
    elements: tiny_id,
    theme: 'advanced',
    editor_selector: 'tinymce',
    skin: 'desy',
    content_css: '/assets/tiny_mce_desy.css',
    plugins: plugins,
    theme_advanced_buttons1: buttons,
    theme_advanced_toolbar_location: 'external',
    theme_advanced_toolbar_align: 'left',
    theme_advanced_statusbar_location: false,
    theme_advanced_resizing: true,
    theme_advanced_font_sizes: '1em=.size1,2em=.size2,3em=.size3,4em=.size4,5em=.size5,6em=.size6,7em=.size7',
    setup: function(ed) {
      ed.onKeyUp.add(function(ed, e) {
        tinyMceCallbacks(ed,tiny_id);
      });
      ed.onKeyDown.add(function(ed, e) {
        tinyMceKeyDownCallbacks(ed,tiny_id);
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
TinyMCE callback to show warning when texearea content exceeds the available space. Add a red border to the textarea. Add this function on tinyMCE setup.
@method tinyMceCallbacks
@for LessonEditorTinyMCE
@param inst {Object} tinyMCE body instance
@param tiny_id {Number} tinyMCE textarea id
**/
function tinyMceCallbacks(inst,tiny_id) {
  var maxH = 422;
  if($('textarea#' + tiny_id).parent('.audio-content').length > 0) {
    maxH = 324;
  }
  if (inst.getBody().scrollHeight > maxH) {
    $(inst.getBody()).parentsUntil('table.mceLayout').css('border', '1px solid red');
  } else {
    $(inst.getBody()).parentsUntil('table.mceLayout').css('border', '1px solid white');
  }
}

/**
TinyMCE keyDown callback to fix list item style. It adds same style of list item text to list numbers or dots. Add this function on tinyMCE setup.
@method tinyMceKeyDownCallbacks
@for LessonEditorTinyMCE
@param inst {Object} tinyMCE body instance
@param tiny_id {Number} tinyMCE textarea id
**/
function tinyMceKeyDownCallbacks(inst,tiny_id){
  var spans = $(inst.getBody()).find('li span');
  spans.each(function(){
    var span = $(this);
    span.parents('li').removeAttr('class');
    span.parents('li').addClass(span.attr('class'));
    span.parentsUntil('li').attr('style', span.attr('style'));
  });
}
