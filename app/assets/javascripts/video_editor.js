/**
* Provides video editor ajax actions.
* 
* @module VideoEditor
*/

/**
* Video Editor initialization
* 
* @method initializeVideoEditor
* @for initializeVideoEditor
* @param name {String} An 
*   Attribute name or 
*   object property path.
* @return {String} Unique clientId.
*/
function initializeVideoEditor() {
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  calculateNewPositionGalleriesInVideoEditor();
  $('#video_editor_timeline').sortable({
    scroll: true,
    handle: '._video_editor_component_hover',
    axis: 'x',
    cursor: 'move',
    cancel: '._video_editor_component_menu',
    containment: 'parent',
    start: function(event, ui) {
      my_item = $(ui.item);
      if(!$('#' + my_item.attr('id') + '_preview').is(':visible')) {
        startVideoEditorPreviewClip(my_item.attr('id'));
      }
      my_item.find('._video_editor_component_menu').hide();
      my_item.data('rolloverable', false);
      my_item.find('._video_component_icon').addClass('current');
      my_item.find('._video_component_thumb').addClass('current');
      $('._video_editor_component ._video_component_transition').addClass('current');
    },
    stop: function(event, ui) {
      my_item = $(ui.item);
      my_item.data('rolloverable', true);
      my_item.find('._video_component_icon').removeClass('current');
      my_item.find('._video_component_thumb').removeClass('current');
      resetVisibilityOfVideoEditorTransitions();
      var boolean1 = (my_item.next().attr('id') == 'add_new_video_component');
      var boolean2 = (my_item.data('position') != $('._video_editor_component').length);
      var boolean3 = (my_item.next().data('position') != (my_item.data('position') + 1));
      if(boolean1 && boolean2 || !boolean1 && boolean3) {
        reloadVideoEditorComponentPositions();
        $('._video_component_icon').effect('highlight', {color: '#41A62A'}, 1500);
      }
    }
  });
}

/**
* Video Editor generic video component cutter.
* 
* Also see [initializeVideoEditor](../classes/initializeVideoEditor.html#method_initializeVideoEditor)
* 
* @method closeGenericVideoComponentCutter
* @for closeGenericVideoComponentCutter
* @param name {String} An 
*   Attribute name or 
*   object property path.
* @return {String} Unique clientId.
*/
function closeGenericVideoComponentCutter() {
  $('._video_component_cutter_arrow').hide('fade', {}, 250);
  $('._video_component_cutter').hide('fade', {}, 250, function() {
    $('#commit_video_editor').show();
    $('#video_editor_global_preview a').removeClass('disabled');
    $('._video_editor_bottom_bar').css('visibility', 'visible');
    resetVisibilityOfVideoEditorTransitions();
    $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'visible');
    $('._video_editor_bottom_bar').show();
    $('#video_editor_box_ghost').hide();
    $('._video_editor_component_hover').removeClass('selected');
    $('._new_component_in_video_editor_hover').removeClass('selected');
    $('._video_component_icon').removeClass('selected');
  });
}

function resetVisibilityOfVideoEditorTransitions() {
  var components = $('._video_editor_component');
  components.each(function(index) {
    if(index < (components.length - 1)) {
      $(this).find('._video_component_transition').removeClass('current');
    } else {
      $(this).find('._video_component_transition').addClass('current');
    }
  });
}

function calculateNewPositionGalleriesInVideoEditor() {
  $('#video_editor_mixed_gallery_container').css('left', (($(window).width() - 940) / 2) + 'px');
  $('#video_editor_audio_gallery_container').css('left', (($(window).width() - 940) / 2) + 'px');
}

function showGalleryInVideoEditor(type) {
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#video_editor_' + type + '_gallery_container').show();
  $('._video_editor_bottom_bar').hide();
  calculateNewPositionGalleriesInVideoEditor();
  $('._video_editor_component_menu').hide();
}

function closeGalleryInVideoEditor(type) {
  $('#video_editor_' + type + '_gallery_container').hide('fade', {}, 250, function() {
    $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'visible');
    $('._video_editor_bottom_bar').show();
    calculateNewPositionGalleriesInVideoEditor();
  });
}

