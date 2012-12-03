function initializeAudioPlayers() {
  $('body').on('click', '._audio_player ._play', function() {
    alert('play');
  });
  $('body').on('click', '._audio_player ._stop', function() {
    alert('stop');
  });
  
}

function initializeAudioSlider(selector) {
  $(selector).slider();
}

function initializeVideoPlayers() {
}

function initializeVideoSlider(selector) {
}
