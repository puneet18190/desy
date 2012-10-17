$(document).ready(function() {
  
  
  // DASHBOARD SWITCH
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  
  // REPORT FORMS
  
  $('body').on('click', '._report_lesson_click', function() {
    var param = $(this).data('param');
    $('#lesson_report_form_' + param).css('display', 'block');
    return false;
  });
  
  $('body').on('click', '._report_media_element_click', function() {
    var param = $(this).data('param');
    $('#media_element_report_form_' + param).css('display', 'block');
    return false;
  });
  
  
  // FILTERS
  
  function getMediaElementsFormat() {
    var param = 'format=compact';
    if($('#format_media_elements .current').attr('href') == '/media_elements?format=expanded') {
      param = 'format=expanded';
    }
    return param
  }
  
  function getCompleteMediaElementsUrlWithoutFilter() {
    var param_format = getMediaElementsFormat();
    var param_for_page = 'for_page=' + $('#for_page_media_elements option:selected').val();
    return '/media_elements?' + param_format + '&' + param_for_page;
  }
  
  function getCompleteMediaElementsUrlWithoutForPage() {
    var param_format = getMediaElementsFormat();
    var param_filter = 'filter=' + $('#filter_media_elements option:selected').val();
    return '/media_elements?' + param_format + '&' + param_filter;
  }
  
  $('#filter_lessons').change(function() {
    var filter = $('#filter_lessons option:selected').val();
    window.location.href = '/lessons?filter=' + filter;
  });
  
  $('#filter_media_elements').change(function() {
    var filter = $('#filter_media_elements option:selected').val();
    window.location.href = getCompleteMediaElementsUrlWithoutFilter() + '&filter=' + filter;
  });
  
  $('#for_page_media_elements').change(function() {
    var for_page = $('#for_page_media_elements option:selected').val();
    window.location.href = getCompleteMediaElementsUrlWithoutForPage() + '&for_page=' + for_page;
  });
  
  
  // EXPAND LESSON
  
  $('body').on('click','._lesson_compact', function() {
    var my_id = this.id;
    var my_expanded = $('#' + my_id + ' ._lesson_expanded');
    if(my_expanded.css('display') == 'block') {
      my_expanded.css('display', 'none');
    } else {
      my_expanded.css('display', 'block');
    }
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
  
  $('body').on('click', '._Video_button_add, ._Audio_button_add, ._Image_button_add', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    addMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Video_button_destroy, ._Audio_button_destroy, ._Image_button_destroy', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    destroyMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Video_button_preview, ._Audio_button_preview, ._Image_button_preview', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    previewMediaElement(my_param, destination);
    return false;
  });
  
  $('body').on('click', '._Video_button_remove, ._Audio_button_remove, ._Image_button_remove', function(e) {
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
  
  $("#for_page_media_elements").selectbox();
  
  $("#filter_media_elements").selectbox();
  
  
  // NOTIFICATIONS
  
  initializeNotifications();
  initializeHelp();
  
});
