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
  component.find('._player_content').css('visibility', 'visible');
  component.find('._controls').css('visibility', 'visible');
}

function deselectAllAudioEditorComponents() {
  $('._audio_editor_component._selected ._content').removeClass('current');
  $('._audio_editor_component._selected ._box_ghost').show();
  $('._audio_editor_component._selected ._sort_handle').removeClass('current');
  $('._audio_editor_component._selected ._player_content').css('visibility', 'hidden');
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
  component.hide('fade', {}, 500, function() {
    changeDurationAudioEditorComponent(component, 0);
    $(this).remove();
    reloadAudioEditorComponentPositions();
    if($('._audio_editor_component').length == 0) {
      disableCommitAndPreviewInAudioEditor();
    }
  });
}

function disableCommitAndPreviewInAudioEditor() {
  $('#commit_audio_editor').hide();
  $('#start_audio_editor_preview').addClass('disabled');
}

function enableCommitAndPreviewInAudioEditor() {
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
}

function selectAudioEditorLeftHandle(id) {
  deselectAllAudioEditorCursors(id);
  $($('#audio_component_' + id + ' ._double_slider .ui-slider-handle')[0]).addClass('selected');
}

function selectAudioEditorRightHandle(id) {
  deselectAllAudioEditorCursors(id);
  $($('#audio_component_' + id + ' ._double_slider .ui-slider-handle')[1]).addClass('selected');
}

function selectAudioEditorCursor(id) {
  deselectAllAudioEditorCursors(id);
  $('#audio_component_' + id + ' ._media_player_slider .ui-slider-handle').addClass('selected');
}

// TODO da provare in profindità
function addComponentInAudioEditor(audio_id, ogg, mp3, duration, title) {
  var next_position = $('#info_container').data('last-component-id') + 1;
  $('#info_container').data('last-component-id', next_position);
  var empty_component = $($('#empty_component_for_audio_editor').html());
  empty_component.attr('id', ('audio_component_' + next_position));
  empty_component.find('source[type="audio/ogg"]').attr('src', ogg);
  empty_component.find('source[type="audio/mp3"]').attr('src', mp3);
  empty_component.data('duration', duration);
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
  empty_component.append(to_be_appended);
  $('#audio_editor_timeline').append(empty_component);
  empty_component.find('audio').load();
  initializeAudioEditorCutter(next_position);
  reloadAudioEditorComponentPositions(empty_component);
  changeDurationAudioEditorComponent(empty_component, duration);
  // TODO manca scroll
  // TODO manca highlights
  // TODO if ho appena aggiunto la prima componente --- enableCommitAndPreviewInAudioEditor
}

function fillAudioEditorSingleParameter(input, identifier, value) {
  return '<input id="' + input + '_' + identifier + '" class="_audio_component_input_' + input + '" type="hidden" value="' + value + '" name="' + input + '_' + identifier + '">';
}



//function startVideoEditorPreviewClipWithDelay(component_id) {
//  setTimeout(function() {
//    var obj = $('#' + component_id);
//    if(obj.data('preview-selected') && $('#' + component_id + '_preview').css('display') == 'none') {
//      startVideoEditorPreviewClip(component_id);
//    }
//  }, 500);
//}

//function startVideoEditorPreviewClip(component_id) {
//  $('._video_component_preview').hide();
//  $('#' + component_id + '_preview').show('fade', {}, 250);
//}

//function calculateVideoComponentStartSecondInVideoEditor(identifier) {
//  var duration = 0;
//  var stop = false;
//  $('._video_editor_component').each(function(index) {
//    if(getVideoComponentIdentifier($(this).attr('id')) == identifier) {
//      stop = true;
//    } else if(!stop) {
//      duration += ($(this).data('duration') + 1);
//    }
//  });
//  var cutter = $('#video_component_' + identifier + '_cutter');
//  if(!cutter.hasClass('_mini_cutter')) {
//    duration += (cutter.find('._media_player_slider').slider('value') - cutter.data('from'));
//  }
//  return duration;
//}