function switchToOtherGalleryInMixedGalleryInVideoEditor(type) {
  if(!$('#video_editor_mixed_gallery_container ' + type).is(':visible')) {
    var big_selector = '#video_editor_mixed_gallery_container ._videos, #video_editor_mixed_gallery_container ._images, #video_editor_mixed_gallery_container ._texts';
    $(big_selector).each(function() {
      if($(this).is(':visible')) {
        big_selector = this;
      }
    });
    $(big_selector).hide();
    if(type == '._texts') {
      resetVideoEditorTextComponent();
    }
    $('#video_editor_mixed_gallery_container ' + type).show();
  }
}

function reloadVideoEditorComponentPositions() {
  var components = $('._video_editor_component');
  components.each(function(index) {
    $(this).data('position', (index + 1));
    $(this).find('._video_component_input_position').val(index + 1);
    $(this).find('._video_component_icon ._left').html(index + 1);
  });
}

function addImageComponentInVideoEditor(image_id, component, preview, duration) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 186;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#info_container').data('last-component-id', next_position);
  // build preview
  var empty_preview = $('#empty_image_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_editor_preview_container').append(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_image_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_editor_cutters').append(empty_cutter);
  // build component
  var empty_component = $('#empty_image_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  current_preview.attr('id', ('video_component_' + next_position + '_preview'));
  current_preview.html(preview);
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + next_position + '_cutter'));
  current_cutter.find('._old').html(secondsToDateString(duration));
  // edit component
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon ._left').html(next_position);
  current_component.find('._video_editor_component_hover').append(component);
  var to_be_appended = fillVideoEditorSingleParameter('type', next_position, 'image');
  to_be_appended += fillVideoEditorSingleParameter('image_id', next_position, image_id);
  to_be_appended += fillVideoEditorSingleParameter('duration', next_position, duration);
  to_be_appended += fillVideoEditorSingleParameter('position', next_position, next_position);
  current_component.find('._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions();
  resetVisibilityOfVideoEditorTransitions();
  if(!$('#video_editor_global_preview').hasClass('_enabled')) {
    $('#video_editor_global_preview').addClass('_enabled');
    $('#video_editor_global_preview a').removeClass('disabled');
    $('#commit_video_editor').css('visibility', 'visible');
  }
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position));
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceImageComponentInVideoEditor(image_id, component, preview, position, duration) {
  var identifier = getVideoComponentIdentifier(position);
  // build preview
  var empty_preview = $('#empty_image_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_component_' + identifier + '_preview').replaceWith(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_image_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_component_' + identifier + '_cutter').replaceWith(empty_cutter);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  current_preview.attr('id', ('video_component_' + identifier + '_preview'));
  current_preview.html(preview);
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + identifier + '_cutter'));
  current_cutter.find('._old').html(secondsToDateString(duration));
  // edit component
  $('#' + position).removeClass('_video _image _text').addClass('_image');
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('image');
  var to_be_appended = fillVideoEditorSingleParameter('image_id', identifier, image_id);
  to_be_appended += fillVideoEditorSingleParameter('duration', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(position, duration);
}

