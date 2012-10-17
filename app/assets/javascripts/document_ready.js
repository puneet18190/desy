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
    var destination = $(this).data('destination');
    addLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_copy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    copyLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_destroy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    destroyLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_dislike', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    dislikeLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_like', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    likeLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_preview', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    previewLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_publish', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    publishLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    removeLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_unpublish', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    unpublishLesson(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_add_virtual_classroom', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    addLessonToVirtualClassroom(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove_virtual_classroom', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    removeLessonFromVirtualClassroom(my_param, destination);
    return false;
  });
  
  
  // MEDIA ELEMENT BUTTONS
  
  $('body').on('click', '._MediaElement_button_add', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    addMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_destroy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    destroyMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_preview', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    previewMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._MediaElement_button_remove', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    removeMediaElement(my_param, destination);
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
  initializeHelp();
  
});
