$(document).ready(function() {
  
  initializeLessonViewer();
  
  $('body').on('click', '.playlistMenu ul li', function() {
    var lesson_id = $(this).data('lesson-id');
    $('.playlistMenu').slideToggle('slow', function() {
      showArrowsInLessonViewer();
      slideToInLessonViewer($('._cover_bookmark_for_lesson_viewer_' + lesson_id));
      $('._lesson_title_in_playlist').hide();
      $('#lesson_viewer_playlist_title_' + lesson_id).show();
      $('a._open_playlist span').toggle();
      $('a._close_playlist span').toggle();
    });
  });
  
  $('body').on('click', 'a._open_playlist', function() {
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
      stopMediaInLessonViewer();
      goToPrevSlideInLessonViewer();
    } else if(e.keyCode == 39) {
      stopMediaInLessonViewer();
      goToNextSlideInLessonViewer();
    }
    updateLessonTitle();
  });
  
  $('body').on('mouseover', '#right_scroll, #left_scroll', function() {
    $(this).fadeTo('fast', 1);
  });
  
  $('body').on('mouseout', '#right_scroll, #left_scroll', function() {
    $(this).fadeTo('fast', 0.6);
  });
  
  $('body').on('click', '#right_scroll', function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    goToNextSlideInLessonViewer();
    updateLessonTitle();
  });
  
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    goToPrevSlideInLessonViewer();
    updateLessonTitle();
  });
  
});

function getLessonViewerCurrentSlide() {
  $('#' + $('._lesson_viewer_current_slide').attr('id'));
}

function slideToInLessonViewer(to) {
  var from = getLessonViewerCurrentSlide();
  from.removeClass('_lesson_viewer_current_slide');
  to.addClass('_lesson_viewer_current_slide');
  from.hide('fade', {}, 500, function() {
    to.show();
  });
}

function hideArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').hide();
}

function showArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').show();
}

function initializeLessonViewer() {
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  $(window).resize(function() {
    $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
  $('#carousel_ul').css("width", (lessonViewerSlidesAmount() * 900) + 'px').css('left', 0);
  $('.scrollContent').css('width', ((lessonViewerLessonsAmount() * 306) - 58) + 'px');
  $('.playlistMenu ul li:last').css('margin', '0');
}

function lessonViewerSlidesAmount() {
  return $('#carousel_ul li.slide').length;
}

function lessonViewerLessonsAmount() {
  return $('.playlistMenu ul li').length;
}

function updateLessonTitle() {
  var current_lesson = $('._lesson_viewer_current_slide').data('lesson-position');
  $('._lesson_title_in_playlist:visible').hide();
  $('._lesson_title_in_playlist').eq(current_lesson - 1).show();
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
}