function addVideoComponentInVideoEditor(video_id, webm, mp4, component, duration) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 186;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#info_container').data('last-component-id', next_position);
  // build preview
  var empty_preview = $('#empty_video_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_editor_preview_container').append(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_video_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_editor_cutters').append(empty_cutter);
  // build component
  var empty_component = $('#empty_video_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  if(videoEditorWithAudioTrack()) {
    current_preview.find('video').prop('muted', true);
  }
  current_preview.attr('id', ('video_component_' + next_position + '_preview'));
  current_preview.find('source[type="video/webm"]').attr('src', webm);
  current_preview.find('source[type="video/mp4"]').attr('src', mp4);
  current_preview.find('video').load();
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + next_position + '_cutter'));
  current_cutter.find('._video_editor_cutter_total_time').html(secondsToDateString(duration));
  current_cutter.find('._video_editor_cutter_selected_time').html(secondsToDateString(duration));
  current_cutter.data('to', duration);
  current_cutter.data('max-to', duration);
  initializeVideoInVideoEditorPreview(next_position);
  // edit component
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon ._left').html(next_position);
  current_component.find('._video_editor_component_hover').append(component);
  var to_be_appended = fillVideoEditorSingleParameter('type', next_position, 'video');
  to_be_appended += fillVideoEditorSingleParameter('video_id', next_position, video_id);
  to_be_appended += fillVideoEditorSingleParameter('from', next_position, 0);
  to_be_appended += fillVideoEditorSingleParameter('to', next_position, duration);
  to_be_appended += fillVideoEditorSingleParameter('position', next_position, next_position);
  current_component.find('._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions();
  resetVisibilityOfVideoEditorTransitions();
  if(!$('#video_editor_global_preview').hasClass('_enabled')) {
    $('#video_editor_global_preview').addClass('_enabled');
    $('#video_editor_global_preview a').removeClass('disabled');
    $('#commit_video_editor').css('visibility', 'visible');
  }
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position));
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceVideoComponentInVideoEditor(video_id, webm, mp4, component, position, duration) {
  var identifier = getVideoComponentIdentifier(position);
  // build preview
  var empty_preview = $('#empty_video_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_component_' + identifier + '_preview').replaceWith(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_video_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_component_' + identifier + '_cutter').replaceWith(empty_cutter);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  if(videoEditorWithAudioTrack()) {
    current_preview.find('video').prop('muted', true);
  }
  current_preview.attr('id', ('video_component_' + identifier + '_preview'));
  current_preview.find('source[type="video/webm"]').attr('src', webm);
  current_preview.find('source[type="video/mp4"]').attr('src', mp4);
  current_preview.find('video').load();
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + identifier + '_cutter'));
  current_cutter.find('._video_editor_cutter_total_time').html(secondsToDateString(duration));
  current_cutter.find('._video_editor_cutter_selected_time').html(secondsToDateString(duration));
  current_cutter.data('to', duration);
  current_cutter.data('max-to', duration);
  initializeVideoInVideoEditorPreview(identifier);
  // edit component
  $('#' + position).removeClass('_video _image _text').addClass('_video');
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('video');
  var to_be_appended = fillVideoEditorSingleParameter('video_id', identifier, video_id);
  to_be_appended += fillVideoEditorSingleParameter('from', identifier, 0);
  to_be_appended += fillVideoEditorSingleParameter('to', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(position, duration);
}