//function startVideoEditorGlobalPreview() {
//  $('#video_editor_global_preview').data('in-use', true);
//  var current_identifier = $('#video_editor_global_preview').data('current-component');
//  var current_component = $('#video_component_' + current_identifier);
//  var actual_audio_track_time = calculateVideoComponentStartSecondInVideoEditor(current_identifier) + current_component.data('current-preview-time');
//  if(videoEditorWithAudioTrack() && actual_audio_track_time < $('#full_audio_track_placeholder_in_video_editor').data('duration')) {
//    var audio_track = $('#video_editor_preview_container audio');
//    setCurrentTimeToMedia(audio_track, actual_audio_track_time);
//    if(audio_track.readyState != 0) {
//      audio_track[0].play();
//    } else {
//      audio_track.on('loadedmetadata', function() {
//        audio_track[0].play();
//      });
//    }
//  }
//  if(current_component.data('position') == getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186) + 1) {
//    playVideoEditorComponent(current_component, false);
//  } else {
//    playVideoEditorComponent(current_component, true);
//  }
//}

//function getFirstVideoEditorComponent() {
//  return $($('._video_editor_component')[0]);
//}

//function getLastVideoEditorComponent() {
//  var components = $('._video_editor_component');
//  return $(components[components.length - 1]);
//}

//function playVideoEditorComponent(component, with_scroll) {
//  if(with_scroll) {
//    followPreviewComponentsWithHorizontalScrollInVideoEditor();
//  }
//  var identifier = getVideoComponentIdentifier(component.attr('id'));
//  $('._video_component_transition').addClass('current');
//  if(component.hasClass('_video')) {
//    var video = $('#video_component_' + identifier + '_preview video');
//    if(video.readyState != 0) {
//      video[0].play();
//    } else {
//      video.on('loadedmetadata', function() {
//        video[0].play();
//      });
//    }
//  } else {
//    automaticIncreaseVideoEditorPreviewTimer(component.data('current-preview-time') + 1, component.data('duration'), function() {
//      var next_component = component.next();
//      var next_identifier = getVideoComponentIdentifier(next_component.attr('id'));
//      if(next_component.hasClass('_video_editor_component')) {
//        increaseVideoEditorPreviewTimer(true);
//        $('#video_editor_global_preview').data('current-component', getVideoComponentIdentifier(next_component.attr('id')));
//        $('#video_component_' + identifier + '_preview').hide('fade', {}, 1000);
//        component.find('._video_component_transition').removeClass('current');
//        next_component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
//        $('#video_component_' + next_identifier + '_preview').show('fade', {}, 1000, function() {
//          if(!$('#video_editor_global_preview').data('in-use')) {
//            $('._video_component_transition').addClass('current');
//          }
//          increaseVideoEditorPreviewTimer(false);
//          component.find('._video_editor_component_hover, ._video_component_icon').addClass('selected');
//          if($('#video_editor_global_preview').data('in-use')) {
//            playVideoEditorComponent(next_component, true);
//          }
//        });
//      } else {
//        selectVideoComponentInPreview(getFirstVideoEditorComponent());
//        if(videoEditorWithAudioTrack()) {
//          $('#video_editor_preview_container audio')[0].pause();
//        }
//        $('#video_editor_global_preview_pause').trigger('click');
//        $('#media_elements_list_in_video_editor').data('jsp').scrollToX(0, true, 500);
//      }
//    });
//  }
//}

//function selectVideoComponentInPreview(component) {
//  $('._video_component_preview').hide();
//  $('#' + component.attr('id') + '_preview').show();
//  $('._video_editor_component_hover, ._video_component_icon').addClass('selected');
//  component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
//  setVisualTimesVideoEditorPreview(component, 0);
//}

