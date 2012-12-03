function initializeAudioPlayers() {
  $('body').on('click', '._audio_player ._play', function() {
    $(this).css('display', 'none');
    var container_id = $(this).parent().attr('id');
    $('#' + container_id + ' ._slider_disabler').css('display', 'block');
    $('#' + container_id + ' ._pause').css('display', 'block');
    $('#' + container_id + ' audio')[0].play();
  });
  $('body').on('click', '._audio_player ._pause', function() {
    $(this).css('display', 'none');
    var container_id = $(this).parent().attr('id');
    $('#' + container_id + ' ._slider_disabler').css('display', 'none');
    $('#' + container_id + ' ._play').css('display', 'block');
    $('#' + container_id + ' audio')[0].pause();
  });
  $('audio').each(function() {
    initializeMediaTimeUpdater(this);
  });
}

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
  if($('#' + container_id + ' ._play').css('display') == 'none') {
    var parsed_int = parseInt(media.currentTime);
    $('#' + container_id + ' ._current_time').html(parsed_int);
    $('#' + container_id + ' ._slider').slider('value', parsed_int);
  }
}

function initializeAudioSlider(instance, audio_id, duration) {
  $('#instance_' + instance + '_of_audio_player ._slider').slider({
    min: 0,
    max: duration,
    value: 0,
    slide: function(event, ui) {
      if($('#instance_' + instance + '_of_audio_player ._play').css('display') == 'block') {
        setCurrentTimeToMedia($('#instance_' + instance + '_of_audio_player audio'), ui.value);
        $('#instance_' + instance + '_of_audio_player ._current_time').html(ui.value);
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

function interactWithVideo(x, since, until, element_id) {
  var old_since = backFromHour($('#video_cutter_' + x + ' .video_since').html());
  var active_current_value = parseInt(since);
  if(active_current_value == old_since) {
    active_current_value = until;
  }
  var my_video = $('#preview_' + element_id);
  var my_actual_video = my_video[0];

}




function initializeVideoPlayers() {
}

function initializeVideoSlider(selector) {
}

function stopAllVideos() {
  $('video').each(function() {
    $(this)[0].pause();
  });
}

function stopAllAudios() {
  $('audio').each(function() {
    $(this)[0].pause();
  });
}