function addTextComponentInVideoEditor(component, content, duration, background_color, text_color) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 186;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#info_container').data('last-component-id', next_position);
  // build preview
  var empty_preview = $('#empty_text_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_editor_preview_container').append(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_text_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_editor_cutters').append(empty_cutter);
  // build component
  var empty_component = $('#empty_text_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  current_preview.attr('id', ('video_component_' + next_position + '_preview'));
  current_preview.removeClass('background_color_white').addClass('background_color_' + background_color);
  current_preview.find('p').removeClass('color_black').addClass('color_' + text_color);
  current_preview.find('p').html(content);
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + next_position + '_cutter'));
  current_cutter.find('._old').html(secondsToDateString(duration));
  // edit component
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon ._left').html(next_position);
  current_component.find('._video_editor_component_hover').append(component);
  $('#video_component_' + next_position + ' ._video_component_thumb ._text_content').html(content);
  $('#video_component_' + next_position + ' ._video_component_thumb ._text_content').removeClass('color_black').addClass('color_' + text_color);
  $('#video_component_' + next_position + ' ._video_component_thumb').removeClass('background_color_white').addClass('background_color_' + background_color);
  var to_be_appended = fillVideoEditorSingleParameter('type', next_position, 'text');
  to_be_appended += fillVideoEditorSingleParameter('content', next_position, content);
  to_be_appended += fillVideoEditorSingleParameter('duration', next_position, duration);
  to_be_appended += fillVideoEditorSingleParameter('background_color', next_position, background_color);
  to_be_appended += fillVideoEditorSingleParameter('text_color', next_position, text_color);
  to_be_appended += fillVideoEditorSingleParameter('position', next_position, next_position);
  current_component.find('._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions();
  resetVisibilityOfVideoEditorTransitions();
  if(!$('#video_editor_global_preview').hasClass('_enabled')) {
    $('#video_editor_global_preview').addClass('_enabled');
    $('#video_editor_global_preview a').removeClass('disabled');
    $('#commit_video_editor').css('visibility', 'visible');
  }
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position));
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceTextComponentInVideoEditor(component, content, position, duration, background_color, text_color) {
  var identifier = getVideoComponentIdentifier(position);
  // build preview
  var empty_preview = $('#empty_text_preview_for_video_editor').html();
  empty_preview = '<div id="temporary_empty_preview" ' + empty_preview.substr(empty_preview.indexOf('div') + 3, empty_preview.length);
  $('#video_component_' + identifier + '_preview').replaceWith(empty_preview);
  // build cutter
  var empty_cutter = $('#empty_text_cutter_for_video_editor').html();
  empty_cutter = '<div id="temporary_empty_cutter" ' + empty_cutter.substr(empty_cutter.indexOf('div') + 3, empty_cutter.length);
  $('#video_component_' + identifier + '_cutter').replaceWith(empty_cutter);
  // edit preview
  current_preview = $('#temporary_empty_preview');
  current_preview.attr('id', ('video_component_' + identifier + '_preview'));
  current_preview.removeClass('background_color_white').addClass('background_color_' + background_color);
  current_preview.find('p').removeClass('color_black').addClass('color_' + text_color);
  current_preview.find('p').html(content);
  // edit cutter
  current_cutter = $('#temporary_empty_cutter');
  current_cutter.attr('id', ('video_component_' + identifier + '_cutter'));
  current_cutter.find('._old').html(secondsToDateString(duration));
  // edit component
  $('#' + position).removeClass('_video _image _text').addClass('_text');
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  $('#' + position + ' ._video_component_thumb ._text_content').html(content);
  $('#' + position + ' ._video_component_thumb ._text_content').removeClass('color_black').addClass('color_' + text_color);
  $('#' + position + ' ._video_component_thumb').removeClass('background_color_white').addClass('background_color_' + background_color);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('text');
  var to_be_appended = fillVideoEditorSingleParameter('content', identifier, content);
  to_be_appended += fillVideoEditorSingleParameter('background_color', identifier, background_color);
  to_be_appended += fillVideoEditorSingleParameter('text_color', identifier, text_color);
  to_be_appended += fillVideoEditorSingleParameter('duration', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  // other things
  changeDurationVideoEditorComponent(position, duration);
}

function resetVideoEditorTextComponent() {
  $('#text_component_preview textarea').val($('#text_component_preview').data('placeholder-content'));
  $('#video_editor_mixed_gallery_container ._texts ._duration_selector input').val('');
  $('#text_component_preview').data('placeholder', true);
  var old_background_color = $('#text_component_preview').data('background-color');
  var old_text_color = $('#text_component_preview').data('text-color');
  switchTextComponentBackgroundColor(old_background_color, 'white');
  switchTextComponentTextColor(old_text_color, 'black');
}

function switchTextComponentBackgroundColor(old_color, new_color) {
  $('#text_component_preview').removeClass('background_color_' + old_color).addClass('background_color_' + new_color);
  $('._text_component_in_video_editor_background_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_background_color_selector .background_color_' + new_color).addClass('current');
  $('#text_component_preview').data('background-color', new_color);
}

function switchTextComponentTextColor(old_color, new_color) {
  $('#text_component_preview textarea').removeClass('color_' + old_color).addClass('color_' + new_color);
  $('._text_component_in_video_editor_text_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_text_color_selector .background_color_' + new_color).addClass('current');
  $('#text_component_preview').data('text-color', new_color);
}

function changeDurationVideoEditorComponent(component_id, new_duration) {
  var old_duration = $('#' + component_id).data('duration');
  var total_length = $('#info_container').data('total-length');
  total_length -= old_duration;
  total_length += new_duration;
  if($('._video_editor_component').length > 1) {
    if(old_duration == 0) {
      total_length += 1;
    }
    if(new_duration == 0) {
      total_length -= 1;
    }
  }
  $('#' + component_id).data('duration', new_duration);
  $('#' + component_id + ' ._video_component_icon ._right').html(secondsToDateString(new_duration));
  $('#info_container').data('total-length', total_length);
  $('#visual_video_editor_total_length').html(secondsToDateString(total_length));
}

function fillVideoEditorSingleParameter(input, identifier, value) {
  return '<input id="' + input + '_' + identifier + '" class="_video_component_input_' + input + '" type="hidden" value="' + value + '" name="' + input + '_' + identifier + '">';
}

function clearSpecificVideoEditorComponentParameters(component_id) {
  var huge_selector = '#' + component_id + ' ._video_component_input_content';
  huge_selector += ', #' + component_id + ' ._video_component_input_background_color';
  huge_selector += ', #' + component_id + ' ._video_component_input_text_color';
  huge_selector += ', #' + component_id + ' ._video_component_input_duration';
  huge_selector += ', #' + component_id + ' ._video_component_input_image_id';
  huge_selector += ', #' + component_id + ' ._video_component_input_video_id';
  huge_selector += ', #' + component_id + ' ._video_component_input_from';
  huge_selector += ', #' + component_id + ' ._video_component_input_to';
  $(huge_selector).remove();
}

function highlightAndUpdateVideoComponentIcon(component_id) {
  $('#' + component_id + ' ._video_component_icon').effect('highlight', {color: '#41A62A'}, 1500);
}

function startVideoEditorPreviewClipWithDelay(component_id) {
  setTimeout(function() {
    var obj = $('#' + component_id);
    if(obj.data('preview-selected') && !$('#' + component_id + '_preview').is(':visible')) {
      startVideoEditorPreviewClip(component_id);
    }
  }, 500);
}

function showVideoEditorCutter(component_id) {
  $('._video_editor_bottom_bar').css('visibility', 'hidden');
  $('#commit_video_editor').hide();
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#' + component_id + ' ._video_component_cutter_arrow').show('fade', {}, 250);
  $('#' + component_id + '_cutter').show('fade', {}, 250, function() {
    $('#video_editor_global_preview a').addClass('disabled');
    $('._video_component_transition').addClass('current');
    $('._video_editor_component:not(#' + component_id + ') ._video_editor_component_hover').addClass('selected');
    $('._video_component_icon').addClass('selected');
    $('#' + component_id + ' ._video_component_icon').removeClass('selected');
    $('._new_component_in_video_editor_hover').addClass('selected');
  });
}

function startVideoEditorPreviewClip(component_id) {
  $('._video_component_preview').hide();
  loadVideoComponentIfNotLoadedYet(component_id);
  $('#' + component_id + '_preview').show('fade', {}, 250);
}

function loadVideoComponentIfNotLoadedYet(component_id) {
  if(!$('#' + component_id + '_preview').data('loaded')) {
    var mp4 = $('#' + component_id + '_preview').data('mp4');
    var webm = $('#' + component_id + '_preview').data('webm');
    $('#' + component_id + '_preview video source[type="video/mp4"]').attr('src', mp4);
    $('#' + component_id + '_preview video source[type="video/webm"]').attr('src', webm);
    $('#' + component_id + '_preview video').load();
    $('#' + component_id + '_preview').data('loaded', true);
  }
}

function commitVideoComponentVideoCutter(identifier) {
  var from = $('#video_component_' + identifier + '_cutter').data('from');
  var to = $('#video_component_' + identifier + '_cutter').data('to');
  $('#video_component_' + identifier + ' ._video_component_input_from').val(from);
  $('#video_component_' + identifier + ' ._video_component_input_to').val(to);
  changeDurationVideoEditorComponent('video_component_' + identifier, to - from);
  if($('#video_component_' + identifier + '_cutter').data('changed')) {
    highlightAndUpdateVideoComponentIcon('video_component_' + identifier);
    $('#video_component_' + identifier + '_cutter').data('changed', false);
  }
}

function videoEditorWithAudioTrack() {
  return $('#audio_track_in_video_editor_input').val() != '';
}

function cutVideoComponentLeftSide(identifier, pos) {
  $('#video_component_' + identifier + '_cutter').data('from', pos);
  var new_duration = $('#video_component_' + identifier + '_cutter').data('to') - pos;
  $('#video_component_' + identifier + '_cutter ._video_editor_cutter_selected_time').html(secondsToDateString(new_duration));
}

function cutVideoComponentRightSide(identifier, pos) {
  $('#video_component_' + identifier + '_cutter').data('to', pos);
  var new_duration = pos - $('#video_component_' + identifier + '_cutter').data('from');
  $('#video_component_' + identifier + '_cutter ._video_editor_cutter_selected_time').html(secondsToDateString(new_duration));
}

function calculateVideoComponentStartSecondInVideoEditor(identifier) {
  var duration = 0;
  var stop = false;
  $('._video_editor_component').each(function(index) {
    if(getVideoComponentIdentifier($(this).attr('id')) == identifier) {
      stop = true;
    } else if(!stop) {
      duration += ($(this).data('duration') + 1);
    }
  });
  var cutter = $('#video_component_' + identifier + '_cutter');
  if(!cutter.hasClass('_mini_cutter')) {
    duration += (cutter.find('._media_player_slider').slider('value') - cutter.data('from'));
  }
  return duration;
}

function startVideoEditorGlobalPreview() {
  $('#video_editor_global_preview').data('in-use', true);
  var current_identifier = $('#video_editor_global_preview').data('current-component');
  var current_component = $('#video_component_' + current_identifier);
  var actual_audio_track_time = calculateVideoComponentStartSecondInVideoEditor(current_identifier) + current_component.data('current-preview-time');
  if(videoEditorWithAudioTrack() && actual_audio_track_time < $('#full_audio_track_placeholder_in_video_editor').data('duration')) {
    var audio_track = $('#video_editor_preview_container audio');
    if(media[0].error) {
      showLoadingMediaErrorPopup(audio_track[0].error.code, 'audio');
    } else {
      setCurrentTimeToMedia(audio_track, actual_audio_track_time);
      if(audio_track.readyState != 0) {
        audio_track[0].play();
      } else {
        audio_track.on('loadedmetadata', function() {
          audio_track[0].play();
        });
      }
    }
  }
  if(current_component.data('position') == getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186) + 1) {
    playVideoEditorComponent(current_component, false);
  } else {
    hideVideoEditorPreviewComponentProgressBar();
    playVideoEditorComponent(current_component, true);
  }
}

