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
    $('#' + container_id + ' ._media_player_current_time').html(parsed_int);
    $('#' + container_id + ' ._media_player_slider').slider('value', parsed_int);
  }
}

function initializeMediaSlider(content_id, type, duration) {
  $('#' + content_id + ' ._media_player_slider').slider({
    min: 0,
    max: duration,
    range: 'min',
    value: 0,
    slide: function(event, ui) {
      if($('#' + content_id + ' ._media_player_play').css('display') == 'block') {
        setCurrentTimeToMedia($('#' + content_id + ' ' + type), ui.value);
        $('#' + content_id + ' ._media_player_current_time').html(ui.value);
      }
    }
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
    $(this)[0].pause();
  });
}
