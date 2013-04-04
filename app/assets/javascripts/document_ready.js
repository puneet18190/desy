$(document).ready(function() {
  
  browsersDocumentReady();
  
  generalWindowResizeDocumentReady();
  
  ajaxLoaderDocumentReady();
  
  defaultValueJavaScriptAnimationsDocumentReady();
  
  dashboardDocumentReady();
  
  formsDocumentReady();
  
  filtersDocumentReady();
  
  expandedItemsDocumentReady();
  
  galleriesDocumentReady();
  
  lessonButtonsDocumentReady();
  
  mediaElementButtonsDocumentReady();
  
  javaScriptAnimationsDocumentReady();
  
  notificationsDocumentReady();
  
  searchDocumentReady();
  
  virtualClassroomDocumentReady();
  
  imageEditorDocumentReady();
  
  mediaElementLoaderDocumentReady();
  
  lessonEditorDocumentReady();
  
  preloginDocumentReady();
  
  profileDocumentReady();
  
  mediaElementEditorDocumentReady();
  
  videoEditorDocumentReady();
  
  
  // AUDIO EDITOR
  
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
  
  initializeAudioEditor();
  
  
  // PLAYERS
  
  $('body').on('click', '._media_player_play', function() {
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    var media = $('#' + container_id + ' ' + type);
    if(media[0].error) {
      showLoadingMediaErrorPopup(media[0].error.code, type);
    } else {
      $('#' + container_id + ' ._media_player_slider_disabler').show();
      $('#' + container_id + ' ._media_player_pause').show();
      $(this).hide();
      if(media[0].readyState != 0) {
        media[0].play();
      } else {
        media.on('loadedmetadata', function() {
          media[0].play();
        });
      }
    }
  });
  
  $('body').on('click', '._media_player_pause', function() {
    $(this).hide();
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    $('#' + container_id + ' ._media_player_slider_disabler').hide();
    $('#' + container_id + ' ._media_player_play').show();
    $('#' + container_id + ' ' + type)[0].pause();
  });
  
  $('body').on('click', '._video_full_screen', function() {
    var container_id = $(this).parent().attr('id');
    $('#' + container_id + ' video').fullScreen(true);
  });
  
  $('body').on('click', '._media_player_play_in_video_editor_preview', function() {
    var identifier = getVideoComponentIdentifier($(this).parents('._video_component_cutter').attr('id'));
    var video = $('#video_component_' + identifier + '_preview video');
    if(video[0].error){
      showLoadingMediaErrorPopup(video[0].error.code, 'video');
    } else {
      $(this).hide();
      $(this).parents('._video_component_cutter').data('playing', true);
      $('#video_component_' + identifier + '_cutter ._media_player_rewind_in_video_editor_preview').hide();
      $('#video_component_' + identifier + '_cutter ._media_player_slider_disabler').show();
      $('#video_component_' + identifier + '_cutter ._media_player_pause_in_video_editor_preview').show();
      $('#video_component_' + identifier + '_cutter .ui-slider-handle').removeClass('selected');
      if(video.readyState != 0) {
        video[0].play();
      } else {
        video.on('loadedmetadata', function() {
          video[0].play();
        });
      }
    }
    var actual_audio_track_time = calculateVideoComponentStartSecondInVideoEditor(identifier);
    if(videoEditorWithAudioTrack() && actual_audio_track_time < $('#full_audio_track_placeholder_in_video_editor').data('duration')) {
      var audio_track = $('#video_editor_preview_container audio');
      if(audio_track[0].error) {
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
  });
  
  $('body').on('click', '._media_player_pause_in_video_editor_preview', function() {
    $(this).hide();
    $(this).parents('._video_component_cutter').data('playing', false);
    var cutter_id = $(this).parents('._video_component_cutter').attr('id');
    var preview_id = cutter_id.replace('cutter', 'preview');
    $('#' + cutter_id + ' ._media_player_rewind_in_video_editor_preview').show();
    $('#' + cutter_id + ' ._media_player_slider_disabler').hide();
    $('#' + cutter_id + ' ._media_player_play_in_video_editor_preview').show();
    $('#' + cutter_id + ' ._media_player_slider .ui-slider-handle').addClass('selected');
    $('#' + preview_id + ' video')[0].pause();
    if(videoEditorWithAudioTrack()) {
      $('#video_editor_preview_container audio')[0].pause();
    }
    if(parseInt($('#' + preview_id + ' video')[0].currentTime) != $('#' + cutter_id).data('to')) {
      setCurrentTimeToMedia($('#' + preview_id + ' video'), $('#' + cutter_id + ' ._media_player_slider').slider('value'));
    }
  });
  
  $('body').on('click', '._media_player_rewind_in_video_editor_preview', function() {
    var identifier = getVideoComponentIdentifier($(this).parents('._video_component_cutter').attr('id'));
    var initial_time = $('#video_component_' + identifier + '_cutter').data('from');
    $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', initial_time);
    setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), initial_time);
  });
  
  $('body').on('click', '._video_component_cutter ._double_slider .ui-slider-range', function(e) {
    var cutter = $(this).parents('._video_component_cutter');
    var percent = cutter.data('max-to') * (e.pageX - cutter.find('._double_slider').offset().left) / cutter.find('._double_slider').width();
    resp = parseInt(percent);
    if(percent - parseInt(percent) > 0.5) {
      resp += 1;
    }
    cutter.find('.ui-slider-handle').removeClass('selected');
    cutter.find('._media_player_slider .ui-slider-handle').addClass('selected');
    selectVideoComponentCutterHandle(cutter, resp);
  });
  
  $('body').on('click', '._media_player_play_in_audio_editor_preview', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var audio = component.find('audio');
    if(audio[0].error) {
      showLoadingMediaErrorPopup(audio[0].error.code, 'audio');
    } else {
      $(this).hide();
      $('#start_audio_editor_preview').addClass('disabled');
      $('#rewind_audio_editor_preview').addClass('disabled');
      component.data('playing', true);
      component.find('._media_player_slider_disabler').show();
      component.find('._media_player_rewind_in_audio_editor_preview').hide();
      component.find('._media_player_pause_in_audio_editor_preview').show();
      deselectAllAudioEditorCursors(identifier);
      var single_slider = component.find('._media_player_slider');
      if(audio[0].currentTime < single_slider.slider('value')) {
        setCurrentTimeToMedia(audio, single_slider.slider('value'));
      }
      if(audio.readyState != 0) {
        audio[0].play();
      } else {
        audio.on('loadedmetadata', function() {
          audio[0].play();
        });
      }
    }
  });
  
  $('body').on('click', '._media_player_pause_in_audio_editor_preview', function() {
    $(this).hide();
    $('#start_audio_editor_preview').removeClass('disabled');
    $('#rewind_audio_editor_preview').removeClass('disabled');
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    component.data('playing', false);
    component.find('._media_player_slider_disabler').hide();
    component.find('._media_player_rewind_in_audio_editor_preview').show();
    component.find('._media_player_play_in_audio_editor_preview').show();
    selectAudioEditorCursor(identifier);
    component.find('audio')[0].pause();
    if(component.data('to') != parseInt(component.find('audio')[0].currentTime)) {
      setCurrentTimeToMedia(component.find('audio'), component.find('._media_player_slider').slider('value'));
    }
  });
  
  $('body').on('click', '._media_player_rewind_in_audio_editor_preview', function() {
    var component = $(this).parents('._audio_editor_component');
    var initial_time = component.data('from');
    component.find('._media_player_slider').slider('value', initial_time);
    setCurrentTimeToMedia(component.find('audio'), initial_time);
    component.find('._current_time').html(secondsToDateString(initial_time));
  });
  
  $('body').on('click', '._audio_editor_component ._double_slider .ui-slider-range', function(e) {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var percent = component.data('max-to') * (e.pageX - component.find('._double_slider').offset().left) / component.find('._double_slider').width();
    resp = parseInt(percent);
    if(percent - parseInt(percent) > 0.5) {
      resp += 1;
    }
    selectAudioEditorCursor(identifier);
    selectAudioComponentCutterHandle(component, resp);
  });
  
  
  
  automaticLoginDocumentReady();
  
});