function getFirstVideoEditorComponent() {
  return $('._video_editor_component').first();
}

function getLastVideoEditorComponent() {
  var components = $('._video_editor_component');
  return $(components[components.length - 1]);
}

function playVideoEditorComponent(component, with_scroll) {
  if(with_scroll) {
    followPreviewComponentsWithHorizontalScrollInVideoEditor();
  }
  var identifier = getVideoComponentIdentifier(component.attr('id'));
  $('._video_component_transition').addClass('current');
  var next_component_to_load = component.next();
  if(next_component_to_load.hasClass('_video_editor_component')) {
    loadVideoComponentIfNotLoadedYet(next_component_to_load.attr('id'));
  }
  if(component.hasClass('_video')) {
    var video = $('#video_component_' + identifier + '_preview video');
    if(video[0].error) {
      showLoadingMediaErrorPopup(video[0].error.code, 'video');
      $('#video_editor_global_preview_pause').click();
    } else {
      if(video.readyState != 0) {
        video[0].play();
      } else {
        video.on('loadedmetadata', function() {
          video[0].play();
        });
      }
    }
  } else {
    automaticIncreaseVideoEditorPreviewTimer(component.data('current-preview-time') + 1, component.data('duration'), function() {
      var next_component = component.next();
      var next_identifier = getVideoComponentIdentifier(next_component.attr('id'));
      if(next_component.hasClass('_video_editor_component')) {
        increaseVideoEditorPreviewTimer(true);
        $('#video_editor_global_preview').data('current-component', getVideoComponentIdentifier(next_component.attr('id')));
        $('#video_component_' + identifier + '_preview').hide('fade', {}, 1000);
        component.find('._video_component_transition').removeClass('current');
        next_component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
        $('#video_component_' + next_identifier + '_preview').show('fade', {}, 1000, function() {
          hideVideoEditorPreviewComponentProgressBar();
          $('#video_component_' + identifier + ' ._video_component_icon ._right').html(secondsToDateString(0));
          if(!$('#video_editor_global_preview').data('in-use')) {
            $('._video_component_transition').addClass('current');
          }
          increaseVideoEditorPreviewTimer(false);
          component.find('._video_editor_component_hover, ._video_component_icon').addClass('selected');
          if($('#video_editor_global_preview').data('in-use')) {
            playVideoEditorComponent(next_component, true);
          } else {
            var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186);
            showVideoEditorPreviewComponentProgressBar(next_identifier, next_component.data('position') - how_many_hidden_to_left);
          }
        });
      } else {
        var first_component = getFirstVideoEditorComponent();
        selectVideoComponentInPreview(first_component);
        hideVideoEditorPreviewComponentProgressBar();
        if(videoEditorWithAudioTrack()) {
          $('#video_editor_preview_container audio')[0].pause();
        }
        $('#video_editor_global_preview_pause').trigger('click');
        if($('._video_editor_component').length > 5) {
          $('#media_elements_list_in_video_editor').jScrollPane().bind('panescrollstop', function() {
            showVideoEditorPreviewComponentProgressBar(getVideoComponentIdentifier(first_component.attr('id')), 1);
            $('#media_elements_list_in_video_editor').jScrollPane().unbind('panescrollstop');
          });
          $('#media_elements_list_in_video_editor').data('jsp').scrollToX(0, true, 500);
        } else {
          showVideoEditorPreviewComponentProgressBar(getVideoComponentIdentifier(first_component.attr('id')), 1);
        }
      }
    });
  }
}

