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

function showVideoEditorComponentPreview(component_id) {
  
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
  $('#video_editor_' + type + '_gallery_container').show();
  $('._video_editor_bottom_bar').hide();
  calculateNewPositionGalleriesInVideoEditor();
  $('._video_editor_component_menu').hide();
}

function closeGalleryInVideoEditor(type) {
  $('#video_editor_' + type + '_gallery_container').hide('fade', {}, 250, function() {
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
    $('#' + $(this).attr('id') + ' ._video_component_input_position').val(index + 1);
    var counter_html = $('#' + $(this).attr('id') + ' ._video_component_icon').html();
    counter_html = counter_html.substr(counter_html.indexOf('<div'), counter_html.length);
    $('#' + $(this).attr('id') + ' ._video_component_icon').html((index + 1) + counter_html);
  });
  $('#add_new_video_component ._component_counter').html(components.length + 1);
}

function addImageComponentInVideoEditor(image_id, component, duration) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 187;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#info_container').data('last-component-id', next_position);
  var empty_component = $('#empty_image_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon').html(next_position + '<div class="photoIcon"></div>');
  $('#add_new_video_component ._component_counter').html(next_position + 1);
  current_component.find('._video_editor_component_hover').append(component);
  var to_be_appended = fillVideoEditorSingleParameter('type', next_position, 'image');
  to_be_appended += fillVideoEditorSingleParameter('image_id', next_position, image_id);
  to_be_appended += fillVideoEditorSingleParameter('duration', next_position, duration);
  to_be_appended += fillVideoEditorSingleParameter('position', next_position, next_position);
  current_component.find('._video_editor_component_hover').append(to_be_appended);
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions();
  resetVisibilityOfVideoEditorTransitions();
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position), 'photoIcon');
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceImageComponentInVideoEditor(image_id, component, position, duration) {
  var identifier = position.split('_');
  identifier = identifier[identifier.length - 1];
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('image');
  var to_be_appended = fillVideoEditorSingleParameter('image_id', identifier, image_id);
  to_be_appended += fillVideoEditorSingleParameter('duration', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  changeDurationVideoEditorComponent(position, duration);
}

function addVideoComponentInVideoEditor(video_id, component, duration) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 187;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#info_container').data('last-component-id', next_position);
  var empty_component = $('#empty_video_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon').html(next_position + '<div class="videoIcon"></div>');
  $('#add_new_video_component ._component_counter').html(next_position + 1);
  current_component.find('._video_editor_component_hover').append(component);
  var to_be_appended = fillVideoEditorSingleParameter('type', next_position, 'video');
  to_be_appended += fillVideoEditorSingleParameter('video_id', next_position, video_id);
  to_be_appended += fillVideoEditorSingleParameter('from', next_position, 0);
  to_be_appended += fillVideoEditorSingleParameter('to', next_position, duration);
  to_be_appended += fillVideoEditorSingleParameter('position', next_position, next_position);
  current_component.find('._video_editor_component_hover').append(to_be_appended);
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions()
  resetVisibilityOfVideoEditorTransitions();
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position), 'videoIcon');
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceVideoComponentInVideoEditor(video_id, component, position, duration) {
  var identifier = position.split('_');
  identifier = identifier[identifier.length - 1];
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('video');
  var to_be_appended = fillVideoEditorSingleParameter('video_id', identifier, video_id);
  to_be_appended += fillVideoEditorSingleParameter('from', identifier, 0);
  to_be_appended += fillVideoEditorSingleParameter('to', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  changeDurationVideoEditorComponent(position, duration);
}

function addTextComponentInVideoEditor(component, content, duration, background_color, text_color) {
  $('._new_component_in_video_editor_hover a').removeClass('current');
  var next_position = $('#info_container').data('last-component-id') + 1;
  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 187;
  $('#media_elements_list_in_video_editor').data('jsp').destroy();
  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('#info_container').data('last-component-id', next_position);
  var empty_component = $('#empty_text_component_for_video_editor').html();
  empty_component = '<div id="temporary_empty_component" ' + empty_component.substr(empty_component.indexOf('div') + 3, empty_component.length);
  $('#add_new_video_component').before(empty_component);
  current_component = $('#temporary_empty_component');
  current_component.attr('id', ('video_component_' + next_position));
  current_component.removeClass('_video_editor_empty_component').addClass('_video_editor_component');
  current_component.data('duration', 0);
  current_component.data('position', next_position);
  current_component.find('._video_component_icon').html(next_position + '<div class="textIcon"></div>');
  $('#add_new_video_component ._component_counter').html(next_position + 1);
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
  changeDurationVideoEditorComponent(('video_component_' + next_position), duration);
  reloadVideoEditorComponentPositions()
  resetVisibilityOfVideoEditorTransitions();
  setTimeout(function() {
    highlightAndUpdateVideoComponentIcon(('video_component_' + next_position), 'textIcon');
    $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(100, true);
  }, 1100);
}

function replaceTextComponentInVideoEditor(component, content, position, duration, background_color, text_color) {
  var identifier = position.split('_');
  identifier = identifier[identifier.length - 1];
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
  $('#' + component_id).data('duration', new_duration);
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

function highlightAndUpdateVideoComponentIcon(component_id, icon_class) {
  $('#' + component_id + ' ._video_component_icon div').removeClass('textIcon videoIcon photoIcon').addClass(icon_class);
  $('#' + component_id + ' ._video_component_icon').effect('highlight', {color: '#41A62A'}, 1500);
}
