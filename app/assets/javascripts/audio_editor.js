function resizeLastComponentInAudioEditor() {
  $('._audio_editor_component._last').last().removeClass('_last')
  $('._audio_editor_component').last().addClass('_last');
}

function selectAudioEditorComponent(component) {
  deselectAllAudioEditorComponents();
  component.addClass('_selected');
  component.find('._content').addClass('current');
  component.find('._box_ghost').hide();
  component.find('._sort_handle').addClass('current');
  component.find('._player_content').css('opacity', '1');
  component.find('._controls').css('visibility', 'visible');
}

function deselectAllAudioEditorComponents() {
  var selected_component = $('._audio_editor_component._selected');
  if(selected_component.length > 0) {
    var pause = selected_component.find('._media_player_pause_in_audio_editor_preview');
    if(pause.css('display') == 'block') {
      pause.click();
    }
    var identifier = selected_component.attr('id');
    identifier = identifier[identifier.length - 1];
    selectAudioEditorCursor(identifier);
  }
  $('._audio_editor_component._selected ._content').removeClass('current');
  $('._audio_editor_component._selected ._box_ghost').show();
  $('._audio_editor_component._selected ._sort_handle').removeClass('current');
  $('._audio_editor_component._selected ._player_content').css('opacity', '0.2');
  $('._audio_editor_component._selected ._controls').css('visibility', 'hidden');
  $('._audio_editor_component._selected').removeClass('_selected');
}

function initializeAudioEditor() {
  resizeLastComponentInAudioEditor();
  $('#audio_editor_timeline').jScrollPane({
    autoReinitialise: true
  });
  $('#audio_editor_timeline .jspPane').sortable({
    scroll: true,
    handle: '._sort_handle',
    axis: 'y',
    cursor: 'move',
    start: function(event, ui) {
      selectAudioEditorComponent($(ui.item));
    },
    stop: function(event, ui) {
      var my_item = $(ui.item);
      resizeLastComponentInAudioEditor();
      var boolean1 = (my_item.next().length == 0);
      var boolean2 = (my_item.data('position') != $('._audio_editor_component').length);
      var boolean3 = (my_item.next().data('position') != (my_item.data('position') + 1));
      if(boolean1 && boolean2 || !boolean1 && boolean3) {
        reloadAudioEditorComponentPositions();
        $('#audio_editor_timeline').effect('highlight', {color: '#41A62A'}, 1000);
      }
    }
  });
}

function reloadAudioEditorComponentPositions() {
  var components = $('._audio_editor_component');
  components.each(function(index) {
    $(this).data('position', (index + 1));
    $(this).find('._audio_component_input_position').val(index + 1);
    $(this).find('._audio_component_icon').html(index + 1);
  });
}

function changeDurationAudioEditorComponent(component, new_duration) {
  var old_duration = component.data('duration');
  var total_length = $('#info_container').data('total-length');
  total_length -= old_duration;
  total_length += new_duration;
  component.data('duration', new_duration);
  $('#info_container').data('total-length', total_length);
  $('#visual_audio_editor_total_length').html(secondsToDateString(total_length));
}

function removeAudioEditorComponent(component) {
  if(component.hasClass('_selected')) {
    component.find('._media_player_pause_in_audio_editor_preview').click();
  }
  component.hide('fade', {}, 500, function() {
    changeDurationAudioEditorComponent(component, 0);
    $(this).remove();
    reloadAudioEditorComponentPositions();
    if($('._audio_editor_component').length == 0) {
      disableCommitAndPreviewInAudioEditor();
    }
    resizeLastComponentInAudioEditor();
  });
}

function disableCommitAndPreviewInAudioEditor() {
  $('#empty_audio_editor').show();
  $('#commit_audio_editor').hide();
  $('#start_audio_editor_preview').addClass('disabled');
}

function enableCommitAndPreviewInAudioEditor() {
  $('#empty_audio_editor').hide();
  $('#commit_audio_editor').show();
  $('#start_audio_editor_preview').removeClass('disabled');
}

function setToZeroAllZIndexesInAudioEditor() {
  $('._audio_editor_component ._remove').css('z-index', 0);
  $('._audio_editor_component ._box_ghost').css('z-index', 0);
  $('._audio_editor_component ._media_player_slider_disabler').css('z-index', 0);
  $('._audio_editor_component ._double_slider').css('z-index', 0);
  $('._audio_editor_component ._under_double_slider').css('z-index', 0);
  $('._audio_editor_component ._media_player_slider').css('z-index', 0);
}

function setBackAllZIndexesInAudioEditor() {
  $('._audio_editor_component ._remove').css('z-index', 101);
  $('._audio_editor_component ._box_ghost').css('z-index', 100);
  $('._audio_editor_component ._media_player_slider_disabler').css('z-index', 99);
  $('._audio_editor_component ._double_slider').css('z-index', 98);
  $('._audio_editor_component ._under_double_slider').css('z-index', 97);
  $('._audio_editor_component ._media_player_slider').css('z-index', 96);
}

function showGalleryInAudioEditor() {
  $('._audio_editor_bottom_bar').hide();
  $('#audio_editor_gallery_container').show();
  setToZeroAllZIndexesInAudioEditor();
  calculateNewPositionGalleriesInAudioEditor();
}

function showCommitAudioEditorForm(scope) {
  $('._audio_editor_bottom_bar').hide();
  $('#audio_editor #form_info_' + scope + '_media_element_in_editor').show();
  setToZeroAllZIndexesInAudioEditor();
}

