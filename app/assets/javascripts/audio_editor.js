/**
bla bla bla
@module audio-editor
**/





/**
bla bla bla
@method resizeLastComponentInAudioEditor
@for AudioEditorComponents
**/
function resizeLastComponentInAudioEditor() {
  $('._audio_editor_component._last').last().removeClass('_last')
  $('._audio_editor_component').last().addClass('_last');
}

/**
bla bla bla
@method selectAudioEditorComponent
@for AudioEditorComponents
**/
function selectAudioEditorComponent(component) {
  loadAudioComponentIfNotLoadedYet(component);
  deselectAllAudioEditorComponents();
  component.addClass('_selected');
  component.find('._content').addClass('current');
  component.find('._box_ghost').hide();
  component.find('._sort_handle').addClass('current');
  component.find('._player_content').css('opacity', 1);
  if($('html').hasClass('msie')) {
    component.find('._double_slider .ui-slider-range').css('opacity', 1);
  }
  component.find('._controls').css('visibility', 'visible');
  selectAudioEditorCursor(getAudioComponentIdentifier(component));
}

/**
bla bla bla
@method deselectAllAudioEditorComponents
@for AudioEditorComponents
**/
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
  $('._audio_editor_component._selected ._player_content').css('opacity', 0.2);
  $('.msie ._audio_editor_component._selected ._double_slider .ui-slider-range').css('opacity', 0.4);
  $('._audio_editor_component._selected ._controls').css('visibility', 'hidden');
  $('._audio_editor_component._selected').removeClass('_selected');
}

/**
bla bla bla
@method loadAudioComponentIfNotLoadedYet
@for AudioEditorComponents
**/
function loadAudioComponentIfNotLoadedYet(component) {
  if(!component.data('loaded')) {
    var mp3 = component.data('mp3');
    var ogg = component.data('ogg');
    component.find('source[type="audio/mp3"]').attr('src', mp3);
    component.find('source[type="audio/ogg"]').attr('src', ogg);
    component.find('audio').load();
    component.data('loaded', true);
  }
}

/**
bla bla bla
@method reloadAudioEditorComponentPositions
@for AudioEditorComponents
**/
function reloadAudioEditorComponentPositions() {
  var components = $('._audio_editor_component');
  components.each(function(index) {
    $(this).data('position', (index + 1));
    $(this).find('._audio_component_input_position').val(index + 1);
    $(this).find('._audio_component_icon').html(index + 1);
  });
}

/**
bla bla bla
@method changeDurationAudioEditorComponent
@for AudioEditorComponents
**/
function changeDurationAudioEditorComponent(component, new_duration) {
  var old_duration = component.data('duration');
  var total_length = $('#info_container').data('total-length');
  total_length -= old_duration;
  total_length += new_duration;
  component.data('duration', new_duration);
  $('#info_container').data('total-length', total_length);
  $('#visual_audio_editor_total_length').html(secondsToDateString(total_length));
}

/**
bla bla bla
@method removeAudioEditorComponent
@for AudioEditorComponents
**/
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

/**
bla bla bla
@method addComponentInAudioEditor
@for AudioEditorComponents
**/
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

/**
bla bla bla
@method fillAudioEditorSingleParameter
@for AudioEditorComponents
**/
function fillAudioEditorSingleParameter(input, identifier, value) {
  return '<input id="' + input + '_' + identifier + '" class="_audio_component_input_' + input + '" type="hidden" value="' + value + '" name="' + input + '_' + identifier + '">';
}





/**
bla bla bla
@method cutAudioComponentLeftSide
@for AudioEditorCutters
**/
function cutAudioComponentLeftSide(identifier, pos) {
  var component = $('#audio_component_' + identifier);
  var new_duration = component.data('to') - pos;
  component.data('from', pos);
  component.find('._cutter_from').html(secondsToDateString(pos));
  component.find('._audio_component_input_from').val(pos);
  changeDurationAudioEditorComponent(component, new_duration);
}

/**
bla bla bla
@method cutAudioComponentRightSide
@for AudioEditorCutters
**/
function cutAudioComponentRightSide(identifier, pos) {
  var component = $('#audio_component_' + identifier);
  var new_duration = pos - component.data('from');
  component.data('to', pos);
  component.find('._cutter_to').html(secondsToDateString(pos));
  component.find('._audio_component_input_to').val(pos);
  changeDurationAudioEditorComponent(component, new_duration);
}

