$(document).ready(function() {
  
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  
  var slides = $('#carousel_ul li.slide');
  current_slide = $('#carousel_ul li._lesson_viewer_current_slide');
  current_slide_number = $('#info_container').data("slide-number");
  slides_amount = slides.length;
  $('#carousel_ul').css("width", (slides_amount * 900) + "px").css("left",0);
  slides.first().addClass('_lesson_viewer_current_slide');
  
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
  if(direction == 'right') {
    if(current_slide_number == slides_amount) {
      left_indent = 0;
      $('#carousel_ul li.slide').first().addClass('_lesson_viewer_current_slide');
      $('#info_container').data("slide-number", 1);
      current_slide_number = 1;
    } else {
    current_slide.next().addClass('_lesson_viewer_current_slide');
    current_slide.removeClass('_lesson_viewer_current_slide');
    $('#info_container').data("slide-number", (parseInt(current_slide_number) + 1));
    current_slide_number = $('#info_container').data("slide-number");
    left_indent = parseInt(current_slide_number - 1) * 900;
    }
  } else {
    if(current_slide_number == 1) {
      left_indent = ((slides_amount - 1) * 900);
      $('#carousel_ul li.slide').last().addClass('_lesson_viewer_current_slide');
      $('#info_container').data("slide-number", (parseInt(slides_amount)));
      current_slide_number = slides_amount;
    } else {
      current_slide.prev().addClass('_lesson_viewer_current_slide');
      current_slide.removeClass('_lesson_viewer_current_slide');
      $('#info_container').data("slide-number", (parseInt(current_slide_number) - 1));
      current_slide_number = $('#info_container').data("slide-number");
      left_indent = parseInt(current_slide_number - 1) * 900;
    }
  }
  $('#carousel_ul').fadeOut("fast");
  $('#carousel_ul').animate({
    'left': '-'+left_indent+"px"
  },500,function(){
    $('#carousel_ul').fadeIn("fast");
  });
}