function hideCommitAudioEditorForm(scope) {
  $('._audio_editor_bottom_bar').show();
  $('#audio_editor #form_info_' + scope + '_media_element_in_editor').hide();
  setBackAllZIndexesInAudioEditor();
}

function calculateNewPositionGalleriesInAudioEditor() {
  $('#audio_editor_gallery_container').css('left', (($(window).width() - 940) / 2) + 'px');
}

function closeGalleryInAudioEditor() {
  $('._audio_editor_bottom_bar').show();
  $('#audio_editor_gallery_container').hide('fade', {}, 250, function() {
    setBackAllZIndexesInAudioEditor();
  });
}

function cutAudioComponentLeftSide(identifier, pos) {
  var component = $('#audio_component_' + identifier);
  var new_duration = component.data('to') - pos;
  component.data('from', pos);
  component.find('._cutter_from').html(secondsToDateString(pos));
  component.find('._audio_component_input_from').val(pos);
  changeDurationAudioEditorComponent(component, new_duration);
}

function cutAudioComponentRightSide(identifier, pos) {
  var component = $('#audio_component_' + identifier);
  var new_duration = pos - component.data('from');
  component.data('to', pos);
  component.find('._cutter_to').html(secondsToDateString(pos));
  component.find('._audio_component_input_to').val(pos);
  changeDurationAudioEditorComponent(component, new_duration);
}

function deselectAllAudioEditorCursors(id) {
  $('#audio_component_' + id + ' .ui-slider-handle').removeClass('selected');
  $('#audio_component_' + id + ' ._cutter_from, #audio_component_' + id + ' ._cutter_to, #audio_component_' + id + ' ._current_time').removeClass('selected');
}

function selectAudioEditorLeftHandle(id) {
  deselectAllAudioEditorCursors(id);
  $($('#audio_component_' + id + ' ._double_slider .ui-slider-handle')[0]).addClass('selected');
  $('#audio_component_' + id + ' ._cutter_from').addClass('selected');
}

function selectAudioEditorRightHandle(id) {
  deselectAllAudioEditorCursors(id);
  $($('#audio_component_' + id + ' ._double_slider .ui-slider-handle')[1]).addClass('selected');
  $('#audio_component_' + id + ' ._cutter_to').addClass('selected');
}

function selectAudioEditorCursor(id) {
  deselectAllAudioEditorCursors(id);
  $('#audio_component_' + id + ' ._media_player_slider .ui-slider-handle').addClass('selected');
  $('#audio_component_' + id + ' ._current_time').addClass('selected');
}

function addComponentInAudioEditor(audio_id, ogg, mp3, duration, title) {
  var next_position = $('#info_container').data('last-component-id') + 1;
  var selected_component = $('._audio_editor_component._selected');
  $('#info_container').data('last-component-id', next_position);
  var empty_component = $($('#empty_component_for_audio_editor').html());
  empty_component.attr('id', ('audio_component_' + next_position));
  empty_component.find('source[type="audio/ogg"]').attr('src', ogg);
  empty_component.find('source[type="audio/mp3"]').attr('src', mp3);
  empty_component.data('duration', 0);
  empty_component.data('from', 0);
  empty_component.data('to', duration);
  empty_component.data('max-to', duration);
  empty_component.find('._title').html(title);
  empty_component.removeClass('_audio_editor_empty_component').addClass('_audio_editor_component');
  empty_component.find('._current_time').html(secondsToDateString(0));
  empty_component.find('._total_length').html(secondsToDateString(duration));
  empty_component.find('._cutter_from').html(secondsToDateString(0));
  empty_component.find('._cutter_to').html(secondsToDateString(duration));
  var to_be_appended = fillAudioEditorSingleParameter('audio_id', next_position, audio_id);
  to_be_appended += fillAudioEditorSingleParameter('from', next_position, 0);
  to_be_appended += fillAudioEditorSingleParameter('to', next_position, duration);
  to_be_appended += fillAudioEditorSingleParameter('position', next_position, next_position);
  if(selected_component.length == 0) {
    $('#audio_editor_timeline .jspPane').append(empty_component);
  } else {
    selected_component.after(empty_component);
  }
  empty_component.append(to_be_appended);
  empty_component.find('audio').load();
  initializeAudioEditorCutter(next_position);
  reloadAudioEditorComponentPositions(empty_component);
  changeDurationAudioEditorComponent(empty_component, duration);
  if(selected_component.length == 0) {
    resizeLastComponentInAudioEditor();
  }
  if($('._audio_editor_component').length == 1) {
    enableCommitAndPreviewInAudioEditor();
  }
  setTimeout(function() {
    scrollToFirstSelectedAudioEditorComponent();
    selectAudioEditorComponent(empty_component);
    empty_component.find('._title').effect('highlight', {color: '#41A62A'}, 1000);
  }, 500);
}

function fillAudioEditorSingleParameter(input, identifier, value) {
  return '<input id="' + input + '_' + identifier + '" class="_audio_component_input_' + input + '" type="hidden" value="' + value + '" name="' + input + '_' + identifier + '">';
}

function scrollToFirstSelectedAudioEditorComponent() {
  var selected_component = $('._audio_editor_component._selected');
  var scroll_pain = $('#audio_editor_timeline');
  if(selected_component.length == 0) {
    scroll_pain.data('jsp').scrollToPercentY(100, true)
  } else {
    scroll_pain.data('jsp').scrollToY((selected_component.data('position') - 1) * 113, true);
  }
}

function enterAudioEditorPreviewMode() {
  
}

function leaveAudioEditorPreviewMode() {
  
}