function selectVideoComponentInPreview(component, time) {
  $('._video_component_preview').hide();
  $('#' + component.attr('id') + '_preview').show();
  $('._video_editor_component_hover, ._video_component_icon').addClass('selected');
  component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
  if(time == undefined) {
    time = 0;
  }
  setVisualTimesVideoEditorPreview(component, time);
}

function setVisualTimesVideoEditorPreview(component, time) {
  var identifier = getVideoComponentIdentifier(component.attr('id'));
  var global_time = calculateVideoComponentStartSecondInVideoEditor(identifier) + time;
  $('#visual_video_editor_current_time').html(secondsToDateString(global_time));
  $('#video_editor_global_preview').data('current-time', global_time);
  $('#video_editor_global_preview').data('current-component', identifier);
  $('._video_editor_component').each(function() {
    var my_identifier = getVideoComponentIdentifier($(this).attr('id'));
    if(my_identifier == identifier) {
      $(this).find('._video_component_icon ._right').html(secondsToDateString(time));
      $(this).data('current-preview-time', time);
      if($('#video_component_' + my_identifier + '_preview video').length > 0 && $('#video_component_' + my_identifier + '_preview').data('loaded')) {
        setCurrentTimeToMedia($('#video_component_' + my_identifier + '_preview video'), $('#video_component_' + my_identifier + '_cutter').data('from') + time);
      }
    } else {
      $(this).find('._video_component_icon ._right').html(secondsToDateString(0));
      $(this).data('current-preview-time', 0);
      if($('#video_component_' + my_identifier + '_preview video').length > 0 && $('#video_component_' + my_identifier + '_preview').data('loaded')) {
        setCurrentTimeToMedia($('#video_component_' + my_identifier + '_preview video'), $('#video_component_' + my_identifier + '_cutter').data('from'));
      }
    }
  });
}