/**
bla bla bla
@method deselectAllAudioEditorCursors
@for AudioEditorCutters
**/
function deselectAllAudioEditorCursors(id) {
  $('#audio_component_' + id + ' .ui-slider-handle').removeClass('selected');
  $('#audio_component_' + id + ' ._cutter_from, #audio_component_' + id + ' ._cutter_to, #audio_component_' + id + ' ._current_time').removeClass('selected');
}

/**
bla bla bla
@method selectAudioEditorLeftHandle
@for AudioEditorCutters
**/
function selectAudioEditorLeftHandle(id) {
  deselectAllAudioEditorCursors(id);
  $('#audio_component_' + id + ' ._double_slider .ui-slider-handle').first().addClass('selected');
  $('#audio_component_' + id + ' ._cutter_from').addClass('selected');
}

/**
bla bla bla
@method selectAudioEditorRightHandle
@for AudioEditorCutters
**/
function selectAudioEditorRightHandle(id) {
  deselectAllAudioEditorCursors(id);
  $($('#audio_component_' + id + ' ._double_slider .ui-slider-handle')[1]).addClass('selected');
  $('#audio_component_' + id + ' ._cutter_to').addClass('selected');
}

/**
bla bla bla
@method selectAudioEditorCursor
@for AudioEditorCutters
**/
function selectAudioEditorCursor(id) {
  deselectAllAudioEditorCursors(id);
  $('#audio_component_' + id + ' ._media_player_slider .ui-slider-handle').addClass('selected');
  $('#audio_component_' + id + ' ._current_time').addClass('selected');
}





/**
bla bla bla
@method audioEditorDocumentReady
@for AudioEditorDocumentReady
**/
function audioEditorDocumentReady() {
  audioEditorDocumentReadyCommit();
  audioEditorDocumentReadyPreview();
  audioEditorDocumentReadyCutters();
  audioEditorDocumentReadyGeneral();
}

