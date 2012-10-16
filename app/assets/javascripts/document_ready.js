$(document).ready(function() {
  
  
  // DASHBOARD SWITCH
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  
  // FILTERS
  
  $('#filter_lessons').change(function() {
    var filter = $('#filter_lessons option:selected').val();
    window.location.href = '/lessons?filter=' + filter;
  });
  
  
  // EXPAND LESSON
  
  $('body').on('click','._lesson_compact',function() {
    var my_id = this.id;
    var my_expanded = $('#' + my_id + ' ._lesson_expanded');
    if(my_expanded.css('display') == 'block') {
      my_expanded.css('display', 'none');
    } else {
      my_expanded.css('display', 'block');
    }
  });
  
  
  // DIALOGS AND POPUPS
  
  $("#dialog-error").dialog({
    autoOpen: false,
  });
  
  $("#dialog-shade").dialog({
    autoOpen: false,
  });
  
  $("#dialog-timed").dialog({
    autoOpen: false,
  });
  
  
  // LESSON BUTTONS
  
  $('body').on('click', '._Lesson_button_add', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    addLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_copy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    copyLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_destroy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    destroyLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_dislike', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    dislikeLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_like', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    likeLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_preview', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    previewLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_publish', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    publishLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    removeLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_unpublish', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    unpublishLesson(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_add_virtual_classroom', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    addLessonToVirtualClassroom(my_param);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove_virtual_classroom', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    removeLessonFromVirtualClassroom(my_param);
    return false;
  });
  
  
  // MEDIA ELEMENT BUTTONS
  
  $('body').on('click', '._MediaElement_button_add', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    addMediaElement(my_param);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_destroy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    destroyMediaElement(my_param);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_preview', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    previewMediaElement(my_param);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_remove', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    removeMediaElement(my_param);
    return false;
  });
  
  
  // JAVASCRIPT ANIMATIONS
  
  $('.scroll-pane').jScrollPane({
    autoReinitialise: true
  });
  
  $("#sceltaElementi").selectbox();
  
  $("#filter_lessons").selectbox();
  
  $("#format_media_elements").selectbox();
  
  $("#filter_media_elements").selectbox();
  
  
  // NOTIFICATIONS
  
  initializeNotifications();
  
});
