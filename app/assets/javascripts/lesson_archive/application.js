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
  window.$body = $('body');
  window.$captions = $('#popup_captions_container');
  window.$parameters = $('#popup_parameters_container');
  browsersDocumentReady();
  generalWindowResizeDocumentReady();
  defaultValueJavaScriptAnimationsDocumentReady();
  filtersDocumentReady();
  expandedItemsDocumentReady();
  javaScriptAnimationsDocumentReady();
  playersDocumentReady();
  lessonViewerDocumentReady();
});
