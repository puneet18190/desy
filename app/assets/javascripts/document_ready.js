$(document).ready(function() {

  // BROWSER DETECTION: DECLARING BROWSER NAME AND VERSION AS HTML TAG CLASS
  (function(){
    var name = $.grep(Object.keys($.browser), function(el, i) {
      return el !== 'version';
    })[0];

    if(name) $('html').addClass(name);
  })();

  // OTHER BUTTONS
  
  $('._load_media_element').click(function(e) {
    e.preventDefault();
    showLoadMediaElementPopUp();
  });
  
  
  // DEFAULT VALUE FOR JAVASCRIPT ANIMATIONS
  
  $('._which_item_to_search_switch[checked]').first().attr('checked', 'checked');
  
  $('#for_page_media_elements option[selected]').first().attr('selected', 'selected');
  
  $('#filter_media_elements option[selected]').first().attr('selected', 'selected');
  
  $('#filter_lessons option[selected]').first().attr('selected', 'selected');
  
  $('#filter_search_lessons option[selected]').first().attr('selected', 'selected');
  
  $('#filter_search_media_elements option[selected]').first().attr('selected', 'selected');
  
  $('#filter_search_lessons_subject option[selected]').first().attr('selected', 'selected');
  
  $('._order_lessons_radio_input[checked]').first().attr('checked', 'checked');
  
  $('._order_media_elements_radio_input[checked]').first().attr('checked', 'checked');
  
  
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
        obj.show();
      });
    } else {
      var button = $('#' + this.id + ' a._reportable_icon');
      button.removeClass('_report_selected');
      button.removeClass('report_light');
      button.addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.hide();
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
        obj.show();
      });
    } else {
      $(this).removeClass('report_light');
      $(this).addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.hide();
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
        my_expanded.hide();
      });
    } else {
      my_expanded.show('blind', {}, 500, function() {
        my_expanded.show();
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
        obj1.show();
      });
      $(this).removeClass('change_info');
      $(this).addClass('change_info_light');
    } else {
      obj1.hide('fade', {}, 500, function() {
        obj1.hide();
      });
      $(this).addClass('change_info');
      $(this).removeClass('change_info_light');
    }
  });
  
  
  // MEDIA ELEMENT GALLERY
  
  $('body').on('click','._image_gallery_thumb', function(e) {
    e.preventDefault();
    showImageInGalleryPopUp($(this).data('image-id'));
  });
  
  $('body').on('click','._video_gallery_thumb', function(e) {
    e.preventDefault();
    showVideoInGalleryPopUp($(this).data('video-id'));
  });
  
  $('body').on('click', '._audio_gallery_thumb ._compact', function(e) {
    if(!$(e.target).hasClass('_select_audio_from_gallery')) {
      var parent_id = $(this).parent().attr('id');
      var obj = $('#' + parent_id + ' ._expanded');
      if(obj.css('display') == 'block') {
        $('#' + parent_id).removeClass('_audio_expanded_in_gallery');
        stopMedia('#' + parent_id + ' audio');
        obj.hide('blind', {}, 500);
      } else {
        var currently_open = $('._audio_expanded_in_gallery');
        if(currently_open.length != 0) {
          currently_open.removeClass('_audio_expanded_in_gallery');
          stopMedia('#' + currently_open.attr('id') + ' audio');
          $('#' + currently_open.attr('id') + ' ._expanded').hide('blind', {}, 500);
        }
        $('#' + parent_id).addClass('_audio_expanded_in_gallery');
        obj.show('blind', {}, 500);
      }
    }
  });
  
  $('body').on('click', '._close_mixed_gallery_in_video_editor', function() {
    closeMixedGalleryInVideoEditor();
  });
  
  $('body').on('click', "._close_on_click_out", function(){
    $(".ui-dialog-content:visible").each(function(){
      closePopUp($(this).attr("id"));
    });
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
    var redirect_back_to = $("#info_container").data('currenturl');
    previewLesson(my_param, redirect_back_to);
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
  
  $('body').on('click', '._Video_button_edit', function(e) {
    e.preventDefault();
    var video_id = $(this).data('clickparam');
    window.location = 'videos/' + video_id + '/edit';
    return false;
  });
  
  $('body').on('click', '._Audio_button_edit', function(e) {
    alert('ancora non abbiamo editor di audio');
  });
  
  $('body').on('click', '._Image_button_edit', function(e) {
    e.preventDefault();
    var image_id = $(this).data('clickparam');
    window.location = 'images/' + image_id + '/edit';
    return false;
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
  
  $('body').on('keyup blur', 'input[maxlength], textarea[maxlength]', function () {
    var myself = $(this);
    var len = myself.val().length;
    var maxlength = myself.attr('maxlength')
    if (maxlength && len > maxlength) {
      myself.val(myself.val().slice(0, maxlength));
    }
  });
  
  
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
      $('#search_media_elements_main_page').show();
      $('#search_lessons_main_page').hide();
      if($('#general_pagination').css('display') == 'block') {
        $('#general_pagination').hide();
      } else {
        $('#general_pagination').show();
      }
    });
  });
  
  $('body').on('click', '#which_item_to_search_switch_lessons', function() {
    $('#search_media_elements_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').hide();
      $('#search_lessons_main_page').show();
      if($('#general_pagination').css('display') == 'block') {
        $('#general_pagination').hide();
      } else {
        $('#general_pagination').show();
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
  
  
  // VIRTUAL CLASSROOM
  
  $('body').on('click', '._virtual_classroom_lesson ._lesson_thumb', function() {
    var lesson_id = $(this).data('lesson-id');
    var redirect_to = $('#info_container').data('currenturl');
    window.location.href = '/lessons/' + lesson_id + '/view?back=' + encodeURIComponent(redirect_to);
  });
  
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
    $('#' + this.id + ' ._remove_lesson_from_playlist').show();
  });
  
  $('body').on('mouseout', '._lesson_in_playlist', function() {
    $('#' + this.id + ' ._remove_lesson_from_playlist').hide();
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
    var cover = $('#' + this.id + ' ._lesson_thumb');
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
  
  // IMAGE EDITOR
  
  $('#image_gallery_for_image_editor ._select_image_from_gallery').addClass('_add_image_to_image_editor');
  $('body').on('click','._add_image_to_image_editor', function(){
    window.location = '/images/'+$(this).data('image-id')+'/edit';
  });
  
  // VIDEO EDITOR
  
  $('body').on('click', '._exit_video_editor', function() {
    var captions = $('#popup_captions_container');
    showConfirmPopUp(captions.data('exit-video-editor-title'), captions.data('exit-video-editor-confirm'), captions.data('exit-video-editor-yes'), captions.data('exit-video-editor-no'), function() {
      $('dialog-confirm').hide();
      $.ajax({
        type: 'post',
        url: '/videos/cache/empty',
        success: function() {
          window.location = '/dashboard';
        }
      });
    }, function() {
      closePopUp('dialog-confirm');
    });
  });
  
  $('body').on('mouseover', '._video_editor_component_hover', function() {
    var father = $(this).parent();
    $('#' + father.attr('id') + ' ._video_editor_component_menu').show();
  });
  
  $('body').on('mouseout', '._video_editor_component_hover', function() {
    var father = $(this).parent();
    $('#' + father.attr('id') + ' ._video_editor_component_menu').hide();
  });
  
  $('body').on('mouseover', '._new_component_in_video_editor_hover', function() {
    $('._new_component_in_video_editor_hover a').addClass('current');
  });
  
  $('body').on('mouseout', '._new_component_in_video_editor_hover', function() {
    $('._new_component_in_video_editor_hover a').removeClass('current');
  });
  
  $('body').on('click', '._new_component_in_video_editor_button', function() {
    var father = $(this).parent().parent().parent().parent();
    var infos = $('#info_container');
    if($(this).hasClass('_replace_component')) {
      infos.data('replacing-component', true);
      infos.data('current-component', 'video_component_' + father.data('position'));
    } else {
      infos.data('replacing-component', false);
      infos.data('current-component', 'video_component_' + (infos.data('components-number') + 1));
    }
    if($('#video_editor_mixed_gallery_container').data('loaded')) {
      $('#video_editor').hide();
      $('#video_editor_mixed_gallery_container').css('display', 'inline-block');
      resetVideoEditorTextComponent();
    } else {
      $.ajax({
        type: 'get',
        url: '/videos/galleries'
      });
    }
  });
  
  $('body').on('click', '#video_editor_mixed_gallery_container ._switch_video', function() {
    $('._switch_image, ._switch_text').removeClass('current');
    $(this).addClass('current');
    switchToOtherGalleryInMixedGalleryInVideoEditor('._videos');
  });
  
  $('body').on('click', '#video_editor_mixed_gallery_container ._switch_image', function() {
    $('._switch_video, ._switch_text').removeClass('current');
    $(this).addClass('current');
    switchToOtherGalleryInMixedGalleryInVideoEditor('._images');
  });
  
  $('body').on('click', '#video_editor_mixed_gallery_container ._switch_text', function() {
    $('._switch_image, ._switch_video').removeClass('current');
    $(this).addClass('current');
    switchToOtherGalleryInMixedGalleryInVideoEditor('._texts');
  });
  
  $('body').on('click', '._add_video_component_to_video_editor', function() {
    var video_id = $(this).data('video-id');
    var popup_id = 'dialog-video-gallery-' + video_id;
    var component = $('#' + popup_id + ' ._temporary').html();
    var duration = $(this).data('duration');
    var current_component = $('#info_container').data('current-component');
    closePopUp(popup_id);
    setTimeout(closeMixedGalleryInVideoEditor, 700);
    setTimeout(function() {
      highlightAndUpdateVideoComponentIcon(current_component, 'videoIcon');
    }, 1400);
    if($('#info_container').data('replacing-component')) {
      replaceVideoComponentInVideoEditor(video_id, component, current_component, duration);
    } else {
      addVideoComponentInVideoEditor(video_id, component, duration);
    }
  });
  
  $('body').on('click', '._add_image_component_to_video_editor', function() {
    var popup_id = 'dialog-image-gallery-' + $(this).data('image-id');
    $('#' + popup_id + ' ._bottom_of_image_popup_in_gallery').hide();
    $('#' + popup_id + ' ._duration_selector').show();
    $('#' + popup_id + ' ._duration_selector input').val('');
  });
  
  $('body').on('click', '._add_image_component_to_video_editor_after_select_duration', function() {
    var image_id = $(this).data('image-id')
    var popup_id = 'dialog-image-gallery-' + image_id;
    var duration = parseInt($('#' + popup_id + ' input').val());
    if(isNaN(duration) || duration < 1) {
      showErrorPopUp($('#popup_captions_container').data('invalid-component-duration-in-video-editor'));
    } else {
      var component = $('#' + popup_id + ' ._temporary').html();
      var current_component = $('#info_container').data('current-component');
      closePopUp(popup_id);
      setTimeout(closeMixedGalleryInVideoEditor, 700);
      setTimeout(function() {
        highlightAndUpdateVideoComponentIcon(current_component, 'photoIcon');
      }, 1400);
      if($('#info_container').data('replacing-component')) {
        replaceImageComponentInVideoEditor(image_id, component, current_component, duration);
      } else {
        addImageComponentInVideoEditor(image_id, component, duration);
      }
    }
  });
  
  $('body').on('click', '._add_audio_track_to_video_editor', function() {
    alert('stai aggiungendo la traccia audio');
  });
  
  $('body').on('click', '._image_gallery_thumb_in_mixed_gallery_video_editor', function(e) {
    e.preventDefault();
    var image_id = $(this).data('image-id');
    showImageInGalleryPopUp(image_id, function() {
      var popup_id = 'dialog-image-gallery-' + image_id;
      $('#' + popup_id + ' ._bottom_of_image_popup_in_gallery').show();
      $('#' + popup_id + ' ._duration_selector').hide();
    });
  });
  
  $('body').on('click', '._text_component_in_video_editor_background_color_selector ._color', function() {
    var old_background_color = $('#text_component_preview').data('background-color');
    var new_background_color = $(this).data('color');
    switchTextComponentBackgroundColor(old_background_color, new_background_color);
  });
  
  $('body').on('click', '._text_component_in_video_editor_text_color_selector ._color', function() {
    var old_text_color = $('#text_component_preview').data('text-color');
    var new_text_color = $(this).data('color');
    switchTextComponentTextColor(old_text_color, new_text_color);
  });
  
  $('body').on('focus', '#text_component_preview textarea', function() {
    var preview = $('#text_component_preview');
    if(preview.data('placeholder')) {
      preview.data('placeholder', false);
      $(this).val('');
    }
  });
  
  $('body').on('click', '#insert_text_component_in_video_editor', function() {
    var preview = $('#text_component_preview');
    var background_color = preview.data('background-color');
    var text_color = preview.data('text-color');
    var duration = parseInt($('#video_editor_mixed_gallery_container ._texts ._duration_selector input').val());
    if(isNaN(duration) || duration < 1) {
      showErrorPopUp($('#popup_captions_container').data('invalid-component-duration-in-video-editor'));
    } else if(preview.data('placeholder')) {
      showErrorPopUp($('#popup_captions_container').data('empty-text-component-in-video-editor'));
    } else {
      var content = $('#text_component_preview textarea').val();
      var component = $('#video_editor_mixed_gallery_container ._texts ._temporary').html();
      var current_component = $('#info_container').data('current-component');
      closeMixedGalleryInVideoEditor();
      setTimeout(function() {
        highlightAndUpdateVideoComponentIcon(current_component, 'textIcon');
      }, 700);
      if($('#info_container').data('replacing-component')) {
        replaceTextComponentInVideoEditor(component, content, current_component, duration, background_color, text_color);
      } else {
        addTextComponentInVideoEditor(component, content, duration, background_color, text_color);
      }
    }
  });
  
  initializeVideoEditor();
  
  
  // PLAYERS
  
  $('body').on('click', '._media_player_play', function() {
    $(this).hide();
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    $('#' + container_id + ' ._media_player_slider_disabler').show();
    $('#' + container_id + ' ._media_player_pause').show();
    var media = $('#' + container_id + ' ' + type);
    if(media.readyState != 0) {
      media[0].play();
    } else {
      media.on('loadedmetadata', function() {
        media[0].play();
      });
    }
  });
  
  $('body').on('click', '._media_player_pause', function() {
    $(this).hide();
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    $('#' + container_id + ' ._media_player_slider_disabler').hide();
    $('#' + container_id + ' ._media_player_play').show();
    $('#' + container_id + ' ' + type)[0].pause();
  });
  
  $('body').on('click', '._video_full_screen', function() {
    var container_id = $(this).parent().attr('id');
    $('#' + container_id + ' video').fullScreen(true);
  });
  
});