//function setVisualTimesVideoEditorPreview(component, time) {
//  var identifier = getVideoComponentIdentifier(component.attr('id'));
//  var global_time = calculateVideoComponentStartSecondInVideoEditor(identifier) + time;
//  $('#visual_video_editor_current_time').html(secondsToDateString(global_time));
//  $('#video_editor_global_preview').data('current-time', global_time);
//  $('#video_editor_global_preview').data('current-component', identifier);
//  var start = false;
//  $('._video_editor_component').each(function() {
//    var my_identifier = getVideoComponentIdentifier($(this).attr('id'));
//    if(my_identifier == identifier) {
//      $(this).find('._video_component_icon ._right').html(secondsToDateString(time));
//      $(this).data('current-preview-time', time);
//      if($('#video_component_' + my_identifier + '_preview video').length > 0) {
//        setCurrentTimeToMedia($('#video_component_' + my_identifier + '_preview video'), $('#video_component_' + my_identifier + '_cutter').data('from') + time);
//      }
//      start = true;
//    } else if(start) {
//      $(this).find('._video_component_icon ._right').html(secondsToDateString(0));
//      $(this).data('current-preview-time', 0);
//      if($('#video_component_' + my_identifier + '_preview video').length > 0) {
//        setCurrentTimeToMedia($('#video_component_' + my_identifier + '_preview video'), $('#video_component_' + my_identifier + '_cutter').data('from'));
//      }
//    } else {
//      var own_duration = $(this).data('duration');
//      $(this).find('._video_component_icon ._right').html(secondsToDateString(own_duration));
//      $(this).data('current-preview-time', own_duration);
//      if($('#video_component_' + my_identifier + '_preview video').length > 0) {
//        setCurrentTimeToMedia($('#video_component_' + my_identifier + '_preview video'), $('#video_component_' + my_identifier + '_cutter').data('to'));
//      }
//    }
//  });
//}

//function getInitialPointOfVideoEditorComponent(component) {
//  resp = 0;
//  if(component.hasClass('_video')) {
//    resp = $('#' + component.attr('id') + '_cutter').data('from');
//  }
//  return resp;
//}

//function automaticIncreaseVideoEditorPreviewTimer(time, total_length, callback) {
//  setTimeout(function() {
//    if($('#video_editor_global_preview').data('in-use')) {
//      if(time < total_length) {
//        increaseVideoEditorPreviewTimer(true);
//        automaticIncreaseVideoEditorPreviewTimer(time + 1, total_length, callback);
//      } else {
//        callback();
//      }
//    }
//  }, 1000);
//}

//function increaseVideoEditorPreviewTimer(with_component) {
//  var data_container = $('#video_editor_global_preview');
//  var global_time = data_container.data('current-time');
//  $('#visual_video_editor_current_time').html(secondsToDateString(global_time + 1));
//  data_container.data('current-time', global_time + 1);
//  if(with_component) {
//    var identifier = data_container.data('current-component');
//    var component = $('#video_component_' + identifier);
//    var component_time = component.data('current-preview-time');
//    component.find('._video_component_icon ._right').html(secondsToDateString(component_time + 1));
//    component.data('current-preview-time', component_time + 1);
//  }
//}

//function showVideoEditorPreviewArrowToComponents() {
//  if(getVideoComponentIdentifier(getFirstVideoEditorComponent().attr('id')) != $('#video_editor_global_preview').data('current-component')) {
//    $('#video_editor_preview_go_to_left_component').show();
//  } else {
//    $('#video_editor_preview_go_to_left_component').hide();
//  }
//  if(getVideoComponentIdentifier(getLastVideoEditorComponent().attr('id')) != $('#video_editor_global_preview').data('current-component')) {
//    $('#video_editor_preview_go_to_right_component').show();
//  } else {
//    $('#video_editor_preview_go_to_right_component').hide();
//  }
//}

