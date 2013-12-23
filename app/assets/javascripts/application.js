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
//= require jquery_patches
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
//= require tinymce-jquery
//= require dots_pagination
//= require jquery.formparams
//= require ajax_loader
//= require audio_editor
//= require buttons
//= require dashboard
//= require dialogs
//= require documents
//= require galleries
//= require general
//= require image_editor
//= require lesson_editor
//= require lesson_viewer
//= require media_element_editor
//= require notifications
//= require players
//= require profile
//= require search
//= require tags
//= require uploader
//= require video_editor
//= require virtual_classroom


$(document).ready(function() {
  initializeGlobalVariables();
  browsersDocumentReady();
  globalDocumentReady();
  var in_dashboard = ($('#dashboard_container').length > 0);
  var in_documents = ($('#my_documents').length > 0);
  var in_lessons = ($('#my_lessons').length > 0);
  var in_media_elements = ($('#my_media_elements').length > 0);
  var in_profile = ($('#profile_title_bar').length > 0);
  var in_search = ($('#search_lessons_main_page').length > 0 && $('#search_media_elements_main_page').length > 0);
  var in_virtual_classroom = ($('#my_virtual_classroom').length > 0);
  if(in_dashboard) {
    dashboardDocumentReady();
  }
  if(in_documents) {
    sectionDocumentsDocumentReady();
  }
  if(in_lessons) {
    sectionLessonsDocumentReady();
  }
  if(in_media_elements) {
    sectionMediaElementsDocumentReady();
  }
  if(in_search) {
    sectionSearchDocumentReady();
  }
  if(in_dashboard || in_documents || in_lessons || in_media_elements || in_profile || in_search || in_virtual_classroom) {
    sectionNotificationsDocumentReady();
  }
  if(in_dashboard || in_media_elements || in_search) {
    commonMediaElementsDocumentReady();
  }
  if(in_dashboard || in_lessons || in_search) {
    commonLessonsDocumentReady();
  }
  // TODO ottimizz a partire da qui non è ottimizzato
  ajaxLoaderDocumentReady();
  audioEditorDocumentReady();
  automaticLoginDocumentReady();
  documentsDocumentReady();
  galleriesDocumentReady();
  imageEditorDocumentReady();
  lessonButtonsDocumentReady();
  lessonEditorDocumentReady();
  lessonViewerDocumentReady();
  locationsDocumentReady();
  mediaElementButtonsDocumentReady();
  mediaElementEditorDocumentReady();
  mediaElementLoaderDocumentReady();
  notificationsDocumentReady();
  playersDocumentReady();
  preloginDocumentReady();
  profileDocumentReady();
  purchaseCodeRegistrationDocumentReady();
  reportsDocumentReady();
  searchDocumentReady();
  tagsDocumentReady();
  videoEditorDocumentReady();
  virtualClassroomDocumentReady();
});
