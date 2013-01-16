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
      if($('#' + my_item.attr('id') + '_preview').css('display') == 'none') {
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

function closeGenericVideoComponentCutter() {
  $('._video_component_cutter_arrow').hide('fade', {}, 250);
  $('._video_component_cutter').hide('fade', {}, 250, function() {
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

function startCacheLoop() {
  $('#info_container').data('save-cache', true);
  saveCacheLoop();
}

function stopCacheLoop() {
  $('#info_container').data('save-cache', false);
}

function saveCacheLoop() {
  var time = $('#popup_parameters_container').data('cache-time');
  if($('#info_container').data('save-cache')) {
    $('#video_editor_form').submit();
    setTimeout(function() {
      saveCacheLoop();
    }, time);
  }
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
  if($('#video_editor_mixed_gallery_container ' + type).css('display') == 'none') {
    var big_selector = '#video_editor_mixed_gallery_container ._videos, #video_editor_mixed_gallery_container ._images, #video_editor_mixed_gallery_container ._texts';
    $(big_selector).each(function() {
      if($(this).css('display') == 'block') {
        big_selector = this;
      }
    });
    $(big_selector).hide();
    if(type == 'text') {
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
  $('#text_component_preview textarea').val($('#popup_captions_container').data('text-component-placeholder-in-video-editor'));
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
    if(obj.data('preview-selected') && $('#' + component_id + '_preview').css('display') == 'none') {
      startVideoEditorPreviewClip(component_id);
    }
  }, 500);
}

function showVideoEditorCutter(component_id) {
  $('._video_editor_bottom_bar').css('visibility', 'hidden');
  $('#media_elements_list_in_video_editor .jspHorizontalBar').css('visibility', 'hidden');
  $('#' + component_id + ' ._video_component_cutter_arrow').show('fade', {}, 250);
  $('#' + component_id + '_cutter').show('fade', {}, 250, function() {
    $('._video_component_transition').addClass('current');
    $('._video_editor_component:not(#' + component_id + ') ._video_editor_component_hover').addClass('selected');
    $('._video_component_icon').addClass('selected');
    $('#' + component_id + ' ._video_component_icon').removeClass('selected');
    $('._new_component_in_video_editor_hover').addClass('selected');
  });
}

function startVideoEditorPreviewClip(component_id) {
  $('._video_component_preview').hide();
  $('#' + component_id + '_preview').show('fade', {}, 250);
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
    duration += $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value');
  }
  return duration;
}





// TODO TODO TODO 





// questa funzione serve per filtrare i parametri rimasti dall'ultima pausa: se ho fatto modifiche che mi fanno perdere il punto, tipo
// eliminazione della componente su cui avevo fatto pausa, o cose analoghe; la funzione va chiamata con preview già vuota
// è chiamata con la preview attuale già visibile, e con current_component e current_time già settati
function startVideoEditorGlobalPreview(times_already_set) {
  $('#video_editor_global_preview').data('in-use', true); // (1) setto che sto facendo funzionare la preview
  var current_identifier = $('#video_editor_global_preview').data('current-component');
  var current_component = $('#video_component_' + current_identifier);
  var current_time = $('#video_editor_global_preview').data('current-time'); // questo è il tempo dentro la componente attuale
  if(!times_already_set) { // (2) faccio questa operazione solo se non ho già settato a 0 i tempi nel click da cui chiamo questa funzione
    setVisualTimesVideoEditorPreview(current_component, current_time); // qui non setto il cursore, ma riempio solo le labels dei tempi
  }
  var actual_audio_track_time = calculateVideoComponentStartSecondInVideoEditor(current_identifier) + current_time;
  // (3) se c'è l'audio di sottofondo, lo faccio partire
  if(videoEditorWithAudioTrack() && actual_audio_track_time < $('#full_audio_track_placeholder_in_video_editor').data('duration')) {
    var audio_track = $('#video_editor_preview_container audio');
    setCurrentTimeToMedia(audio_track, actual_audio_track_time);
    if(audio_track.readyState != 0) {
      audio_track[0].play();
    } else {
      audio_track.on('loadedmetadata', function() {
        audio_track[0].play();
      });
    }
  }
  
  // TODO manca far partire il contatore di tempo che aggiorna tutto!
  
  // (4) faccio partire la componente selezionata
  playVideoEditorComponent(current_component, current_time);
}

function getFirstVideoEditorComponent() {
  return $($('._video_editor_component')[0]);
}

// funzione ricorsiva; si suppone che le altre componenti siano già spente, e la preview già visibile, se è un video già posizionata al punto giusto
// current_time  da considerarsi relativo al punto '0' della componente selezionata, non all'effettiva durata del video
function playVideoEditorComponent(component, start_time) {
  component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
  
  if(component.hasClass('_video')) {
    
  } else {
    $('#video_component_' + identifier + '_preview').show();
    setTimeout(function() {
      var next_component = component.next();
      if(next_component.hasClass('_video_editor_component')) {
        $('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
        component.find('._video_component_transition').removeClass('current');
        component.find('._video_component_preview').hide('fade', {}, 1000);
        $('._video_editor_component_hover, ._video_component_icon').addClass('selected');
        next_component.find('._video_component_preview').show('fade', {}, 1000, function() {
          playVideoEditorComponent(next_component, getInitialPointOfVideoEditorComponent(next_component));
        });
      } else {
// TODO        stop
      }
    }, component.data('duration'));
  }
  

  
}

function setVisualTimesVideoEditorPreview(component, time) {
  var identifier = getVideoComponentIdentifier(component.attr('id'));
  // qui sotto aggiungo 'time' perché nella funzione che calcola il tempo viene sommato prendendolo dal valore del cutter, che qui non è preso in considerazione
  $('#visual_video_editor_current_time').html(secondsToDateString(calculateVideoComponentStartSecondInVideoEditor(identifier) + time));
  var start = false;
  $('._video_editor_component').each(function() {
    if(getVideoComponentIdentifier($(this).attr('id')) == identifier) {
      $(this).find('._video_component_icon ._right').html(secondsToDateString(time));
      start = true;
    } else if(start) {
      $(this).find('._video_component_icon ._right').html(secondsToDateString(0));
    } else {
      $(this).find('._video_component_icon ._right').html(secondsToDateString($(this).data('duration')));
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

function generalTimerVideoEditorPreview(time, total_length) {
  setTimeout(function() {
    if($('#video_editor_global_preview').data('in-use') && time <= total_length) {
      $('#visual_video_editor_current_time').html(secondsToDateString(time));
      generalTimerVideoEditorPreview(time + 1, total_length);
    }
  }, 1000);
}
