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
  var duration = $('#video_component_' + identifier + '_preview').data('duration');
  var parsed_int = parseInt(media.currentTime);
  if(parsed_int == (duration + 1)) {
    $('#video_component_' + identifier + '_cutter ._media_player_pause').click();
    $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', 0);
    $('#video_component_' + identifier + '_cutter ._media_player_current_time').html(secondsToDateString(0));
    setCurrentTimeToMedia($(media), 0);
  } else if($('#video_component_' + identifier + '_cutter ._media_player_play_in_video_editor_preview').css('display') == 'none') {
    $('#video_component_' + identifier + '_cutter ._media_player_current_time').html(secondsToDateString(parsed_int));
    $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', parsed_int);
  }
}

function initializeVideoInVideoEditorPreview(identifier) {
  var duration = $('#video_component_' + identifier + '_preview').data('duration');
  $('#video_component_' + identifier + '_cutter ._media_player_slider').slider({
    min: 0,
    max: duration,
    range: 'min',
    value: 0,
    slide: function(event, ui) {
      if($('#video_component_' + identifier + '_cutter ._media_player_play_in_video_editor_preview').css('display') == 'block') {
        setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), ui.value);
        $('#video_component_' + identifier + '_cutter ._media_player_current_time').html(secondsToDateString(ui.value));
      }
    }
  });
  initializeMediaTimeUpdaterInVideoEditor('#video_component_' + identifier + '_preview video', identifier);
  $('#video_component_' + identifier + '_preview video').bind('ended', function() {
    stopMedia(this);
  });
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
