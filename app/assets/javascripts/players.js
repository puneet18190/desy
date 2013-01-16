// GENERAL PLAYERS

function initializeMediaTimeUpdater(media, reference_id) {
  media = $(media);
  if(media.readyState != 0) {
    media[0].addEventListener('timeupdate', function() {
      initializeActionOfMediaTimeUpdater(this, reference_id);
    }, false);
  } else {
    media.on('loadedmetadata', function() {
      media[0].addEventListener('timeupdate', function() {
        initializeActionOfMediaTimeUpdater(this, reference_id);
      }, false);
    });
  }
}

function initializeActionOfMediaTimeUpdater(media, reference_id) {
  var duration = $('#' + reference_id).data('duration');
  var container_id = $(media).parent().attr('id');
  var parsed_int = parseInt(media.currentTime);
  if(parsed_int == (duration + 1)) {
    $('#' + container_id + ' ._media_player_pause').click();
    $('#' + container_id + ' ._media_player_slider').slider('value', 0);
    $('#' + container_id + ' ._media_player_current_time').html(secondsToDateString(0));
    setCurrentTimeToMedia($(media), 0);
  } else if($('#' + container_id + ' ._media_player_play').css('display') == 'none') {
    $('#' + container_id + ' ._media_player_current_time').html(secondsToDateString(parsed_int));
    $('#' + container_id + ' ._media_player_slider').slider('value', parsed_int);
  }
}

function initializeMedia(content_id, type) {
  var duration = $('#' + content_id).data('duration');
  $('#' + content_id + ' ._media_player_slider').slider({
    min: 0,
    max: duration,
    range: 'min',
    value: 0,
    slide: function(event, ui) {
      if($('#' + content_id + ' ._media_player_play').css('display') == 'block') {
        setCurrentTimeToMedia($('#' + content_id + ' ' + type), ui.value);
        $('#' + content_id + ' ._media_player_current_time').html(secondsToDateString(ui.value));
      }
    }
  });
  initializeMediaTimeUpdater('#' + content_id + ' ' + type, content_id);
  $('#' + content_id + ' ' + type).bind('ended', function() {
    stopMedia(this);
  });
  $('#' + content_id).data('initialized', true);
}

function stopMedia(media) {
  try {
    if($(media).length != 0) {
      var has_source = true;
      $(media).find('source').each(function() {
        if($(this).attr('src') == '') {
          has_source = false;
        }
      });
      if(has_source) {
        var container_id = $(media).parent().attr('id');
        $('#' + container_id + ' ._media_player_pause').click();
        $('#' + container_id + ' ._media_player_slider').slider('value', 0);
        $('#' + container_id + ' ._media_player_current_time').html(secondsToDateString(0));
        setCurrentTimeToMedia($(media), 0);
      }
    }
  } catch(err) {
    console.log('error stopping media: ' + err);
  }
}


// VIDEO PLAYERS IN VIDEO EDITOR

function initializeMediaTimeUpdaterInVideoEditor(media, identifier) {
  media = $(media);
  if(media.readyState != 0) {
    media[0].addEventListener('timeupdate', function() {
      initializeActionOfMediaTimeUpdaterInVideoEditor(this, identifier);
    }, false);
  } else {
    media.on('loadedmetadata', function() {
      media[0].addEventListener('timeupdate', function() {
        initializeActionOfMediaTimeUpdaterInVideoEditor(this, identifier);
      }, false);
    });
  }
}

function initializeActionOfMediaTimeUpdaterInVideoEditor(media, identifier) {
  var video_cut_to = $('#video_component_' + identifier + '_cutter').data('to');
  var parsed_int = parseInt(media.currentTime);
  if(parsed_int == (video_cut_to + 1)) {
    var initial_time = $('#video_component_' + identifier + '_cutter').data('from');
    if(!$('#video_editor_global_preview').data('in-use')) {
      $('#video_component_' + identifier + '_cutter ._media_player_pause_in_video_editor_preview').click();
      $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', initial_time);
    }
    setCurrentTimeToMedia($(media), initial_time);
  } else if($('#video_component_' + identifier + '_cutter ._media_player_play_in_video_editor_preview').css('display') == 'none') {
    if($('#video_editor_global_preview').data('in-use')) {
      increaseVideoEditorPreviewTimer();
    } else {
      $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', parsed_int);
    }
  }
}

