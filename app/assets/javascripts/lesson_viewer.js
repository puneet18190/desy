$(document).ready(function() {
  
  initializeLessonViewer();
  
  $('body').on('click', '.playlistMenu ul li', function() {
    var lessonPos = $(this).attr('data-param');
    scrollPlaylist(lessonPos);
    var goToPos = $('#carousel_ul li.lesson_' + lessonPos + ':first').index();
    var new_cover = $('._cover_bookmark_for_lesson_viewer_' + $(this).data('lesson-id'));
    $('#info_container').data('slide-number', new_cover.data('overall-counter'));
    $('._lesson_title_in_playlist:visible').hide();
    $('._lesson_title_in_playlist').eq(lessonPos - 1).show();
    $('.playlistMenu').slideToggle('slow', function() {
      showArrowsInLessonViewer();
    });
    $('#carousel_ul').animate({
      'left': -(goToPos*900)
    });
    $('a._open_playlist span').toggle();
    $('a._close_playlist span').toggle();
  });
  
  $('body').on('click', 'a._open_playlist', function() {
    $('.playlistMenu').slideToggle('slow', function() {
      hideArrowsInLessonViewer();
    });
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
  
  $(document.documentElement).keyup(function (event) {
    if (event.keyCode == 37) {
      stopMediaInLessonViewer();
      scrollLesson('left');
    } else if (event.keyCode == 39) {
      stopMediaInLessonViewer();
      scrollLesson('right');
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
    scrollLesson('right');
    updateLessonTitle();
  });
  
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    scrollLesson('left');
    updateLessonTitle();
  });
  
});

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

function scrollPlaylist(lesson_number) {
  var current_slide_number = $('#info_container').data('slide-number');
  var new_slide = $('li.lesson_' + lesson_number + ':first');
  $('#slide_in_lesson_viewer_' + current_slide_number).removeClass('_lesson_viewer_current_slide');
  new_slide.addClass('_lesson_viewer_current_slide');
  $('#info_container').data('slide-number', new_slide.data('overall-counter'));
}

function scrollLesson(direction) {
  var slides_amount = lessonViewerSlidesAmount();
  var current_slide_number = $('#info_container').data('slide-number');
  $('#slide_in_lesson_viewer_' + current_slide_number).removeClass('_lesson_viewer_current_slide');
  if(direction == 'right') {
    if(current_slide_number == slides_amount) {
      left_indent = 0;
      $('#slide_in_lesson_viewer_1').addClass('_lesson_viewer_current_slide');
      $('#info_container').data('slide-number', 1);
    } else {
      $('#slide_in_lesson_viewer_' + (current_slide_number + 1)).addClass('_lesson_viewer_current_slide');
      $('#info_container').data('slide-number', (parseInt(current_slide_number) + 1));
      left_indent = parseInt(current_slide_number) * 900;
    }
  } else {
    if(current_slide_number == 1) {
      left_indent = ((slides_amount - 1) * 900);
      $('#slide_in_lesson_viewer_' + slides_amount).addClass('_lesson_viewer_current_slide');
      $('#info_container').data('slide-number', (parseInt(slides_amount)));
    } else {
      $('#slide_in_lesson_viewer_' + (current_slide_number - 1)).addClass('_lesson_viewer_current_slide');
      $('#info_container').data('slide-number', (parseInt(current_slide_number) - 1));
      left_indent = parseInt(current_slide_number - 2) * 900;
    }
  }
  $('#carousel_ul').fadeOut('fast');
  $('#carousel_ul').animate({
    'left': '-' + left_indent + 'px'
  }, 500, function() {
    $('#carousel_ul').fadeIn('fast');
  });
}