function getInitialPointOfVideoEditorComponent(component) {
  resp = 0;
  if(component.hasClass('_video')) {
    resp = $('#' + component.attr('id') + '_cutter').data('from');
  }
  return resp;
}

function getVideoComponentIdentifier(item_id) {
  var resp = item_id.split('_');
  if($('#' + item_id).hasClass('_video_editor_component')) {
    return resp[resp.length - 1];
  } else {
    return resp[resp.length - 2];
  }
}

function automaticIncreaseVideoEditorPreviewTimer(time, total_length, callback) {
  setTimeout(function() {
    if($('#video_editor_global_preview').data('in-use')) {
      if(time < total_length) {
        increaseVideoEditorPreviewTimer(true);
        automaticIncreaseVideoEditorPreviewTimer(time + 1, total_length, callback);
      } else {
        callback();
      }
    }
  }, 1000);
}

function increaseVideoEditorPreviewTimer(with_component) {
  var data_container = $('#video_editor_global_preview');
  var global_time = data_container.data('current-time');
  $('#visual_video_editor_current_time').html(secondsToDateString(global_time + 1));
  data_container.data('current-time', global_time + 1);
  if(with_component) {
    var identifier = data_container.data('current-component');
    var component = $('#video_component_' + identifier);
    var component_time = component.data('current-preview-time');
    component.find('._video_component_icon ._right').html(secondsToDateString(component_time + 1));
    component.data('current-preview-time', component_time + 1);
    if($('#video_editor_preview_slider').is(':visible')) {
      $('#video_editor_preview_slider').slider('value', component_time + 1);
    }
  }
}

function showVideoEditorPreviewArrowToComponents() {
  if(getVideoComponentIdentifier(getFirstVideoEditorComponent().attr('id')) != $('#video_editor_global_preview').data('current-component')) {
    $('#video_editor_preview_go_to_left_component').show();
  } else {
    $('#video_editor_preview_go_to_left_component').hide();
  }
  if(getVideoComponentIdentifier(getLastVideoEditorComponent().attr('id')) != $('#video_editor_global_preview').data('current-component')) {
    $('#video_editor_preview_go_to_right_component').show();
  } else {
    $('#video_editor_preview_go_to_right_component').hide();
  }
}