//function openPreviewModeInVideoEditor() {
//  var first_component = getFirstVideoEditorComponent();
//  var first_identifier = getVideoComponentIdentifier(first_component.attr('id'));
//  $('._video_component_preview').hide();
//  $('#full_audio_track_placeholder_in_video_editor, #empty_audio_track_placeholder_in_video_editor').css('visibility', 'hidden');
//  $('#visual_video_editor_current_time').css('visibility', 'visible').css('color', 'white');
//  $('#visual_video_editor_total_length').css('color', '#787575');
//  $('#video_editor_global_preview').hide();
//  $('#video_editor_global_preview_pause').show();
//  $('#commit_video_editor').hide();
//  $('#video_editor_box_ghost').show();
//  $('._video_editor_component_hover, ._video_component_icon').addClass('selected');
//  $('#media_elements_list_in_video_editor').data('jsp').destroy();
//  $('#add_new_video_component').hide();
//  $('#add_new_video_component').prev().find('._video_component_transition').hide();
//  $('#add_new_video_component').prev().css('width', '159');
//  var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) - 184;
//  $('#video_editor_timeline').css('width', new_timeline_width + 'px');
//  $('#media_elements_list_in_video_editor').jScrollPane({
//    autoReinitialise: true,
//    initialHorizontalStyles: 'visibility:hidden'
//  });
//  $('._video_component_transition').addClass('current');
//  setVisualTimesVideoEditorPreview(first_component, 0);
//  $('#video_editor_preview_container ._loader').show();
//  $('#video_editor_global_preview_pause a').addClass('disabled');
//  setTimeout(function() {
//    $('#video_editor_global_preview_pause').addClass('_enabled');
//    $('#video_editor_global_preview_pause a').removeClass('disabled');
//    $('#video_editor_preview_container ._loader').hide();
//    $('#video_component_' + first_identifier + '_preview').show();
//    first_component.find('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
//    startVideoEditorGlobalPreview();
//  }, 1500);
//}

//function followPreviewComponentsWithHorizontalScrollInVideoEditor() {
//  var jsp_handler = $('#media_elements_list_in_video_editor').data('jsp');
//  var pos = $('#video_component_' + $('#video_editor_global_preview').data('current-component')).data('position');
//  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186);
//  var movement = 0;
//  var whole_movement = 0;
//  if(pos - how_many_hidden_to_left == 5) {
//    movement = calculateCorrectMovementHorizontalScrollRight(how_many_hidden_to_left, 4, $('._video_editor_component').length, 5);
//    if(movement > 0) {
//      whole_movement = (how_many_hidden_to_left + movement) * 186;
//    }
//  } else if(pos - how_many_hidden_to_left == 6) {
//    movement = calculateCorrectMovementHorizontalScrollRight(how_many_hidden_to_left, 5, $('._video_editor_component').length, 5);
//    if(movement > 0) {
//      whole_movement = (how_many_hidden_to_left + movement) * 186;
//    }
//  } else if(pos == how_many_hidden_to_left) {
//    movement = calculateCorrectMovementHorizontalScrollLeft(how_many_hidden_to_left, 5);
//    if(movement > 0) {
//      whole_movement = (how_many_hidden_to_left - movement) * 186;
//    }
//  } else if(pos == how_many_hidden_to_left + 1) {
//    movement = calculateCorrectMovementHorizontalScrollLeft(how_many_hidden_to_left, 4);
//    if(movement > 0) {
//      whole_movement = (how_many_hidden_to_left - movement) * 186;
//    }
//  }
//  if(movement != 0) {
//    $('#video_editor_global_preview').data('arrows', false);
//    $('#media_elements_list_in_video_editor').jScrollPane().bind('panescrollstop', function() {
//      $('#video_editor_global_preview').data('arrows', true);
//      $('#media_elements_list_in_video_editor').jScrollPane().unbind('panescrollstop');
//    });
//    jsp_handler.scrollToX(whole_movement, true, (1000 * movement) / 4);
//  }
//}
