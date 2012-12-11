function initializeMediaTimeUpdater(media) {
  media = $(media);
  if(media.readyState != 0) {
    media[0].addEventListener('timeupdate', function() {
      initializeActionOfMediaTimeUpdater(this);
    }, false);
  } else {
    media.on('loadedmetadata', function() {
      media[0].addEventListener('timeupdate', function() {
        initializeActionOfMediaTimeUpdater(this);
      }, false);
    });
  }
}

function initializeActionOfMediaTimeUpdater(media) {
  var container_id = $(media).parent().attr('id');
  if($('#' + container_id + ' ._media_player_play').css('display') == 'none') {
    var parsed_int = parseInt(media.currentTime);
    $('#' + container_id + ' ._media_player_current_time').html(secondsToDateString(parsed_int));
    $('#' + container_id + ' ._media_player_slider').slider('value', parsed_int);
  }
}

function initializeMedia(content_id, type, mp4_duration, webm_duration) {
  // TODO settare duration in base al formato video supportato dal browser
  //      e riempire il div con la duration dentro shared/players/_video
  var duration = mp4_duration;
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
  initializeMediaTimeUpdater('#' + content_id + ' ' + type);
  $('#' + content_id + ' ' + type).bind('ended', function() {
    stopMedia(this);
  });
}

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
  var container_id = $(media).parent().attr('id');
  $('#' + container_id + ' ._media_player_pause').click();
  $('#' + container_id + ' ._media_player_slider').slider('value', 0);
  $('#' + container_id + ' ._media_player_current_time').html(secondsToDateString(0));
  setCurrentTimeToMedia($(media), 0)
}