function openPreviewModeInVideoEditor() {
  var first_component = getFirstVideoEditorComponent();
  var first_identifier = getVideoComponentIdentifier(first_component.attr('id'));
  $('._video_component_preview').hide();
  $('#full_audio_track_placeholder_in_video_editor, #empty_audio_track_placeholder_in_video_editor').css('visibility', 'hidden');
  $('#visual_video_editor_current_time').css('visibility', 'visible').css('color', 'white');
  $('#visual_video_editor_total_length').css('color', '#787575');
  $('#video_editor_global_preview').hide();
  $('#video_editor_global_preview_pause').show();
  $('#commit_video_editor').hide();
  $('#video_editor_box_ghost').show();
  $('._video_editor_component_hover, ._video_component_icon').addClass('selected');
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#add_new_video_component').hide();
  $('#add_new_video_component').prev().find('._video_component_transition').hide();
  $('#add_new_video_component').prev().css('width', '159');
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) - 184;
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#video_editor_preview_slider_box_ghost').show();
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true,
    initialHorizontalStyles: 'visibility:hidden'
  });
  $('._video_component_transition').addClass('current');
  setVisualTimesVideoEditorPreview(first_component, 0);
  $('#video_editor_preview_container ._loader').show();
  $('#video_editor_global_preview_pause a').addClass('disabled');
  setTimeout(function() {
    $('#video_editor_global_preview_pause').addClass('_enabled');
    $('#video_editor_global_preview_pause a').removeClass('disabled');
    $('#video_editor_preview_container ._loader').hide();
    $('#video_component_' + first_identifier + '_preview').show();
    showVideoEditorPreviewComponentProgressBar(first_identifier, 1);
    first_component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
    startVideoEditorGlobalPreview();
  }, 1500);
}

function followPreviewComponentsWithHorizontalScrollInVideoEditor() {
  var jsp_handler = $('#media_elements_list_in_video_editor').data('jsp');
  var identifier = $('#video_editor_global_preview').data('current-component');
  var pos = $('#video_component_' + identifier).data('position');
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186);
  var movement = 0;
  var whole_movement = 0;
  if(pos - how_many_hidden_to_left == 5) {
    movement = calculateCorrectMovementHorizontalScrollRight(how_many_hidden_to_left, 4, $('._video_editor_component').length, 5);
    if(movement > 0) {
      whole_movement = (how_many_hidden_to_left + movement) * 186;
    }
  } else if(pos - how_many_hidden_to_left == 6) {
    movement = calculateCorrectMovementHorizontalScrollRight(how_many_hidden_to_left, 5, $('._video_editor_component').length, 5);
    if(movement > 0) {
      whole_movement = (how_many_hidden_to_left + movement) * 186;
    }
  } else if(pos == how_many_hidden_to_left) {
    movement = calculateCorrectMovementHorizontalScrollLeft(how_many_hidden_to_left, 5);
    if(movement > 0) {
      whole_movement = (how_many_hidden_to_left - movement) * 186;
    }
  } else if(pos == how_many_hidden_to_left + 1) {
    movement = calculateCorrectMovementHorizontalScrollLeft(how_many_hidden_to_left, 4);
    if(movement > 0) {
      whole_movement = (how_many_hidden_to_left - movement) * 186;
    }
  }
  if(movement != 0) {
    $('#video_editor_global_preview').data('arrows', false);
    $('#media_elements_list_in_video_editor').jScrollPane().bind('panescrollstop', function() {
      $('#video_editor_global_preview').data('arrows', true);
      showVideoEditorPreviewComponentProgressBar(identifier, pos - (whole_movement / 186));
      $('#media_elements_list_in_video_editor').jScrollPane().unbind('panescrollstop');
    });
    jsp_handler.scrollToX(whole_movement, true, (1000 * movement) / 4);
  } else {
    showVideoEditorPreviewComponentProgressBar(identifier, pos - how_many_hidden_to_left);
  }
}

function showVideoEditorPreviewComponentProgressBar(identifier, position) {
  var component = $('#video_component_' + identifier);
  var tool = $('#video_editor_preview_slider');
  if(!tool.is(':visible')) {
    tool.slider({
      min: 0,
      max: component.data('duration'),
      value: component.data('current-preview-time'),
      range: 'min',
      stop: function(event, ui) {
        var my_value = ui.value;
        if(my_value == component.data('duration')) {
          my_value = component.data('duration') - 1;
          tool.slider('value', my_value);
        }
        setVisualTimesVideoEditorPreview(component, my_value);
      }
    });
    tool.show();
    tool.css('left', (position - 1) * 186 + 3);
  }
}

function hideVideoEditorPreviewComponentProgressBar() {
  $('#video_editor_preview_slider').slider('destroy');
  $('#video_editor_preview_slider').hide();
}
