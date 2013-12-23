// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require underscore
//= require url_parser
//= require jquery
//= require ../jquery_patches
//= require jquery_ujs
//= require jquery.mousewheel
//= require jquery.jscrollpane
//= require jquery.fullscreen
//= require jquery.event.move
//= require jquery.event.swipe
//= require jquery.selectbox-0.2.custom
//= require jquery-ui-1.9.0.custom
//= require jquery.imgareaselect
//= require jquery.peity
//= require jquery-fileupload/basic
//= require jquery.formparams
//= require ../general
//= require ../lesson_viewer
//= require ../players

$(document).ready(function() {
  initializeGlobalVariables();
  browsersDocumentReady();
  
  
  
  
  defaultValueJavaScriptAnimationsDocumentReady();
  filtersDocumentReady();
  expandedItemsDocumentReady();
  javaScriptAnimationsDocumentReady();
  playersDocumentReady();
  lessonViewerDocumentReady();
  var scrolls = $('#left_scroll, #right_scroll');
  $('.lesson-archive-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  $(window).resize(function() {
    $('.lesson-archive-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
  $('.lesson-archive-layout').on('swiperight', function() {
    if(mustReactToSwipe()) {
      moveToAdhiacentSlideInLessonViewer(scrolls, goToPrevSlideInLessonViewer);
    }
  });
  $('.lesson-archive-layout').on('swipeleft', function() {
    if(mustReactToSwipe()) {
      moveToAdhiacentSlideInLessonViewer(scrolls, goToNextSlideInLessonViewer);
    }
  });
  lessonViewerDocumentReadyWirisConvertSrc();
  $('#footer').css('top', (parseInt($(window).outerHeight()) - 40) + 'px').css('width', (parseInt($(window).outerWidth()) - 24) + 'px');
  $(window).resize(function() {
    $('#footer').css('top', ($(window).height() - 40) + 'px').css('width', ($(window).width() - 24) + 'px');
  });
  $body.on('click', 'a.target_blank_mce', function(e) {
    e.preventDefault();
    window.open($(this).attr('href'), '_blank').focus();
  });
});