/**
bla bla bla
@method audioEditorDocumentReadyCommit
@for AudioEditorDocumentReady
**/
function audioEditorDocumentReadyCommit() {
  $('body').on('click', '._exit_audio_editor', function() {
    stopCacheLoop();
    var captions = $('#popup_captions_container');
    showConfirmPopUp(captions.data('exit-audio-editor-title'), captions.data('exit-audio-editor-confirm'), captions.data('exit-audio-editor-yes'), captions.data('exit-audio-editor-no'), function() {
      $('dialog-confirm').hide();
      $.ajax({
        type: 'post',
        url: '/audios/cache/empty',
        beforeSend: unbindLoader(),
        success: function() {
          window.location = '/media_elements';
        }
      }).always(bindLoader);
    }, function() {
      if($('#form_info_update_media_element_in_editor').length == 0) {
        if(!$('#form_info_new_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      } else {
        if(!$('#form_info_new_media_element_in_editor').is(':visible') && !$('#form_info_update_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      }
      closePopUp('dialog-confirm');
    });
  });
  $('body').on('click', '#commit_audio_editor', function() {
    stopCacheLoop();
    submitMediaElementEditorCacheForm($('#audio_editor_form'));
    if($(this).hasClass('_with_choice')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('save-media-element-editor-title');
      var confirm = captions.data('save-media-element-editor-confirm');
      var yes = captions.data('save-media-element-editor-yes');
      var no = captions.data('save-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        closePopUp('dialog-confirm');
        showCommitAudioEditorForm('update');
      }, function() {
        closePopUp('dialog-confirm');
        $('#audio_editor_title ._titled').hide();
        $('#audio_editor_title ._untitled').show();
        showCommitAudioEditorForm('new');
      });
    } else {
      showCommitAudioEditorForm('new');
    }
  });
  $('body').on('click', '#audio_editor #form_info_new_media_element_in_editor ._cancel', function() {
    $('#audio_editor_form').attr('action', '/audios/cache/save');
    resetMediaElementEditorForms();
    if($('#audio_editor_title ._titled').length > 0) {
      $('#audio_editor_title ._titled').show();
      $('#audio_editor_title ._untitled').hide();
    }
    hideCommitAudioEditorForm('new');
    startCacheLoop();
  });
  $('body').on('click', '#audio_editor #form_info_update_media_element_in_editor ._cancel', function() {
    $('#audio_editor_form').attr('action', '/audios/cache/save');
    resetMediaElementEditorForms();
    hideCommitAudioEditorForm('update');
    startCacheLoop();
  });
  $('body').on('click', '#audio_editor #form_info_new_media_element_in_editor ._commit', function() {
    $('#audio_editor_form').attr('action', '/audios/commit/new');
    $('#audio_editor_form').submit();
  });
  $('body').on('click', '#audio_editor #form_info_update_media_element_in_editor ._commit', function() {
    if($('#info_container').data('used-in-private-lessons')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('overwrite-media-element-editor-title');
      var confirm = captions.data('overwrite-media-element-editor-confirm');
      var yes = captions.data('overwrite-media-element-editor-yes');
      var no = captions.data('overwrite-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        $('dialog-confirm').hide();
        $('#audio_editor_form').attr('action', '/audios/commit/overwrite');
        $('#audio_editor_form').submit();
      }, function() {
        closePopUp('dialog-confirm');
      });
    } else {
      $('#audio_editor_form').attr('action', '/audios/commit/overwrite');
      $('#audio_editor_form').submit();
    }
  });
}

/**
bla bla bla
@method audioEditorDocumentReadyPreview
@for AudioEditorDocumentReady
**/
function audioEditorDocumentReadyPreview() {
  $('body').on('click', '#start_audio_editor_preview', function() {
    if(!$(this).hasClass('disabled')) {
      enterAudioEditorPreviewMode();
    }
  });
  $('body').on('click', '#rewind_audio_editor_preview', function() {
    if(!$(this).hasClass('disabled')) {
      var selected_component = $('._audio_editor_component').first();
      selectAudioEditorComponent(selected_component);
      disableCommitAndPreviewInAudioEditor();
      scrollToFirstSelectedAudioEditorComponent(function() {
        enableCommitAndPreviewInAudioEditor();
        var from = selected_component.data('from');
        selected_component.find('._media_player_slider').slider('value', from);
        selected_component.find('._current_time').html(secondsToDateString(from));
        setCurrentTimeToMedia(selected_component.find('audio'), selected_component.find('._media_player_slider').slider('value'));
      });
    }
  });
  $('body').on('click', '#stop_audio_editor_preview', function() {
    leaveAudioEditorPreviewMode();
  });
}

/**
bla bla bla
@method audioEditorDocumentReadyCutters
@for AudioEditorDocumentReady
**/
function audioEditorDocumentReadyCutters() {
  $('body').on('click', '._audio_editor_component ._precision_arrow_left', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var single_slider = component.find('._media_player_slider');
    var double_slider = component.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp > 0 && resp > double_slider.slider('values', 0)) {
        selectAudioComponentCutterHandle(component, resp - 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp > 0) {
        double_slider.slider('values', 0, resp - 1);
        cutAudioComponentLeftSide(identifier, resp - 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp > double_slider.slider('values', 0) + 1) {
        if(single_slider.slider('value') == resp) {
          selectAudioComponentCutterHandle(component, resp - 1);
        }
        double_slider.slider('values', 1, resp - 1);
        cutAudioComponentRightSide(identifier, resp - 1);
      }
    }
  });
  $('body').on('click', '._audio_editor_component ._precision_arrow_right', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var duration = component.data('max-to');
    var single_slider = component.find('._media_player_slider');
    var double_slider = component.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp < duration && resp < double_slider.slider('values', 1)) {
        selectAudioComponentCutterHandle(component, resp + 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp < double_slider.slider('values', 1) - 1) {
        if(single_slider.slider('value') == resp) {
          selectAudioComponentCutterHandle(component, resp + 1);
        }
        double_slider.slider('values', 0, resp + 1);
        cutAudioComponentLeftSide(identifier, resp + 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp < duration) {
        double_slider.slider('values', 1, resp + 1);
        cutAudioComponentRightSide(identifier, resp + 1);
      }
    }
  });
}

/**
bla bla bla
@method audioEditorDocumentReadyGeneral
@for AudioEditorDocumentReady
**/
function audioEditorDocumentReadyGeneral() {
  $('body').on('mouseover', '._audio_editor_component ._box_ghost', function() {
    $(this).parent().find('._sort_handle').addClass('current');
  });
  $('body').on('mouseout', '._audio_editor_component ._box_ghost', function(e) {
    if($(this).is(':visible') && !$(e.relatedTarget).hasClass('_remove')) {
      $(this).parent().find('._sort_handle').removeClass('current');
    }
  });
  $('body').on('click', '._audio_editor_component ._sort_handle', function() {
    selectAudioEditorComponent($(this).parent().parent());
  });
  $('body').on('click', '._audio_editor_component ._box_ghost', function() {
    selectAudioEditorComponent($(this).parent());
  });
  $('body').on('click', '._audio_editor_component ._remove', function() {
    removeAudioEditorComponent($(this).parent());
  });
  $('body').on('click', '#add_new_audio_component_in_audio_editor', function() {
    if(!$('#add_new_audio_component_in_audio_editor').hasClass('disabled')) {
      var selected_component = $('._audio_editor_component._selected');
      if(selected_component.length > 0) {
        selected_component.find('._media_player_pause_in_audio_editor_preview').click();
      }
      if($('#audio_editor_gallery_container').data('loaded')) {
        showGalleryInAudioEditor();
      } else {
        $.ajax({
          type: 'get',
          url: '/audios/galleries/audio'
        });
      }
    }
  });
  $('body').on('click', '._add_audio_component_to_audio_editor', function() {
    stopMedia('._audio_expanded_in_gallery audio');
    $('._audio_expanded_in_gallery ._expanded').hide();
    $('._audio_expanded_in_gallery').removeClass('_audio_expanded_in_gallery');
    var audio_id = $(this).data('audio-id');
    closeGalleryInAudioEditor();
    stopMedia('#gallery_audio_' + audio_id + ' audio');
    $('#gallery_audio_' + audio_id + ' ._expanded').hide();
    addComponentInAudioEditor(audio_id, $(this).data('ogg'), $(this).data('mp3'), $(this).data('duration'), $(this).data('title'));
  });
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
  if($('html').hasClass('msie')) {
    $('._audio_editor_component ._double_slider .ui-slider-range').css('opacity', 0.4);
  }
}





/**
bla bla bla
@method showGalleryInAudioEditor
@for AudioEditorGalleries
**/
function showGalleryInAudioEditor() {
  $('._audio_editor_bottom_bar').hide();
  $('#audio_editor_gallery_container').show();
  setToZeroAllZIndexesInAudioEditor();
  calculateNewPositionGalleriesInAudioEditor();
}

/**
bla bla bla
@method calculateNewPositionGalleriesInAudioEditor
@for AudioEditorGalleries
**/
function calculateNewPositionGalleriesInAudioEditor() {
  $('#audio_editor_gallery_container').css('left', (($(window).width() - 940) / 2) + 'px');
}

/**
bla bla bla
@method closeGalleryInAudioEditor
@for AudioEditorGalleries
**/
function closeGalleryInAudioEditor() {
  $('._audio_editor_bottom_bar').show();
  $('#audio_editor_gallery_container').hide('fade', {}, 250, function() {
    setBackAllZIndexesInAudioEditor();
  });
}





/**
bla bla bla
@method getAudioComponentIdentifier
@for AudioEditorGeneral
**/
function getAudioComponentIdentifier(component) {
  var id = component.attr('id').split('_');
  return id[id.length - 1];
}





/**
bla bla bla
@method disableCommitAndPreviewInAudioEditor
@for AudioEditorGraphics
**/
function disableCommitAndPreviewInAudioEditor() {
  $('#empty_audio_editor').show();
  $('#commit_audio_editor').hide();
  $('#start_audio_editor_preview').addClass('disabled');
  $('#rewind_audio_editor_preview').addClass('disabled');
}

/**
bla bla bla
@method enableCommitAndPreviewInAudioEditor
@for AudioEditorGraphics
**/
function enableCommitAndPreviewInAudioEditor() {
  $('#empty_audio_editor').hide();
  $('#commit_audio_editor').show();
  $('#start_audio_editor_preview').removeClass('disabled');
  $('#rewind_audio_editor_preview').removeClass('disabled');
}

/**
bla bla bla
@method setToZeroAllZIndexesInAudioEditor
@for AudioEditorGraphics
**/
function setToZeroAllZIndexesInAudioEditor() {
  $('._audio_editor_component ._remove').css('z-index', 0);
  $('._audio_editor_component ._box_ghost').css('z-index', 0);
  $('._audio_editor_component ._media_player_slider_disabler').css('z-index', 0);
  $('._audio_editor_component ._double_slider').css('z-index', 0);
  $('._audio_editor_component ._under_double_slider').css('z-index', 0);
  $('._audio_editor_component ._media_player_slider').css('z-index', 0);
}

/**
bla bla bla
@method setBackAllZIndexesInAudioEditor
@for AudioEditorGraphics
**/
function setBackAllZIndexesInAudioEditor() {
  $('._audio_editor_component ._remove').css('z-index', 101);
  $('._audio_editor_component ._box_ghost').css('z-index', 100);
  $('._audio_editor_component ._media_player_slider_disabler').css('z-index', 99);
  $('._audio_editor_component ._double_slider').css('z-index', 98);
  $('._audio_editor_component ._under_double_slider').css('z-index', 97);
  $('._audio_editor_component ._media_player_slider').css('z-index', 96);
}

/**
bla bla bla
@method showCommitAudioEditorForm
@for AudioEditorGraphics
**/
function showCommitAudioEditorForm(scope) {
  $('._audio_editor_bottom_bar').hide();
  $('#audio_editor #form_info_' + scope + '_media_element_in_editor').show();
  setToZeroAllZIndexesInAudioEditor();
}

/**
bla bla bla
@method hideCommitAudioEditorForm
@for AudioEditorGraphics
**/
function hideCommitAudioEditorForm(scope) {
  $('._audio_editor_bottom_bar').show();
  $('#audio_editor #form_info_' + scope + '_media_element_in_editor').hide();
  setBackAllZIndexesInAudioEditor();
}





/**
bla bla bla
@method enterAudioEditorPreviewMode
@for AudioEditorPreview
**/
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
    loadAudioComponentIfNotLoadedYet(selected_component);
    setCurrentTimeToMedia(selected_component.find('audio'), selected_component.find('._media_player_slider').slider('value'));
    startAudioEditorPreview(selected_component);
  });
}