function initializeVideoInVideoEditorPreview(identifier) {
  var my_cutter = $('#video_component_' + identifier + '_cutter');
  $('#video_component_' + identifier + '_preview video').on('loadeddata', function() {
    setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), my_cutter.data('from'));
  });
  var video_max_to = my_cutter.data('max-to');
  my_cutter.find('._media_player_slider').slider({
    min: 0,
    max: video_max_to,
    value: my_cutter.data('from'),
    slide: function(event, ui) {
      if(my_cutter.find('._media_player_play_in_video_editor_preview').css('display') == 'block') {
        setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), ui.value);
      }
    }
  });
  my_cutter.find('._double_slider').slider({
    min: 0,
    max: video_max_to,
    range: true,
    values: [my_cutter.data('from'), my_cutter.data('to')],
    start: function(event, ui) {
      my_cutter.find('.ui-slider-handle').removeClass('selected');
      $(ui.handle).addClass('selected');
    },
    slide: function(event, ui) {
      my_cutter.data('changed', true);
      var left_val = ui.values[0];
      var right_val = ui.values[1];
      var cursor_val = my_cutter.find('._media_player_slider').slider('value');
      if(left_val != my_cutter.data('from')) {
        if(cursor_val < left_val) {
          selectVideoComponentCutterHandle(my_cutter, left_val);
        }
      } else {
        if(cursor_val > right_val) {
          selectVideoComponentCutterHandle(my_cutter, right_val);
        }
      }
    },
    stop: function(event, ui) {
      var left_val = ui.values[0];
      var right_val = ui.values[1];
      if(left_val != my_cutter.data('from')) {
        if(left_val == right_val) {
          my_cutter.find('._double_slider').slider('values', 0, left_val - 1);
          left_val -= 1;
        }
        cutVideoComponentLeftSide(identifier, left_val);
      }
      if(right_val != my_cutter.data('to')) {
        if(left_val == right_val) {
          my_cutter.find('._double_slider').slider('values', 1, right_val + 1);
          right_val += 1;
        }
        cutVideoComponentRightSide(identifier, right_val);
      }
    }
  });
  my_cutter.find('._double_slider .ui-slider-range').mousedown(function(e) {
    return false;
  });
  $('#video_component_' + identifier + '_cutter ._media_player_slider .ui-slider-handle').addClass('selected');
  initializeMediaTimeUpdaterInVideoEditor('#video_component_' + identifier + '_preview video', identifier);
  $('#video_component_' + identifier + '_preview video').bind('ended', function() {
    stopVideoInVideoEditorPreview(identifier);
  });
}

function stopVideoInVideoEditorPreview(identifier) {
  try {
    if($('#video_component_' + identifier + '_preview video').length != 0) {
      var has_source = true;
      $('#video_component_' + identifier + '_preview video').find('source').each(function() {
        if($(this).attr('src') == '') {
          has_source = false;
        }
      });
      if(has_source) {
        $('#video_component_' + identifier + '_cutter ._media_player_pause_in_video_editor_preview').click();
        var initial_time = $('#video_component_' + identifier + '_cutter').data('from');
        $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', initial_time);
        setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), initial_time);
      }
    }
  } catch(err) {
    console.log('error stopping media: ' + err);
  }
}

function selectVideoComponentCutterHandle(cutter, val) {
  setCurrentTimeToMedia($('#' + cutter.attr('id').replace('cutter', 'preview') + ' video'), val);
  cutter.find('._media_player_slider').slider('value', val);
}


// FUNCTIONS WHICH ARE VALID IN ANY CASE

function setCurrentTimeToMedia(media, x) {
  if(media.readyState != 0) {
    media[0].currentTime = x;
  } else {
    media.on('loadedmetadata', function() {
      media[0].currentTime = x;
    });
  }
}

function stopAllMedia() {
  $('audio, video').each(function() {
    stopMedia(this);
  });
}
