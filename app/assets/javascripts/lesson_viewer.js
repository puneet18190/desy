$(document).ready(function() {
  
  initializeLessonViewer();
  
  $('body').on('click', '.playlistMenu ul li', function() {
    $('.playlistMenu').slideToggle('slow', function() {
      showArrowsInLessonViewer();
      slideToInLessonViewer($('._cover_bookmark_for_lesson_viewer_' + $(this).data('lesson-id')));
      $('a._open_playlist span').toggle();
      $('a._close_playlist span').toggle();
    });
  });
  
  $('body').on('click', 'a._open_playlist', function() {
    stopMediaInLessonViewer();
    hideArrowsInLessonViewer();
    $('.playlistMenu').slideToggle('slow');
    $(this).find('span').toggle();
    $('a._close_playlist span').toggle();
  });
  
  $('body').on('click', 'a._close_playlist', function() {
    $('.playlistMenu').slideToggle('slow', function() {
      showArrowsInLessonViewer();
    });
    $(this).find('span').toggle();
    $('a._open_playlist span').toggle();
  });
  
  $(document.documentElement).keyup(function(e) {
    if(e.keyCode == 37) {
      goToPrevSlideInLessonViewer();
    } else if(e.keyCode == 39) {
      goToNextSlideInLessonViewer();
    }
  });
  
  $('body').on('click', '#right_scroll', function(e) {
    e.preventDefault();
    goToNextSlideInLessonViewer();
  });
  
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    goToPrevSlideInLessonViewer();
  });
  
});

function getLessonViewerCurrentSlide() {
  $('#' + $('._lesson_viewer_current_slide').attr('id'));
}

function slideToInLessonViewer(to) {
  stopMediaInLessonViewer();
  var from = getLessonViewerCurrentSlide();
  from.removeClass('_lesson_viewer_current_slide');
  to.addClass('_lesson_viewer_current_slide');
  from.hide('fade', {}, 500, function() {
    to.show();
  });
  var lesson_id = to.data('lesson-id');
  if($('._lesson_title_in_playlist').data('lesson-id') != lesson_id) {
    $('._lesson_title_in_playlist').hide();
    $('#lesson_viewer_playlist_title_' + lesson_id).show();
  }
}

function hideArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').hide();
}

function showArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').show();
}

function initializeLessonViewer() {
  $('#playlist_menu').jScrollPane({
    autoReinitialise: true
  });
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  $(window).resize(function() {
    $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
}

function stopMediaInLessonViewer() {
  var current_slide_id = $('._lesson_viewer_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}

function goToNextSlideInLessonViewer() {
  var next_slide = getLessonViewerCurrentSlide().next();
  if(next_slide.length == 0) {
    slideToInLessonViewer($('#slide_in_lesson_viewer_1'));
  } else {
    slideToInLessonViewer(next_slide);
  }
}

function goToPrevSlideInLessonViewer() {
  var prev_slide = getLessonViewerCurrentSlide().prev();
  if(prev_slide.length == 0) {
    slideToInLessonViewer($('._slide_in_lesson_viewer').last());
  } else {
    slideToInLessonViewer(prev_slide);
  }
}
