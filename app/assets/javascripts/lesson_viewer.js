$(document).ready(function() {
  
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  
  $(window).resize(function() {
    $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
  
  var slides = $('#carousel_ul li.slide');
  current_slide = $('#carousel_ul li._lesson_viewer_current_slide');
  slides_amount = slides.length;
  $('#carousel_ul').css("width", (slides_amount * 900) + "px").css("left",0);
  slides.first().addClass('_lesson_viewer_current_slide');
  
  var lessonsNum = $('.playlistMenu ul li').length;
  $('.scrollContent').css('width', ((lessonsNum * 305)-55) + 'px');
  
  $("._lesson_title_in_playlist").first().show();
  $('.playlistMenu ul li:last').css("margin","0");
  $('.playlistMenu ul li').click(function() {
    var lessonPos = $(this).attr('data-param');
    scrollPlaylist(lessonPos);
    var goToPos = $('#carousel_ul li.lesson_' + lessonPos + ':first').index();
    var new_cover = $('._cover_bookmark_for_lesson_viewer_' + $(this).data('lesson-id'));
    $('#info_container').data('slide-number', new_cover.data('overall-counter'));
    
    $("._lesson_title_in_playlist:visible").hide();
    $("._lesson_title_in_playlist").eq(lessonPos - 1).show();

    
    $('.playlistMenu').slideToggle('slow', function() {
      $('#right_scroll a,#left_scroll a').toggle();
    });
    $('#carousel_ul').animate({
      'left': -(goToPos*900)
    });
    
    $('a._playlist span').toggle();
    
  });
  
  $('a._playlist').click(function() {
    $('.playlistMenu').slideToggle('slow', function() {
      $('#right_scroll a, #left_scroll a').toggle();
    });
    $(this).find('span').toggle();
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
  
  
  $('#right_scroll a, a.navRight').hover(function(){
    $('a.navRight').fadeTo("fast",1);
  },function(){
    $('a.navRight').fadeTo("fast",0.6);
  });
  
  $('#left_scroll a, a.navLeft').hover(function(){
    $('a.navLeft').fadeTo("fast",1);
  },function(){
    $('a.navLeft').fadeTo("fast",0.6);
  });
  
  $('#right_scroll a, a.navRight').click(function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    scrollLesson('right');
    updateLessonTitle();
  });
  
  $('#left_scroll a, a.navLeft').click(function(e) {
    e.preventDefault();
    stopMediaInLessonViewer();
    scrollLesson('left');
    updateLessonTitle();
  });
  
});

function updateLessonTitle(){
  current_lesson = $("._lesson_viewer_current_slide").data("lesson-position");
  $("._lesson_title_in_playlist:visible").hide();
  $("._lesson_title_in_playlist").eq(current_lesson - 1).show();
}

function stopMediaInLessonViewer() {
  var current_slide_id = $('._lesson_viewer_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}
function scrollPlaylist(lesson_number){
  current_slide_number = $('#info_container').data("slide-number");
  $('#slide_in_lesson_viewer_' + current_slide_number).removeClass('_lesson_viewer_current_slide');
  new_slide = $("li.lesson_"+lesson_number+":first");
  new_slide.addClass('_lesson_viewer_current_slide');
  $('#info_container').data('slide-number', new_slide.data("overall-counter"));
}

function scrollLesson(direction) {
  current_slide_number = $('#info_container').data("slide-number");
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
  $('#carousel_ul').fadeOut("fast");
  $('#carousel_ul').animate({
    'left': '-'+left_indent+"px"
  },500,function(){
    $('#carousel_ul').fadeIn("fast");
  });
}