/**
bla bla bla
@method switchBackAudioComponentsFromPreviewMode
@for AudioEditorPreview
**/
function switchBackAudioComponentsFromPreviewMode() {
  $('._audio_editor_component').css('opacity', 1);
  $('._audio_editor_component ._player_content').css('opacity', 0.2);
  $('.msie ._audio_editor_component ._double_slider .ui-slider-range').css('opacity', 0.4);
  $('._audio_editor_component ._remove').show();
  $('._audio_editor_component ._media_player_slider .ui-slider-handle').show();
  $('._audio_editor_component ._audio_component_icon').css('visibility', 'visible');
}

/**
bla bla bla
@method switchAudioComponentsToPreviewMode
@for AudioEditorPreview
**/
function switchAudioComponentsToPreviewMode() {
  $('._audio_editor_component ._player_content').css('opacity', 1);
  $('.msie ._audio_editor_component ._double_slider .ui-slider-range').css('opacity', 1);
  $('._audio_editor_component').css('opacity', 0.2);
  $('._audio_editor_component ._remove').hide();
  $('._audio_editor_component ._media_player_slider .ui-slider-handle').hide();
  $('._audio_editor_component ._audio_component_icon').css('visibility', 'hidden');
}

/**
bla bla bla
@method deselectAllAudioEditorComponentsInPreviewMode
@for AudioEditorPreview
**/
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

