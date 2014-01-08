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
  if($('#audio_editor').length > 0) { // in audio editor
    audioEditorDocumentReady();
    galleriesDocumentReady();
  }
  if($('#dashboard_container').length > 0) { // in dashboard
    commonLessonsDocumentReady();
    commonMediaElementsDocumentReady();
    dashboardDocumentReady();
    lessonButtonsDocumentReady();
    sectionNotificationsDocumentReady();
  }
  if($('#my_documents').length > 0) { // in section documents
    documentsDocumentReady();
    sectionDocumentsDocumentReady();
    sectionNotificationsDocumentReady();
  }
  if($('#image_editor').length > 0 || $('#image_gallery_for_image_editor').length > 0) { // in image editor
    galleriesDocumentReady();
    imageEditorDocumentReady();
  }
  if($('.lesson-editor-container').length > 0) { // in lesson editor
    galleriesDocumentReady();
    lessonEditorDocumentReady();
  }
  if($('#my_lessons').length > 0) { // in section lessons
    commonLessonsDocumentReady();
    lessonButtonsDocumentReady();
    sectionLessonsDocumentReady();
    sectionNotificationsDocumentReady();
  }
  if($('#my_media_elements').length > 0) { // in section elements
    commonMediaElementsDocumentReady();
    sectionMediaElementsDocumentReady();
    sectionNotificationsDocumentReady();
  }
  if($html.hasClass('prelogin-layout')) { // in prelogin
    preloginDocumentReady();
  }
  if($('#profile_title_bar').length > 0) { // in section profile
    sectionNotificationsDocumentReady();
  }
  if($('#search_lessons_main_page').length > 0 && $('#search_media_elements_main_page').length > 0) { // in search engine
    commonLessonsDocumentReady();
    commonMediaElementsDocumentReady();
    lessonButtonsDocumentReady();
    sectionNotificationsDocumentReady();
    sectionSearchDocumentReady();
  }
  if($('#video_editor').length > 0) { // in video editor
    galleriesDocumentReady();
  }
  if($('#my_virtual_classroom').length > 0) { // in virtual classroom
    sectionNotificationsDocumentReady();
  }
  
  // TODO ottimizz a partire da qui non è ottimizzato
  lessonViewerDocumentReady();
  locationsDocumentReady();
  mediaElementButtonsDocumentReady();
  mediaElementEditorDocumentReady();
  mediaElementLoaderDocumentReady();
  notificationsDocumentReady();
  playersDocumentReady();
  profileDocumentReady();
  purchaseCodeRegistrationDocumentReady();
  reportsDocumentReady();
  searchDocumentReady();
  tagsDocumentReady();
  videoEditorDocumentReady();
  virtualClassroomDocumentReady();
});
