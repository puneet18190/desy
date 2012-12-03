$(document).ready(function() {
  
  
  // OTHER BUTTONS
  
  $('._load_media_element').click(function(e) {
    e.preventDefault();
    showLoadMediaElementPopUp();
  });
  
  
  // DEFAULT VALUE FOR JAVASCRIPT ANIMATIONS
  
  var attr = $('#which_item_to_search_switch_media_elements').attr('checked');
  if(typeof(attr) !== 'undefined' && attr !== false) {
    $('#which_item_to_search_switch_media_elements').attr('checked', 'checked');
  } else {
    $('#which_item_to_search_switch_lessons').attr('checked', 'checked');
  }
  
  var for_page_media_elements = $('#for_page_media_elements option').first();
  if(for_page_media_elements.attr('selected') != '') {
    for_page_media_elements.attr('selected', 'selected');
  }
  
  var filter_media_elements = $('#filter_media_elements option').first();
  if(filter_media_elements.attr('selected') != '') {
    filter_media_elements.attr('selected', 'selected');
  }
  
  var filter_lessons = $('#filter_lessons option').first();
  if(filter_lessons.attr('selected') != '') {
    filter_lessons.attr('selected', 'selected');
  }
  
  var filter_search_lessons = $('#filter_search_lessons option').first();
  if(filter_search_lessons.attr('selected') != '') {
    filter_search_lessons.attr('selected', 'selected');
  }
  
  var filter_search_media_elements = $('#filter_search_media_elements option').first();
  if(filter_search_media_elements.attr('selected') != '') {
    filter_search_media_elements.attr('selected', 'selected');
  }
  
  var filter_search_lessons_subject = $('#filter_search_lessons_subject option').first();
  if(filter_search_lessons_subject.attr('selected') != '') {
    filter_search_lessons_subject.attr('selected', 'selected');
  }
  
  var attr = $('#updated_at_lessons_radio_input').attr('checked');
  if(typeof(attr) !== 'undefined' && attr !== false) {
    $('#updated_at_lessons_radio_input').attr('checked', 'checked');
  }
  
  var attr = $('#updated_at_media_elements_radio_input').attr('checked');
  if(typeof(attr) !== 'undefined' && attr !== false) {
    $('#updated_at_media_elements_radio_input').attr('checked', 'checked');
  }
  
  
  // DASHBOARD
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  $('body').on('mouseover', '._large_dashboard_hover_lesson', function() {
    $('._large_dashboard_hover_lesson a').addClass('current_plus');
  });
  
  $('body').on('mouseout', '._large_dashboard_hover_lesson', function() {
    $('._large_dashboard_hover_lesson a').removeClass('current_plus');
  });
  
  $('body').on('mouseover', '._large_dashboard_hover_media_element', function() {
    $('._large_dashboard_hover_media_element a').addClass('current_plus');
  });
  
  $('body').on('mouseout', '._large_dashboard_hover_media_element', function() {
    $('._large_dashboard_hover_media_element a').removeClass('current_plus');
  });
  
  $('body').on('click', '._large_dashboard_hover_lesson', function() {
    window.location = '/lessons/new';
  });
  
  $('body').on('click', '._large_dashboard_hover_media_element', function() {
    alert('questa parte manca ancora');
  });
  
  
  // FORMS
  
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
  
  $('body').on('change', '#filter_lessons', function() {
    var filter = $('#filter_lessons option:selected').val();
    var redirect_url = '/lessons?filter=' + filter;
    $.get(redirect_url);
  });
  
  $('body').on('change', '#filter_media_elements', function() {
    var filter = $('#filter_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutFilter() + '&filter=' + filter;
    $.get(redirect_url);
  });
  
  $('body').on('change', '#for_page_media_elements', function() {
    var for_page = $('#for_page_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutForPage() + '&for_page=' + for_page;
    $.get(redirect_url);
  });
  
  $('body').on('click', '._clickable_tag_for_lessons', function() {
    var param = $(this).data('param');
    $('#lessons_tag_kind_for_search').attr('value', param);
    $('#search_lessons').submit();
  });
  
  $('body').on('click', '._clickable_tag_for_media_elements', function() {
    var param = $(this).data('param');
    $('#media_elements_tag_kind_for_search').attr('value', param);
    $('#search_media_elements').submit();
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
  
  $('body').on('click', '._close_media_element_preview_popup', function() {
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
  
  
  // MEDIA ELEMENT GALLERY
  
  $('body').on('click','._image_gallery_thumb', function(e) {
    e.preventDefault();
    var my_id = 'dialog-image-gallery-' + $(this).data('image-id');
    showMediaElementInGalleryPopUp(my_id);
  });
  
  $('body').on('click','._audio_gallery_thumb', function(e) {
    e.preventDefault();
    var my_id = 'dialog-audio-gallery-' + $(this).data('audio-id');
    showMediaElementInGalleryPopUp(my_id);
  });
  
  $('body').on('click','._video_gallery_thumb', function(e) {
    e.preventDefault();
    var my_id = 'dialog-video-gallery-' + $(this).data('video-id');
    showMediaElementInGalleryPopUp(my_id);
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
  
  $('body').on('click', '._Lesson_button_edit', function(e) {
    e.preventDefault();
    var my_param = $(this).data('clickparam');
    window.location = '/lessons/' + my_param + '/slides/edit';
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
  
  $('body').on('click', '._Video_button_edit, ._Audio_button_edit, ._Image_button_edit', function(e) {
    alert('questa parte manca ancora');
  });
  
  $('body').on('click', '._Video_button_remove, ._Audio_button_remove, ._Image_button_remove', function(e) {
    var my_param = $(this).data('clickparam');
    var destination = $(this).data('destination');
    var reload = $(this).data('reload');
    var current_url = $('#info_container').data('currenturl');
    removeMediaElement(my_param, destination, current_url, reload);
  });
  
  
  // JAVASCRIPT ANIMATIONS
  
  $('#playlist_menu').jScrollPane({
    autoReinitialise: true
  });
  
  $('#notifications_list').jScrollPane({
    autoReinitialise: true
  });
  
  $("#which_item_to_search").selectbox();
  
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
    var tot_number = $('#tooltip_content').data('tot-number');
    var offset = $('#tooltip_content').data('offset');
    if(isAtBottom && (offset < tot_number)) {
      $.get('/notifications/get_new_block?offset=' + offset);
    }
  });
  
  $('body').on('click', '._destroy_notification', function() {
    var my_id = $(this).data('param');
    var offset = $('#tooltip_content').data('offset');
    $.post('/notifications/' + my_id + '/destroy?offset=' + offset);
  });
  
  
  // SEARCH ITEMS
  
  $('body').on('click', '#which_item_to_search_switch_media_elements', function() {
    $('#search_lessons_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').css('display', 'block');
      $('#search_lessons_main_page').css('display', 'none');
      if($('#general_pagination').css('display') == 'block') {
        $('#general_pagination').css('display', 'none');
      } else {
        $('#general_pagination').css('display', 'block');
      }
    });
  });
  
  $('body').on('click', '#which_item_to_search_switch_lessons', function() {
    $('#search_media_elements_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').css('display', 'none');
      $('#search_lessons_main_page').css('display', 'block');
      if($('#general_pagination').css('display') == 'block') {
        $('#general_pagination').css('display', 'none');
      } else {
        $('#general_pagination').css('display', 'block');
      }
    });
  });
  
  $('body').on('focus', '#general_tag_reader_for_search', function() {
    $(this).attr('value', '');
    $(this).css('color', '#939393');
    $('#general_tag_kind_for_search').attr('value', '0');
    $('#search_general_submit').removeClass('current');
  });
  
  $('body').on('focus', '#lessons_tag_reader_for_search', function() {
    $(this).attr('value', '');
    $(this).css('color', '#939393');
    $('#lessons_tag_kind_for_search').attr('value', '0');
    $('#search_lessons_submit').removeClass('current');
  });
  
  $('body').on('focus', '#media_elements_tag_reader_for_search', function() {
    $(this).attr('value', '');
    $(this).css('color', '#939393');
    $('#media_elements_tag_kind_for_search').attr('value', '0');
    $('#search_media_elements_submit').removeClass('current');
  });
  
  $('body').on('click', '#search_general_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_general').submit();
      $(this).addClass('current');
    }
  });
  
  $('body').on('click', '#search_media_elements_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_media_elements').submit();
      $(this).addClass('current');
    }
  });
  
  $('body').on('click', '#search_lessons_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_lessons').submit();
      $(this).addClass('current');
    }
  });
  
  $('body').on('change', '#filter_search_lessons_subject', function() {
    $('#search_lessons_submit').removeClass('current');
  });
  
  $('body').on('change', '#filter_search_lessons', function() {
    $('#search_lessons_submit').removeClass('current');
  });
  
  $('body').on('change', '#filter_search_media_elements', function() {
    $('#search_media_elements_submit').removeClass('current');
  });
  
  $('body').on('change', '._order_media_elements_radio_input', function() {
    $('#search_media_elements_submit').removeClass('current');
  });
  
  $('body').on('change', '._order_lessons_radio_input', function() {
    $('#search_lessons_submit').removeClass('current');
  });
  
  
  // FAKE UPLOAD BUTTONS
  
  new FakeUpload($('._fakeUploadTrigger'));
  
  
  // POPUPS
  //   CHIUSURA
  //   es. <a data-dialog-id="load-media-element"></a>
  
  $('._close').click(function(){
    closePopUp($(this).data('dialog-id'));
  });
  
  // LESSON VIEWER
  
  
  // VIRTUAL CLASSROOM
  
  $('body').on('click', '._remove_lesson_from_inside_virtual_classroom', function() {
    var lesson_id = $(this).data('clickparam');
    var current_url = $('#info_container').data('currenturl');
    var redirect_url = addDeleteItemToCurrentUrl(current_url, ('virtual_classroom_lesson_' + lesson_id));
    $.ajax({
      type: 'post',
      dataType: 'json',
      url: '/virtual_classroom/' + lesson_id + '/remove_lesson_from_inside',
      success: function(data) {
        if(data.ok) {
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
  });
  
  initializeVirtualClassroom();
  
  $('body').on('mouseover', '._lesson_in_playlist', function() {
    $('#' + this.id + ' ._remove_lesson_from_playlist').css('display', 'block');
  });
  
  $('body').on('mouseout', '._lesson_in_playlist', function() {
    $('#' + this.id + ' ._remove_lesson_from_playlist').css('display', 'none');
  });
  
  $('body').on('click', '._remove_lesson_from_playlist', function() {
    var lesson_id = $(this).data('clickparam');
    $.ajax({
      type: 'post',
      url: '/virtual_classroom/' + lesson_id + '/remove_lesson_from_playlist'
    });
  });
  
  $('body').on('click', '._empty_playlist_button', function() {
    $.ajax({
      type: 'post',
      url: '/virtual_classroom/empty_playlist'
    });
  });
  
  $('body').on('click', '._send_lesson_link', function() {
    var lesson_id = $(this).data('lesson-id');
    showSendLessonLinkPopUp(lesson_id);
  });
  
  $('body').on('click', '#dialog-virtual-classroom-send-link ._yes', function() {
    closePopUp('dialog-virtual-classroom-send-link');
    $('._send_link_form_text_area').each(function() {
      if($(this).data('not-yet-selected')) {
        $(this).attr('value', '');
      }
    });
    $('#dialog-virtual-classroom-send-link form').submit();
  });
  
  $('body').on('click', '#dialog-virtual-classroom-send-link ._no', function() {
    var obj = $('#dialog-virtual-classroom-send-link');
    obj.dialog('option', 'hide', 'fade');
    closePopUp('dialog-virtual-classroom-send-link');
    obj.dialog('option', 'hide', null);
  });
  
  $('body').on('focus', '._send_link_form_text_area', function() {
    if($(this).data('not-yet-selected')) {
      $(this).attr('value', '');
      $(this).data('not-yet-selected', false);
    }
  });
  
  $('body').on('click', '._virtual_classroom_quick_loaded_lesson', function() {
    var cover = $('#' + this.id + ' ._cover_slide_thumb');
    if(!cover.hasClass('current')) {
      var appended = $('#' + this.id + ' ._current_inserted');
      if(appended.length == 0) {
        $('#' + this.id + ' input').val('1');
        cover.append('<div class="currentInserted _current_inserted"><a></a></div>');
      } else {
        $('#' + this.id + ' input').val('0');
        appended.remove();
      }
    }
  });
  
  $('body').on('mouseover', '._current_inserted', function(){
    $(this).children('a').css('background-position', '-10em -0.1em');
  });
  
  $('body').on('mouseout', '._current_inserted', function(){
    $(this).children('a').css('background-position', '-10em -15.2em');
  });
  
  $('body').on('click', '#virtual_classroom_quick_select_submit', function() {
    $('#virtual_classroom_quick_select_container form').submit();
  });
  
  $('body').on('click', '#virtual_classroom_quick_select_close', function() {
    $('.dialog_opaco').removeClass('dialog_opaco');
    closePopUp('dialog-virtual-classroom-quick-select');
  });
  
  
  // VIDEO EDITOR
  
  initializeVideoEditor();
  
  $('body').on('mouseover', '._video_editor_component', function() {
    $('#' + this.id + ' ._video_editor_component_menu').css('display', 'block');
    $('#' + this.id + ' ._video_editor_component_icon').css('display', 'none');
  });
  
  $('body').on('mouseout', '._video_editor_component', function() {
    $('#' + this.id + ' ._video_editor_component_menu').css('display', 'none');
    $('#' + this.id + ' ._video_editor_component_icon').css('display', 'block');
  });
  
  
  // PLAYERS
  
  $('body').on('click', '._play', function() {
    $(this).css('display', 'none');
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    $('#' + container_id + ' ._slider_disabler').css('display', 'block');
    $('#' + container_id + ' ._pause').css('display', 'block');
    $('#' + container_id + ' ' + type)[0].play();
  });
  $('body').on('click', '._pause', function() {
    $(this).css('display', 'none');
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    $('#' + container_id + ' ._slider_disabler').css('display', 'none');
    $('#' + container_id + ' ._play').css('display', 'block');
    $('#' + container_id + ' ' + type)[0].pause();
  });
  $('audio, video').each(function() {
    initializeMediaTimeUpdater(this);
  });
  
});