/**
bla bla bla
@method selectAudioEditorComponentInPreviewMode
@for AudioEditorPreview
**/
function selectAudioEditorComponentInPreviewMode(component) {
  component.addClass('_selected');
  component.find('._content').addClass('current');
  component.css('opacity', 1);
  component.find('._audio_component_icon').css('visibility', 'visible');
  component.find('._media_player_slider .ui-slider-handle').show();
  selectAudioEditorCursor(getAudioComponentIdentifier(component));
}

/**
bla bla bla
@method getAudioEditorGlobalPreviewTime
@for AudioEditorPreview
**/
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

/**
bla bla bla
@method leaveAudioEditorPreviewMode
@for AudioEditorPreview
**/
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

/**
bla bla bla
@method startAudioEditorPreview
@for AudioEditorPreview
**/
function startAudioEditorPreview(component) {
  selectAudioEditorComponentInPreviewMode(component);
  followPreviewComponentsWithVerticalScrollInAudioEditor();
  var audio = component.find('audio');
  if(audio[0].error) {
    showLoadingMediaErrorPopup(audio[0].error.code, 'audio');
    $('#stop_audio_editor_preview').click();
  } else {
    if(audio.readyState != 0) {
      audio[0].play();
    } else {
      audio.on('loadedmetadata', function() {
        audio[0].play();
      });
    }
  }
}

/**
bla bla bla
@method increaseAudioEditorPreviewTimer
@for AudioEditorPreview
**/
function increaseAudioEditorPreviewTimer() {
  var data_container = $('#info_container');
  var global_time = data_container.data('current-preview-time');
  $('#visual_audio_editor_current_time').html(secondsToDateString(global_time + 1));
  data_container.data('current-preview-time', global_time + 1);
}





/**
bla bla bla
@method scrollToFirstSelectedAudioEditorComponent
@for AudioEditorScrollpain
**/
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

/**
bla bla bla
@method followPreviewComponentsWithVerticalScrollInAudioEditor
@for AudioEditorScrollpain
**/
function followPreviewComponentsWithVerticalScrollInAudioEditor() {
  if($('._audio_editor_component._selected').data('position') - parseInt($('#audio_editor_timeline').data('jsp').getContentPositionY() / 113) == 4) {
    scrollToFirstSelectedAudioEditorComponent();
  }
}
