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
  selectAudioEditorCursor(getAudioComponentIdentifier(component));
}

function deselectAllAudioEditorComponents() {
  var selected_component = $('._audio_editor_component._selected');
  if(selected_component.length > 0) {
    var pause = selected_component.find('._media_player_pause_in_audio_editor_preview');
    if(pause.is(':visible')) {
      pause.click();
    }
    deselectAllAudioEditorCursors(getAudioComponentIdentifier(selected_component));
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
        $('._audio_editor_component ._title').effect('highlight', {color: '#41A62A'}, 1000);
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
  $('#rewind_audio_editor_preview').addClass('disabled');
}

function enableCommitAndPreviewInAudioEditor() {
  $('#empty_audio_editor').hide();
  $('#commit_audio_editor').show();
  $('#start_audio_editor_preview').removeClass('disabled');
  $('#rewind_audio_editor_preview').removeClass('disabled');
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
  $('#audio_component_' + id + ' ._double_slider .ui-slider-handle').first().addClass('selected');
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

function scrollToFirstSelectedAudioEditorComponent(callback) {
  var selected_component = $('._audio_editor_component._selected');
  var scroll_pain = $('#audio_editor_timeline');
  if(scroll_pain.find('.jspVerticalBar').length == 0) {
    if(callback != undefined) {
      callback();
    }
    return;
  }
  if(selected_component.length == 0) {
    if($('#info_container').data('in-preview')) {
      if(scroll_pain.data('jsp').getPercentScrolledY() != 0) {
        if(callback != undefined) {
          scroll_pain.jScrollPane().bind('panescrollstop', function() {
            callback();
            scroll_pain.jScrollPane().unbind('panescrollstop');
          });
        }
        scroll_pain.data('jsp').scrollToPercentY(0, true);
      } else if(callback != undefined) {
        callback();
      }
    } else {
      if(scroll_pain.data('jsp').getPercentScrolledY() != 1) {
        if(callback != undefined) {
          scroll_pain.jScrollPane().bind('panescrollstop', function() {
            callback();
            scroll_pain.jScrollPane().unbind('panescrollstop');
          });
        }
        scroll_pain.data('jsp').scrollToPercentY(100, true);
      } else if(callback != undefined) {
        callback();
      }
    }
  } else {
    var scroll_target = (selected_component.data('position') - 1) * 113;
    if(scroll_pain.data('jsp').getContentPositionY() != scroll_target) {
      if(callback != undefined) {
        scroll_pain.jScrollPane().bind('panescrollstop', function() {
          callback();
          scroll_pain.jScrollPane().unbind('panescrollstop');
        });
      }
      scroll_pain.data('jsp').scrollToY(scroll_target, true);
    } else if(callback != undefined) {
      callback();
    }
  }
}

function enterAudioEditorPreviewMode() {
  $('#info_container').data('in-preview', true);
  $('#audio_editor_box_ghost').show();
  $('#commit_audio_editor').hide();
  $('#add_new_audio_component_in_audio_editor').addClass('disabled');
  $('#start_audio_editor_preview').addClass('disabled');
  $('#rewind_audio_editor_preview').addClass('disabled');
  scrollToFirstSelectedAudioEditorComponent(function() {
    $('#audio_editor_timeline .jspVerticalBar').css('visibility', 'hidden');
    var current_global_preview_time = getAudioEditorGlobalPreviewTime();
    $('#info_container').data('current-preview-time', current_global_preview_time);
    var selected_component = $('._audio_editor_component._selected');
    if(selected_component.length == 0) {
      selected_component = $('._audio_editor_component').first();
    }
    selected_component = $('#' + selected_component.attr('id'));
    deselectAllAudioEditorComponents();
    switchAudioComponentsToPreviewMode();
    $('#visual_audio_editor_current_time').show();
    $('#visual_audio_editor_current_time').html(secondsToDateString(current_global_preview_time));
    $('#start_audio_editor_preview').hide();
    $('#start_audio_editor_preview').removeClass('disabled');
    $('#stop_audio_editor_preview').show();
    $('#visual_audio_editor_total_length').css('color', '#787575');
    $('#visual_audio_editor_current_time').css('color', 'white');
    if(current_global_preview_time == 0) {
      var first_component_from = selected_component.data('from');
      selected_component.find('._media_player_slider').slider('value', first_component_from);
      selected_component.find('._current_time').html(secondsToDateString(first_component_from));
    }
    setCurrentTimeToMedia(selected_component.find('audio'), selected_component.find('._media_player_slider').slider('value'));
    startAudioEditorPreview(selected_component);
  });
}

function switchBackAudioComponentsFromPreviewMode() {
  $('._audio_editor_component').css('opacity', 1);
  $('._audio_editor_component ._player_content').css('opacity', 0.2);
  $('._audio_editor_component ._remove').show();
  $('._audio_editor_component ._media_player_slider .ui-slider-handle').show();
  $('._audio_editor_component ._audio_component_icon').css('visibility', 'visible');
}

function switchAudioComponentsToPreviewMode() {
  $('._audio_editor_component ._player_content').css('opacity', 1);
  $('._audio_editor_component').css('opacity', 0.2);
  $('._audio_editor_component ._remove').hide();
  $('._audio_editor_component ._media_player_slider .ui-slider-handle').hide();
  $('._audio_editor_component ._audio_component_icon').css('visibility', 'hidden');
}

function deselectAllAudioEditorComponentsInPreviewMode() {
  $('._audio_editor_component ._audio_component_icon').css('visibility', 'hidden');
  $('._audio_editor_component').each(function() {
    deselectAllAudioEditorCursors(getAudioComponentIdentifier($(this)));
  });
  $('._audio_editor_component ._media_player_slider .ui-slider-handle').hide();
  $('._audio_editor_component').css('opacity', 0.2);
  $('._audio_editor_component ._content').removeClass('current');
  $('._audio_editor_component').removeClass('_selected');
}

function selectAudioEditorComponentInPreviewMode(component) {
  component.addClass('_selected');
  component.find('._content').addClass('current');
  component.css('opacity', 1);
  component.find('._audio_component_icon').css('visibility', 'visible');
  component.find('._media_player_slider .ui-slider-handle').show();
  selectAudioEditorCursor(getAudioComponentIdentifier(component));
}

function getAudioEditorGlobalPreviewTime() {
  var selected_component = $('._audio_editor_component._selected');
  if(selected_component.length == 0) {
    return 0;
  } else {
    var flag = true;
    var tot = 0;
    $('._audio_editor_component').each(function() {
      if($(this).hasClass('_selected')) {
        flag = false;
        tot += ($(this).find('._media_player_slider').slider('value') - $(this).data('from'));
      } else if(flag) {
        tot += $(this).data('duration');
      }
    });
    return tot;
  }
}

function leaveAudioEditorPreviewMode(forced_component) {
  var selected_component = $('#' + $('._audio_editor_component._selected').attr('id'));
  selected_component.find('audio')[0].pause();
  deselectAllAudioEditorComponentsInPreviewMode();
  switchBackAudioComponentsFromPreviewMode();
  $('#info_container').data('current-preview-time', 0);
  $('#visual_audio_editor_current_time').html(secondsToDateString(0));
  $('#visual_audio_editor_current_time').css('color', '#787575');
  $('#visual_audio_editor_total_length').css('color', 'white');
  $('#visual_audio_editor_current_time').hide();
  $('#commit_audio_editor').show();
  $('#add_new_audio_component_in_audio_editor').removeClass('disabled');
  $('#start_audio_editor_preview').show();
  $('#stop_audio_editor_preview').hide();
  $('#rewind_audio_editor_preview').removeClass('disabled');
  $('#audio_editor_timeline .jspVerticalBar').css('visibility', 'visible');
  if(forced_component != undefined) {
    scrollToFirstSelectedAudioEditorComponent(function() {
      selectAudioEditorComponent($('#' + forced_component));
    });
  } else {
    selectAudioEditorComponent(selected_component);
  }
  $('#audio_editor_box_ghost').hide();
  $('#info_container').data('in-preview', false);
}

function startAudioEditorPreview(component) {
  selectAudioEditorComponentInPreviewMode(component);
  followPreviewComponentsWithVerticalScrollInAudioEditor();
  var audio = component.find('audio');
  if(audio.readyState != 0) {
    audio[0].play();
  } else {
    audio.on('loadedmetadata', function() {
      audio[0].play();
    });
  }
}

function increaseAudioEditorPreviewTimer() {
  var data_container = $('#info_container');
  var global_time = data_container.data('current-preview-time');
  $('#visual_audio_editor_current_time').html(secondsToDateString(global_time + 1));
  data_container.data('current-preview-time', global_time + 1);
}

function getAudioComponentIdentifier(component) {
  var id = component.attr('id').split('_');
  return id[id.length - 1];
}

function followPreviewComponentsWithVerticalScrollInAudioEditor() {
  if($('._audio_editor_component._selected').data('position') - parseInt($('#audio_editor_timeline').data('jsp').getContentPositionY() / 113) == 4) {
    scrollToFirstSelectedAudioEditorComponent();
  }
}
