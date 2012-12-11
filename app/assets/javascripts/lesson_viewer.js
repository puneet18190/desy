$(document).ready(function() {
  
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  
  $('#carousel_ul li').first().addClass('_lesson_viewer_current_slide');
  
  var lessonsNum = $('.playlistMenu ul li').length;
  
  $('.scrollContent').css('width', (lessonsNum * 285) + 'px');
  
  $('.playlistMenu ul li').click(function() {
    var lessonPos = $(this).attr('data-param');
    var goToPos = $('#carousel_ul li.lesson_' + lessonPos + ':first').index();
    $('.playlistMenu').slideToggle('slow', function() {
      $('#right_scroll a,#left_scroll a').toggle();
    });
    $('#carousel_ul').animate({
      'left': -(goToPos*900)
    }, {
      queue: false,
      duration: 500
    }, function() {
      //evaluate if needed
    });
  });
  
  $('a._playlist').click(function() {
    $('.playlistMenu').slideToggle('slow', function() {
      $('#right_scroll a,#left_scroll a').toggle();
    });
  });
  
  $(document.documentElement).keyup(function (event) {
    if (event.keyCode == 37) {
      scrollLesson('left');
    } else if (event.keyCode == 39) {
      scrollLesson('right');
    }
  });
  
  $('#right_scroll a').click(function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    scrollLesson('right');
  });
  
  $('#left_scroll a').click(function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    scrollLesson('left');
  });
  
});

function stopMediaInLessonViewer() {
  stopMedia('._lesson_viewer_current_slide audio');
  stopMedia('._lesson_viewer_current_slide video');
}

function scrollLesson(direction) {
  var current_slide = $('#carousel_ul li._lesson_viewer_current_slide');
  var lessonsItems = $('#carousel_ul li.slide').length;
  var viewerWidth = 900 * lessonsItems;
  var item_width = $('#carousel_ul li.slide').outerWidth();
  if(direction == 'right') {
    current_slide.next().addClass('_lesson_viewer_current_slide');
    current_slide.removeClass('_lesson_viewer_current_slide');
    var left_indent = parseInt($('#carousel_ul').css('left')) - item_width;
  } else {
    current_slide.prev().addClass('_lesson_viewer_current_slide');
    current_slide.removeClass('_lesson_viewer_current_slide');
    var left_indent = parseInt($('#carousel_ul').css('left')) + item_width;
  }
  if(left_indent == -viewerWidth) {
    console.log("into top");
    left_indent = 0;
    $('#carousel_ul li.slide').first().addClass('_lesson_viewer_current_slide');
  } else if(left_indent > 0) {
    console.log("into bottom");
    left_indent = - ((lessonsItems - 1)*900);
    $('#carousel_ul li.slide').last().addClass('_lesson_viewer_current_slide');
  }
  $('#carousel_ul').animate({
    'left': left_indent
  }, {
    queue: false,
    duration:500
  }, function() {
    //evaluate if needed
  });
}
