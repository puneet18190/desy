$(document).ready(function() {
  
  
  // DASHBOARD SWITCH
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  
  // REPORT FORMS
  
  $('body').on('mouseover', '._report_lesson_click', function() {
    var obj = $('#' + this.id + ' a._reportable_icon');
    if(!obj.hasClass('_report_selected')) {
      obj.removeClass('report');
      obj.addClass('report_light');
    }
  });
  
  $('body').on('mouseout', '._report_lesson_click', function() {
    var obj = $('#' + this.id + ' a._reportable_icon');
    if(!obj.hasClass('_report_selected')) {
      obj.removeClass('report_light');
      obj.addClass('report');
    }
  });
  
  $('body').on('click', '._report_lesson_click', function() {
    var param = $(this).data('param');
    var obj = $('#lesson_report_form_' + param);
    if(obj.css('display') == 'none') {
      var button = $('#' + this.id + ' a._reportable_icon');
      button.addClass('_report_selected');
      button.removeClass('report');
      button.addClass('report_light');
      obj.show('fade', {}, 500, function() {
        obj.css('display', 'block');
      });
    } else {
      var button = $('#' + this.id + ' a._reportable_icon');
      button.removeClass('_report_selected');
      button.removeClass('report_light');
      button.addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.css('display', 'none');
      });
    }
    return false;
  });
  
  $('body').on('click', '._report_media_element_click', function() {
    var param = $(this).data('param');
    var obj = $('#media_element_report_form_' + param);
    if(obj.css('display') == 'none') {
      $(this).removeClass('report');
      $(this).addClass('report_light');
      obj.show('fade', {}, 500, function() {
        obj.css('display', 'block');
      });
    } else {
      $(this).removeClass('report_light');
      $(this).addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.css('display', 'none');
      });
    }
    return false;
  });
  
  $('body').on('click', '._report_form_content', function(e) {
    e.preventDefault();
    return false;
  });
  
  $('body').on('click', '._report_form_content ._send', function(e) {
    $(this).closest('form').submit();
  });
  
  
  // FILTERS
  
  function getMediaElementsFormat() {
    var param = 'display=compact';
    if($('#format_media_elements .current').attr('href') == '/media_elements?display=expanded') {
      param = 'display=expanded';
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
    var redirect_url = '/lessons?filter=' + filter;
    $.ajax({
      type: 'get',
      url: redirect_url
    });
  });
  
  $('#filter_media_elements').change(function() {
    var filter = $('#filter_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutFilter() + '&filter=' + filter;
    $.ajax({
      type: 'get',
      url: redirect_url
    });
  });
  
  $('#for_page_media_elements').change(function() {
    var for_page = $('#for_page_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutForPage() + '&for_page=' + for_page;
    $.ajax({
      type: 'get',
      url: redirect_url
    });
  });
  
  
  // EXPAND LESSON
  
  $('body').on('click','._lesson_compact', function() {
    var my_id = $(this).parent().attr('id');
    var my_expanded = $('#' + my_id + ' ._lesson_expanded');
    if(my_expanded.css('display') == 'block') {
      my_expanded.hide('blind', {}, 500, function() {
        my_expanded.css('display', 'none');
      });
    } else {
      my_expanded.show('blind', {}, 500, function() {
        my_expanded.css('display', 'block');
      });
    }
  });
  
  
  // EXPANDED MEDIA ELEMENT
  
  $('body').on('click', '._close_popup', function() {
    var param = $(this).data('param');
    closePopUp('dialog-media-element-' + param);
  });
  
  $('body').on('click', '._change_info_to_pick', function() {
    var obj1 = $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container');
    if(obj1.css('display') == 'none') {
      obj1.show('fade', {}, 500, function() {
        obj1.css('display', 'block');
      });
      $(this).removeClass('change_info');
      $(this).addClass('change_info_light');
    } else {
      obj1.hide('fade', {}, 500, function() {
        obj1.css('display', 'none');
      });
      $(this).addClass('change_info');
      $(this).removeClass('change_info_light');
    }
  });
  
  
  // LESSON BUTTONS
  
  $('body').on('click', '._Lesson_button_add', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    var reload = $(this).data('reload');
    var current_url = $('#info_container').data('currenturl');
    addLesson(my_param, destination, current_url, reload);
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
    var current_url = $('#info_container').data('currenturl');
    destroyLesson(my_param, destination, current_url);
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
    var reload = $(this).data('reload');
    var current_url = $('#info_container').data('currenturl');
    removeLesson(my_param, destination, current_url, reload);
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
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    var reload = $(this).data('reload');
    var current_url = $('#info_container').data('currenturl');
    addMediaElement(my_param, destination, current_url, reload);
  });
  
  $('body').on('click', '._Video_button_destroy, ._Audio_button_destroy, ._Image_button_destroy', function(e) {
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    var current_url = $('#info_container').data('currenturl');
    destroyMediaElement(my_param, destination, current_url);
  });
  
  $('body').on('click', '._Video_button_preview, ._Audio_button_preview, ._Image_button_preview', function(e) {
    var my_param = $(this).data('clickparam');
    showMediaElementInfoPopUp(my_param);
  });
  
  $('body').on('click', '._Video_button_remove, ._Audio_button_remove, ._Image_button_remove', function(e) {
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    var reload = $(this).data('reload');
    var current_url = $('#info_container').data('currenturl');
    removeMediaElement(my_param, destination, current_url, reload);
  });
  
  
  // JAVASCRIPT ANIMATIONS
  
  $('.scroll-pane').jScrollPane({
    autoReinitialise: true
  });
  
  $("#sceltaTipo").selectbox();
  
  $("#filter_lessons").selectbox();
  
  $("#filter_search_lessons").selectbox();
  
  $("#filter_search_lessons_subject").selectbox();
  
  $("#for_page_media_elements").selectbox();
  
  $("#filter_media_elements").selectbox();
  
  $("#filter_search_media_elements").selectbox();
  
  
  // NOTIFICATIONS
  
  initializeNotifications();
  initializeHelp();
  
  $('#tooltip_content .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    if(isAtBottom && (parseInt($('#tooltip_content').data('offset')) < parseInt($('#tooltip_content').data('totnumber')))) {
      var offset = $('#tooltip_content').data('offset');
      $.ajax({
        type: 'get',
        url: '/notifications/get_new_block?offset=' + offset
      });
    }
  });
  
  $('body').on('click', '._destroy_notification', function() {
    var my_id = $(this).data('param');
    var offset = $('#tooltip_content').data('offset');
    $.ajax({
      type: 'post',
      url: '/notifications/' + my_id + '/destroy?offset=' + offset
    });
  });
  
  
  // SEARCH ITEMS
  
  $('body').on('focus', '#general_tag_reader_for_search', function() {
    $('#general_tag_kind_for_search').attr('value', '0');
  });
  
  $('body').on('focus', '#lessons_tag_reader_for_search', function() {
    $('#lessons_tag_kind_for_search').attr('value', '0');
  });
  
  $('body').on('focus', '#media_elements_tag_reader_for_search', function() {
    $('#media_elements_tag_kind_for_search').attr('value', '0');
  });
  
});
