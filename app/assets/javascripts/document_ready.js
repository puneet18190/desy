$(document).ready(function() {
  
  
  // BROWSER DETECTION: DECLARING BROWSER NAME AND VERSION AS HTML TAG CLASS
  
  (function(){
    var name = $.grep(_.keys($.browser), function(el, i) {
      return el !== 'version';
    })[0];
    if(name) {
      $('html').addClass(name);
    }
    if($('html').hasClass('msie')) {
      $('._audio_editor_component ._double_slider .ui-slider-range').css('opacity', 0.4);
    }
  })();
  
  
  // AFTER WINDOW RESIZE
  
  $(window).resize(function() {
    if($('#my_media_elements').length > 0 || $('#media_elements_in_dashboard').length > 0){
      recenterMyMediaElements();
    }
  });

  var hac = $('.home-action .container');
  var widc = $('.what_is_desy-action .container');
  if($(window).height()>hac.height()){
    hac.css('margin-top',($(window).height() - hac.height())/2 + 'px');
  }

  if($(window).height()>widc.height()){
    widc.css('margin-top',($(window).height() - widc.height())/2 + 'px');
  }
  
  // LOADER
  
  bindLoader();
  
  
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
  
  $('body').on('mouseover', '._empty_media_elements', function() {
    $(this).find('._empty_media_elements_hover').addClass('current');
  });
  
  $('body').on('mouseout', '._empty_media_elements', function() {
    $(this).find('._empty_media_elements_hover').removeClass('current');
  });
  
  $('body').on('mouseover', '._empty_lessons', function() {
    $(this).find('._empty_lessons_hover').addClass('current');
  });
  
  $('body').on('mouseout', '._empty_lessons', function() {
    $(this).find('._empty_lessons_hover').removeClass('current');
  });
  
  $('body').on('click', '._empty_lessons', function() {
    window.location = '/lessons/new';
  });
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
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
    if(!obj.is(':visible')) {
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
    if(!obj.is(':visible')) {
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
    if($('#display_expanded_media_elements').hasClass('current')) {
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
  
  
  // EXPAND LESSON
  
  $('body').on('click','._lesson_compact', function() {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_id = $(this).parent().attr('id');
      var my_expanded = $('#' + my_id + ' ._lesson_expanded');
      if(my_expanded.is(':visible')) {
        my_expanded.find('._report_form_content').hide();
        my_expanded.find('._reportable_icon').removeClass('report_light _report_selected').addClass('report');
        my_expanded.hide('blind', {}, 500, function() {
          my_expanded.hide();
        });
      } else {
        my_expanded.show('blind', {}, 500, function() {
          my_expanded.show();
        });
      }
    }
  });
  
  
  // EXPANDED MEDIA ELEMENT
  
  $('body').on('click', '#display_expanded_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=expanded'
      });
    }
  });
  
  $('body').on('click', '#display_compact_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=compact'
      });
    }
  });
  
  $('body').on('click', '._close_media_element_preview_popup', function() {
    var param = $(this).data('param');
    closePopUp('dialog-media-element-' + param);
  });
  
  $('body').on('click', '._change_info_container ._cancel, ._change_info_to_pick.change_info_light', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').show();
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').hide('fade', {}, 500, function() {
      var icon = $(this);
      if(!$(this).hasClass('_change_info_to_pick')) {
        icon = $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_to_pick');
      }
      icon.addClass('change_info');
      icon.removeClass('change_info_light');
      resetMediaElementChangeInfo($(this).data('param'));
    });
  });
  
  $('body').on('click', '._change_info_to_pick.change_info', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').show('fade', {}, 500);
    $(this).removeClass('change_info');
    $(this).addClass('change_info_light');
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').hide();
  });
  
  
  // MEDIA ELEMENT GALLERY
  
  $('body').on('click','._image_gallery_thumb', function(e) {
    e.preventDefault();
    showImageInGalleryPopUp($(this).data('image-id'));
  });
  
  $('body').on('click','._video_gallery_thumb', function(e) {
    e.preventDefault();
    if(!$(this).hasClass('_disabled')) {
      showVideoInGalleryPopUp($(this).data('video-id'));
    }
  });
  
  $('body').on('click', '._audio_gallery_thumb._enabled ._compact', function(e) {
    if(!$(e.target).hasClass('_select_audio_from_gallery')) {
      var parent_id = $(this).parent().attr('id');
      var obj = $('#' + parent_id + ' ._expanded');
      if(obj.is(':visible')) {
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
        var instance_id = $('#' + parent_id + ' ._empty_audio_player, #' + parent_id + ' ._instance_of_player').attr('id');
        if(!$('#' + instance_id).data('initialized')) {
          var button = $(this).find('._select_audio_from_gallery');
          var duration = button.data('duration');
          $('#' + instance_id + ' source[type="audio/mp3"]').attr('src', button.data('mp3'));
          $('#' + instance_id + ' source[type="audio/ogg"]').attr('src', button.data('ogg'));
          $('#' + instance_id + ' audio').load();
          $('#' + instance_id + ' ._media_player_total_time').html(secondsToDateString(duration));
          $('#' + instance_id).data('duration', duration);
          $('#' + instance_id).removeClass('_empty_audio_player').addClass('_instance_of_player');
          initializeMedia(instance_id, 'audio');
        }
        obj.show('blind', {}, 500, function() {
          setTimeout(function() {
            var actual = $('#audio_gallery_content > div').data('jsp').getContentPositionY();
            $('#audio_gallery_content > div').data('jsp').scrollToY(actual + 55, true);
          }, 300);
        });
      }
    }
  });
  
  $('body').on('click', '._close_mixed_gallery_in_video_editor', function() {
    closeGalleryInVideoEditor('mixed');
  });
  
  $('body').on('click', '._close_audio_gallery_in_video_editor', function() {
    closeGalleryInVideoEditor('audio');
    var expanded_audio = $('._audio_expanded_in_gallery');
    if(expanded_audio.length > 0) {
      expanded_audio.removeClass('_audio_expanded_in_gallery');
      var audio_id = expanded_audio.attr('id');
      stopMedia('#' + audio_id + ' audio');
      $('#' + audio_id + ' ._expanded').hide();
    }
  });
  
  $('body').on('click', '._close_audio_gallery_in_audio_editor', function() {
    closeGalleryInAudioEditor();
    var expanded_audio = $('._audio_expanded_in_gallery');
    if(expanded_audio.length > 0) {
      expanded_audio.removeClass('_audio_expanded_in_gallery');
      var audio_id = expanded_audio.attr('id');
      stopMedia('#' + audio_id + ' audio');
      $('#' + audio_id + ' ._expanded').hide();
    }
  });
  
  $('body').on('click', "._close_on_click_out", function(){
    $(".ui-dialog-content:visible").each(function(){
      closePopUp($(this).attr("id"));
    });
  });
  
  
  // LESSON BUTTONS
  
  $('body').on('click', '._Lesson_button_add', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      addLesson(my_param, destination, current_url, reload);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_copy', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      copyLesson(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_destroy', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var current_url = $('#info_container').data('currenturl');
      destroyLesson(my_param, destination, current_url);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_dislike', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      dislikeLesson(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_like', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      likeLesson(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_preview', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      previewLesson(my_param, redirect_back_to);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_publish', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      publishLesson(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      removeLesson(my_param, destination, current_url, reload);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_unpublish', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var lesson_parent = $('#found_lesson_' + my_param + ', #compact_lesson_' + my_param + ', #expanded_lesson_' + my_param);
      if(lesson_parent.hasClass('_lesson_change_not_notified')) {
        showLessonNotificationPopUp(destination + '_' + my_param);
      } else {
        unpublishLesson(my_param, destination);
      }
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_add_virtual_classroom', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      addLessonToVirtualClassroom(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_remove_virtual_classroom', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      removeLessonFromVirtualClassroom(my_param, destination);
    }
    return false;
  });
  
  $('body').on('click', '._Lesson_button_edit', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      window.location = '/lessons/' + my_param + '/slides/edit';
    }
    return false;
  });
  
  
  // MEDIA ELEMENT BUTTONS
  
  $('body').on('click', '._Video_button_add, ._Audio_button_add, ._Image_button_add', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      addMediaElement(my_param, destination, current_url, reload);
    }
  });
  
  $('body').on('click', '._Video_button_destroy, ._Audio_button_destroy, ._Image_button_destroy', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var current_url = $('#info_container').data('currenturl');
      var used_in_private_lessons = $(this).data('media-element-used-in-private-lessons');
      destroyMediaElement(my_param, destination, current_url, used_in_private_lessons);
    }
  });
  
  $('body').on('click', '._Video_button_preview, ._Audio_button_preview, ._Image_button_preview', function(e) {
    if(!$(this).parents('._media_element_item').hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      showMediaElementInfoPopUp(my_param);
    }
  });
  
  $('body').on('click', '._Video_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var video_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/videos/' + video_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  
  $('body').on('click', '._Audio_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var audio_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/audios/' + audio_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  
  $('body').on('click', '._Image_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var image_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/images/' + image_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  
  $('body').on('click', '._Video_button_remove, ._Audio_button_remove, ._Image_button_remove', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      removeMediaElement(my_param, destination, current_url, reload);
    }
  });
  
  
  // JAVASCRIPT ANIMATIONS
  
  $('#notifications_list').jScrollPane({
    autoReinitialise: true
  });
  
  $("#select_lesson_list").selectbox();
  
  $("#which_item_to_search").selectbox();
  
  $("#filter_lessons").selectbox();
  
  $("#filter_search_lessons").selectbox();
  
  $("#filter_search_lessons_subject").selectbox();
  
  $("#profile_school_level").selectbox();
  
  $("#profile_region").selectbox();
  
  $("#for_page_media_elements").selectbox();
  
  $("#filter_media_elements").selectbox();
  
  $("#filter_search_media_elements").selectbox();
  
  $("#user_school_level_id").selectbox();
  
  
  
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
  
  $('body').on('click', '#lesson-notification ._no', function(e) {
    e.preventDefault();
    closePopUp('lesson-notification');
    var lesson_id = $('#lesson-notification').data('lesson-id');
    $('#' + lesson_id).removeClass('_lesson_change_not_notified');
    $('#' + lesson_id + ' .unpublish').attr('title', $('#popup_captions_container').data('title-unpublish'));
    var id = lesson_id.split('_');
    id = id[id.length - 1];
    $.ajax({
      type: 'post',
      url: '/lessons/' + id + '/dont_notify_modification',
      beforeSend: unbindLoader()
    }).always(bindLoader);
  });
  
  $('body').on('focus', '#lesson-notification #lesson_notify_modification_details', function() {
    if($('#lesson-notification #lesson_notify_modification_details_placeholder').val() === '') {
      $(this).val('');
      $('#lesson-notification #lesson_notify_modification_details_placeholder').val('0');
    }
  });
  
  
  // SEARCH ITEMS
  
  $('body').on('click', '#which_item_to_search_switch_media_elements', function() {
    $('#search_lessons_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').show();
      $('#search_lessons_main_page').hide();
      if($('#general_pagination').is(':visible')) {
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
      if($('#general_pagination').is(':visible')) {
        $('#general_pagination').hide();
      } else {
        $('#general_pagination').show();
      }
    });
  });
  
  $('body').on('click', '._clickable_tag_for_lessons, ._clickable_tag_for_media_elements', function() {
    if(!$(this).hasClass('current')) {
      var url = $('#info_container').data('currenturl');
      url = updateURLParameter(url, 'tag_id', '' + $(this).data('param'));
      url = updateURLParameter(url, 'page', '1');
      window.location = url;
    }
  });
  
  $('body').on('click', '._clickable_tag_for_lessons.current, ._clickable_tag_for_media_elements.current', function() {
    var url = $('#info_container').data('currenturl');
    url = removeURLParameter(url, 'tag_id');
    url = updateURLParameter(url, 'page', '1');
    window.location = url;
  });
  
  $('body').on('focus', '#lessons_tag_reader_for_search', function() {
    if($('#lessons_tag_kind_for_search').val() == '') {
      $(this).val('');
      $(this).css('color', '#939393');
      $('#lessons_tag_kind_for_search').val('0');
    }
  });
  
  $('body').on('focus', '#media_elements_tag_reader_for_search', function() {
    if($('#media_elements_tag_kind_for_search').val() == '') {
      $(this).val('');
      $(this).css('color', '#939393');
      $('#media_elements_tag_kind_for_search').val('0');
    }
  });
  
  $('body').on('focus', '#general_tag_reader_for_search', function() {
    $(this).attr('value', '');
    $(this).css('color', '#939393');
    $('#general_tag_kind_for_search').attr('value', '0');
    $('#search_general_submit').removeClass('current');
  });
  
  $('body').on('click', '#search_general_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_general').submit();
      $(this).addClass('current');
    }
  });
  
  $('body').on('click', '._keep_searching', function() {
    var form = $(this).parent();
    form.animate({
      height: '210'
    }, 500, function() {
      form.find('._search_engine_form').show();
      form.find('._keep_searching').hide();
    });
  });
  
  
  // VIRTUAL CLASSROOM
  
  $('body').on('click', '._playlist_play', function() {
    window.location = '/lessons/view/playlist';
  });
  
  $('body').on('click', '#open_quick_load_lessons_popup_in_virtual_classroom', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/virtual_classroom/select_lessons'
      });
    }
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
    var captions = $('#popup_captions_container');
    var title = captions.data('empty-virtual-classroom-playlist-title');
    var confirm = captions.data('empty-virtual-classroom-playlist-confirm');
    var yes = captions.data('empty-virtual-classroom-playlist-yes');
    var no = captions.data('empty-virtual-classroom-playlist-no');
    showConfirmPopUp(title, confirm, yes, no, function() {
      closePopUp('dialog-confirm');
      $.ajax({
        type: 'post',
        url: '/virtual_classroom/empty_playlist'
      });
    }, function() {
      closePopUp('dialog-confirm');
    });
  });
  
  $('body').on('click', '#empty_virtual_classroom', function() {
    if(!$(this).hasClass('disabled')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('empty-virtual-classroom-title');
      var confirm = captions.data('empty-virtual-classroom-confirm');
      var yes = captions.data('empty-virtual-classroom-yes');
      var no = captions.data('empty-virtual-classroom-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        closePopUp('dialog-confirm');
        $.ajax({
          type: 'post',
          url: '/virtual_classroom/empty_virtual_classroom'
        });
      }, function() {
        closePopUp('dialog-confirm');
      });
    }
  });
  
  $('body').on('click', '._virtual_classroom_quick_loaded_lesson', function() {
    var cover = $('#' + this.id + ' ._lesson_thumb');
    if(!cover.hasClass('current')) {
      var appended = $('#' + this.id + ' ._current_inserted');
      if(appended.length == 0) {
        $('#virtual_classroom_quick_select_submit').removeClass('current');
        $('#' + this.id + ' input').val('1');
        cover.append('<div class="currentInserted _current_inserted"><a></a></div>');
      } else {
        $('#' + this.id + ' input').val('0');
        appended.remove();
        if($('#dialog-virtual-classroom-quick-select ._current_inserted').length == 0) {
          $('#virtual_classroom_quick_select_submit').addClass('current');
        }
      }
    }
  });
  
  $('body').on('mouseover', '._virtual_classroom_quick_loaded_lesson ._current_inserted', function() {
    $(this).children('a').css('background-position', '-10em -0.1em');
  });
  
  $('body').on('mouseout', '._virtual_classroom_quick_loaded_lesson ._current_inserted', function() {
    $(this).children('a').css('background-position', '-10em -15.2em');
  });
  
  $('body').on('click', '#virtual_classroom_quick_select_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#virtual_classroom_quick_select_container form').submit();
    }
  });
  
  $('body').on('click', '#virtual_classroom_quick_select_close', function() {
    $('.dialog_opaco').removeClass('dialog_opaco');
    closePopUp('dialog-virtual-classroom-quick-select');
  });
  
  $('body').on('click', '._virtual_classroom_preview', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('lesson-id');
      var redirect_back_to = $("#info_container").data('currenturl');
      previewLesson(my_param, redirect_back_to);
    }
    return false;
  });
  
  $('body').on('click', '._send_lesson_link', function() {
    var lesson_id = $(this).data('lesson-id');
    showSendLessonLinkPopUp(lesson_id);
    $('#virtual_classroom_send_link_mails_box').jScrollPane({
      autoReinitialise: true
    });
  });
  
  $('body').on('focus', '#virtual_classroom_emails_selector', function() {
    if($(this).data('placeholdered')) {
      $(this).attr('value', '');
      $(this).data('placeholdered', false);
    }
  });
  
  $('body').on('focus', '#virtual_classroom_send_link_message', function() {
    var placeholder = $('#virtual_classroom_send_link_message_placeholder');
    if(placeholder.val() === '') {
      $(this).attr('value', '');
      placeholder.val('0');
    }
  });
  
  $('body').on('click', '#virtual_classroom_emails_submitter', function() {
    addEmailToVirtualClassroomSendLessonLinkSelector();
  });
  
  $('body').on('keydown', '#virtual_classroom_emails_selector', function(e) {
    if(e.which === 186) {
      e.preventDefault();
      var value = $(this).val();
      value += '@';
      $(this).val(value);
    }
    if(e.which === 13) {
      e.preventDefault();
      addEmailToVirtualClassroomSendLessonLinkSelector();
    }
  });
  
  $('body').on('click', '#virtual_classroom_send_link_mails_box ._remove', function() {
    $(this).parent().remove();
  });
  
  $('#select_mailing_list').selectbox({
    onChange: function(val, inst) {
      if(val != '') {
        var emails = $('#virtual_classroom_hidden_mailing_lists ._mailing_list_' + val + ' div');
        for(var i = 0; i < emails.length; i++) {
          $('#virtual_classroom_send_link_mails_box .jspPane').append(emails[i].outerHTML);
        }
      }
    }
  });
  
  $('body').on('click', '#dialog-virtual-classroom-send-link ._no', function() {
    var obj = $('#dialog-virtual-classroom-send-link');
    closePopUp('dialog-virtual-classroom-send-link');
  });
  
  $('body').on('click', '#dialog-virtual-classroom-send-link ._yes', function() {
    var obj = $('#dialog-virtual-classroom-send-link');
    obj.dialog('option', 'hide', null);
    var emails_input = '';
    $('#virtual_classroom_send_link_mails_box .jspPane ._email ._text').each(function() {
      emails_input += ($(this).html() + ',');
    });
    emails_input = emails_input.substr(0, emails_input.length - 1);
    $('#virtual_classroom_send_link_hidden_emails').val(emails_input);
    closePopUp('dialog-virtual-classroom-send-link');
    obj.dialog('option', 'hide', {effect: "fade"});
    $('#dialog-virtual-classroom-send-link form').submit();
  });
  
  
  // IMAGE EDITOR
  
  $('.image_editor_only #form_info_new_media_element_in_editor, .image_editor_only #form_info_update_media_element_in_editor').css("left",($(window).width()/2)-495);
  $('#image_gallery_for_image_editor ._select_image_from_gallery').addClass('_add_image_to_image_editor');
  $('#image_gallery_for_image_editor .gallery-header').css("left",($(window).width()/2)-420);
  $('body').on('click', '._add_image_to_image_editor', function() {
    var parser = document.createElement('a');
    parser.href = $('._exit_url').attr('href');
    window.location = '/images/' + $(this).data('image-id') + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
  });
  
  
  // LOAD NEW ELEMENT
  
  $('body').on('click', '._load_media_element', function(e) {
    e.preventDefault();
    showLoadMediaElementPopUp();
    initFileUploads();
  });
  
  $('body').on('change', 'input#new_media_element_input', function() {
    var file_name = $(this).val().replace("C:\\fakepath\\", "");
    if(file_name.length > 20){
      file_name = file_name.substring(0,20)+"...";
    }
    $('#media_element_media_show').text(file_name);
  });
  
  $('body').on('click', '#load-media-element ._close', function() {
    closePopUp('load-media-element');
  })

  $('body').on('click', '#new_media_element_submit', function() {
    $('input,textarea').removeClass('form_error');
    $('.barraLoading img').show();
    $('.barraLoading img').attr('src', '/assets/loadingBar.gif');
    $(this).closest('#new_media_element').submit();
  });
  
  $('body').on('focus', '#load-media-element #title', function() {
    if($('#load-media-element #title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #title_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#load-media-element #description', function() {
    if($('#load-media-element #description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #description_placeholder').attr('value', '0');
    }
  });
  
  
  // CREATE AND UPDATE LESSON INFO
  
  $('body').on('focus', '#slides._new #title', function() {
    if($('#slides._new #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #title_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#slides._new #description', function() {
    if($('#slides._new #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._new #description_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#slides._update #title', function() {
    if($('#slides._update #title_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #title_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#slides._update #description', function() {
    if($('#slides._update #description_placeholder').val() == '') {
      $(this).val('');
      $('#slides._update #description_placeholder').attr('value', '0');
    }
  });
  
  
  // PRELOGIN
  
  $('body').on('click', '._show_login_form_container', function() {
    var form = $('#login_form_container');
    if(!form.is(':visible')) {
      form.show('fade', {}, 500);
      $('#email').focus();
    } else {
      form.hide('fade', {}, 500);
    }
  });
  
  $('body').on('click', '#submit_login_form', function() {
    $('#new_users_session_form').submit();
  });
  
  
  // PROFILE
  
  $('body').on('keypress','#mailing_lists_accordion .group-title', function(event){
    if (event.keyCode == 10 || event.keyCode == 13){
      event.preventDefault();
    }
  });
  
  $('body').on('keypress','#mailing_lists_accordion .group-title', function(event){
     if(event.which === 32){
       event.stopPropagation();
     }
  });
  
  $('body').on('blur', '#mailing_lists_accordion .group-title', function() {
    var group = $(this);
    $.ajax({
      type: 'put',
      url: '/mailing_lists/' + group.data('param') + '/update/' + group.text()
    });
  });
  
  $('body').on('click', '#fake_save_mailing_list', function() {
    $('.group-title').effect('highlight', {color: '#41A62A'}, 1500);
  });
  
  $('body').on('focus', '._input_in_mailing_list', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
  
  
  // MEDIA ELEMENT EDITOR GENERAL FUNCTIONS
  
  $('body').on('focus', '#form_info_new_media_element_in_editor #new_title', function() {
    if($('#form_info_new_media_element_in_editor #new_title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#form_info_new_media_element_in_editor #new_title_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#form_info_new_media_element_in_editor #new_description', function() {
    if($('#form_info_new_media_element_in_editor #new_description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#form_info_new_media_element_in_editor #new_description_placeholder').attr('value', '0');
    }
  });
  
  
  // VIDEO EDITOR
  
  $('body').on('click', '#video_editor_preview_go_to_left_component', function() {
    if($('#video_editor_global_preview').data('arrows')) {
      var prev_component = $('#video_component_' + $('#video_editor_global_preview').data('current-component')).prev();
      loadVideoComponentIfNotLoadedYet(prev_component.attr('id'));
      selectVideoComponentInPreview(prev_component);
      showVideoEditorPreviewArrowToComponents();
      hideVideoEditorPreviewComponentProgressBar();
      followPreviewComponentsWithHorizontalScrollInVideoEditor();
    }
  });
  
  $('body').on('click', '#video_editor_preview_go_to_right_component', function() {
    if($('#video_editor_global_preview').data('arrows')) {
      var next_component = $('#video_component_' + $('#video_editor_global_preview').data('current-component')).next();
      loadVideoComponentIfNotLoadedYet(next_component.attr('id'));
      selectVideoComponentInPreview(next_component);
      showVideoEditorPreviewArrowToComponents();
      hideVideoEditorPreviewComponentProgressBar();
      followPreviewComponentsWithHorizontalScrollInVideoEditor();
    }
  });
  
  $('body').on('click', '#video_editor_global_preview_play', function() {
    if(!$(this).data('temporarily-disabled')) {
      $(this).hide();
      $('#video_editor_preview_slider_box_ghost').show();
      $('#video_editor_preview_go_to_left_component, #video_editor_preview_go_to_right_component').hide();
      $('#video_editor_global_preview_pause').show();
      $('#visual_video_editor_current_time').css('color', 'white');
      $('#visual_video_editor_total_length').css('color', '#787575');
      $('#exit_video_editor_preview').hide();
      startVideoEditorGlobalPreview();
    }
  });
  
  $('body').on('click', '#exit_video_editor_preview', function() {
    hideVideoEditorPreviewComponentProgressBar();
    $('#info_container').data('forced-kevin-luck-style', '');
    $('#video_editor_global_preview_pause').removeClass('_enabled');
    $('#video_editor_preview_go_to_left_component, #video_editor_preview_go_to_right_component').hide();
    $('._video_component_preview').hide();
    $('._video_editor_component_hover, ._video_component_icon').removeClass('selected');
    setVisualTimesVideoEditorPreview(getFirstVideoEditorComponent(), 0);
    resetVisibilityOfVideoEditorTransitions();
    $('._video_editor_component').each(function() {
      $(this).find('._video_component_icon ._right').html(secondsToDateString($(this).data('duration')));
    });
    $('#full_audio_track_placeholder_in_video_editor, #empty_audio_track_placeholder_in_video_editor').css('visibility', 'visible');
    $('#media_elements_list_in_video_editor').data('jsp').destroy();
    $('#add_new_video_component').show();
    $('#add_new_video_component').prev().find('._video_component_transition').show();
    $('#add_new_video_component').prev().css('width', '186');
    var new_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', '')) + 184;
    $('#video_editor_timeline').css('width', new_timeline_width + 'px');
    $('#media_elements_list_in_video_editor').jScrollPane({
      autoReinitialise: true,
    });
    $('#visual_video_editor_current_time').css('visibility', 'hidden')
    $('#video_editor_global_preview').show();
    $('#video_editor_global_preview_play').hide();
    $('#commit_video_editor').show();
    $('#exit_video_editor_preview').hide();
    $('#video_editor_box_ghost').hide();
  });
  
  $('body').on('click', '#video_editor_global_preview_pause._enabled', function() {
    $('#video_editor_global_preview_play').data('temporarily-disabled', true);
    setTimeout(function() {
      $('#video_editor_global_preview_play').data('temporarily-disabled', false);
    }, 1000);
    $('#video_editor_preview_slider_box_ghost').hide();
    $('#video_editor_global_preview').data('in-use', false);
    showVideoEditorPreviewArrowToComponents();
    $(this).hide();
    $('#video_editor_global_preview_play').show();
    $('#exit_video_editor_preview').show();
    $('#visual_video_editor_current_time').css('color', '#787575');
    $('#visual_video_editor_total_length').css('color', 'white');
    var current_identifier = $('#video_editor_global_preview').data('current-component');
    var current_component = $('#video_component_' + current_identifier);
    if($('#video_component_' + current_identifier + '_preview video').length > 0) {
      $('#video_component_' + current_identifier + '_preview video')[0].pause();
      setCurrentTimeToMedia($('#video_component_' + current_identifier + '_preview video'), ($('#video_component_' + current_identifier + '_cutter').data('from') + current_component.data('current-preview-time')));
    }
    if(videoEditorWithAudioTrack()) {
      $('#video_editor_preview_container audio')[0].pause();
    }
  });
  
  $('body').on('click', '#video_editor_global_preview._enabled', function() {
    loadVideoComponentIfNotLoadedYet(getFirstVideoEditorComponent().attr('id'));
    $('#info_container').data('forced-kevin-luck-style', 'visibility:hidden');
    var jsp_handler = $('#media_elements_list_in_video_editor').data('jsp');
    if(jsp_handler.getContentPositionX() > 0) {
      $('#media_elements_list_in_video_editor').jScrollPane().bind('panescrollstop', function() {
        openPreviewModeInVideoEditor();
        $('#media_elements_list_in_video_editor').jScrollPane().unbind('panescrollstop');
      });
      $('#media_elements_list_in_video_editor').data('jsp').scrollToPercentX(0, true);
    } else {
      openPreviewModeInVideoEditor();
    }
  });
  
  $('body').on('click', '._video_component_cutter_button', function() {
    var component_id = $(this).parents('._video_editor_component').attr('id');
    if(!$('#' + component_id + '_preview').is(':visible')) {
      startVideoEditorPreviewClip(component_id);
    }
    $('#video_editor_box_ghost').show();
    $('#video_editor_global_preview').removeClass('_enabled');
    var pos = $('#' + component_id).data('position');
    var scroll_to = getNormalizedPositionTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186, pos, 5);
    if($('#' + component_id + '_cutter').hasClass('_mini_cutter')) {
      $('#' + component_id + '_cutter').css('left', (3 + getAbsolutePositionTimelineHorizontalScrollPane('media_elements_list_in_video_editor', 186, pos, 5)));
    }
    var jsp_handler = $('#media_elements_list_in_video_editor').data('jsp');
    if(scroll_to != jsp_handler.getContentPositionX() && jsp_handler.getPercentScrolledX() != 1) {
      $('#media_elements_list_in_video_editor').jScrollPane().bind('panescrollstop', function() {
        showVideoEditorCutter(component_id);
        $('#media_elements_list_in_video_editor').jScrollPane().unbind('panescrollstop');
      });
      jsp_handler.scrollToX(scroll_to, true);
    } else {
      showVideoEditorCutter(component_id);
    }
  });
  
  $('body').on('click', '._media_player_done_video_component_in_video_editor_preview', function() {
    closeGenericVideoComponentCutter();
    var component_id = $(this).parents('._video_component_cutter').attr('id');
    var identifier = getVideoComponentIdentifier(component_id);
    $('#video_component_' + identifier + '_cutter ._double_slider .ui-slider-handle').removeClass('selected');
    stopVideoInVideoEditorPreview(identifier);
    commitVideoComponentVideoCutter(identifier);
    $('#video_editor_global_preview').addClass('_enabled');
  });
  
  $('body').on('click', '._media_player_done_other_component_in_video_editor_preview', function() {
    var component_id = $(this).parents('._video_component_cutter').attr('id');
    var identifier = getVideoComponentIdentifier(component_id);
    var duration = $('#' + component_id + ' ._duration_selector input').val();
    if(duration == '') {
      closeGenericVideoComponentCutter();
    } else {
      duration = parseInt(duration);
      if(isNaN(duration) || duration < 1) {
        showErrorPopUp($('#popup_captions_container').data('invalid-component-duration-in-video-editor'));
      } else {
        closeGenericVideoComponentCutter();
        changeDurationVideoEditorComponent(('video_component_' + identifier), duration);
        $('#' + component_id + ' ._duration_selector input').val('');
        $('#' + component_id + ' ._old').html(secondsToDateString(duration));
        $('#video_component_' + identifier + ' ._video_component_input_duration').val(duration);
        highlightAndUpdateVideoComponentIcon('video_component_' + identifier);
      }
    }
    $('#video_editor_global_preview').addClass('_enabled');
  });
  
  $('body').on('click', '._exit_video_editor', function() {
    stopCacheLoop();
    var captions = $('#popup_captions_container');
    showConfirmPopUp(captions.data('exit-video-editor-title'), captions.data('exit-video-editor-confirm'), captions.data('exit-video-editor-yes'), captions.data('exit-video-editor-no'), function() {
      $('dialog-confirm').hide();
      $.ajax({
        type: 'post',
        url: '/videos/cache/empty',
        beforeSend: unbindLoader(),
        success: function() {
          window.location = '/media_elements';
        }
      }).always(bindLoader);
    }, function() {
      if($('#form_info_update_media_element_in_editor').length == 0) {
        if(!$('#form_info_new_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      } else {
        if(!$('#form_info_new_media_element_in_editor').is(':visible') && !$('#form_info_update_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      }
      closePopUp('dialog-confirm');
    });
  });
  
  $('body').on('click', '._remove_component_from_video_editor_button', function() {
    var component = $(this).parents('._video_editor_component');
    var identifier = getVideoComponentIdentifier(component.attr('id'));
    $('#video_component_' + identifier).hide('fade', {}, 500, function() {
      $('#video_component_' + identifier + '_preview').remove();
      $('#video_component_' + identifier + '_cutter').remove();
      changeDurationVideoEditorComponent(('video_component_' + identifier), 0);
      $('#media_elements_list_in_video_editor').data('jsp').destroy();
      $(this).remove();
      reloadVideoEditorComponentPositions();
      var old_timeline_width = parseInt($('#video_editor_timeline').css('width').replace('px', ''));
      $('#video_editor_timeline').css('width', ((old_timeline_width - 186) + 'px'));
      $('#media_elements_list_in_video_editor').jScrollPane({
        autoReinitialise: true
      });
      resetVisibilityOfVideoEditorTransitions();
      if($('._video_editor_component').length == 0) {
        $('#video_editor_global_preview').removeClass('_enabled');
        $('#video_editor_global_preview a').addClass('disabled');
        $('#commit_video_editor').css('visibility', 'hidden');
      }
    });
  });
  
  $('body').on('mouseover', '._video_editor_component_hover', function() {
    var father = $(this).parent();
    if(father.data('rolloverable')) {
      father.data('preview-selected', true);
      startVideoEditorPreviewClipWithDelay(father.attr('id'));
      $('#' + father.attr('id') + ' ._video_editor_component_menu').show();
    }
  });
  
  $('body').on('mouseout', '._video_editor_component_hover', function() {
    var father = $(this).parent();
    father.data('preview-selected', false);
    if(father.data('rolloverable')) {
      $('#' + father.attr('id') + ' ._video_editor_component_menu').hide();
    }
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
      infos.data('current-component', father.attr('id'));
    } else {
      infos.data('replacing-component', false);
    }
    if($('#video_editor_mixed_gallery_container').data('loaded')) {
      showGalleryInVideoEditor('mixed');
      resetVideoEditorTextComponent();
    } else {
      $.ajax({
        type: 'get',
        url: '/videos/galleries'
      });
    }
  });
  
  $('body').on('click', '._show_audio_gallery_in_video_editor', function() {
    if($('#video_editor_audio_gallery_container').data('loaded')) {
      showGalleryInVideoEditor('audio');
    } else {
      $.ajax({
        type: 'get',
        url: '/videos/galleries/audio'
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
    var webm = $('#' + popup_id + ' source[type="video/webm"]').attr('src');
    var mp4 = $('#' + popup_id + ' source[type="video/mp4"]').attr('src');
    var duration = $(this).data('duration');
    closePopUp(popup_id);
    setTimeout(function() {
      closeGalleryInVideoEditor('mixed');
    }, 700);
    if($('#info_container').data('replacing-component')) {
      var current_component = $('#info_container').data('current-component');
      setTimeout(function() {
        highlightAndUpdateVideoComponentIcon(current_component);
      }, 1400);
      replaceVideoComponentInVideoEditor(video_id, webm, mp4, component, current_component, duration);
    } else {
      addVideoComponentInVideoEditor(video_id, webm, mp4, component, duration);
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
      var component = $('#' + popup_id + ' ._temporary ._video_component_thumb')[0].outerHTML;
      var preview = $('#' + popup_id + ' ._temporary ._image_preview_in_video_editor_gallery').html();
      closePopUp(popup_id);
      setTimeout(function() {
        closeGalleryInVideoEditor('mixed');
      }, 700);
      if($('#info_container').data('replacing-component')) {
        var current_component = $('#info_container').data('current-component');
        setTimeout(function() {
          highlightAndUpdateVideoComponentIcon(current_component);
        }, 1400);
        replaceImageComponentInVideoEditor(image_id, component, preview, current_component, duration);
      } else {
        addImageComponentInVideoEditor(image_id, component, preview, duration);
      }
    }
  });
  
  $('body').on('click', '._add_audio_track_to_video_editor', function() {
    $('#video_editor_preview_container ._audio_track_preview').remove();
    if(!$('#video_editor_preview_container video').prop('muted')) {
      $('#video_editor_preview_container video').prop('muted', true);
    }
    var audio_id = $(this).data('audio-id');
    closeGalleryInVideoEditor('audio');
    stopMedia('._audio_expanded_in_gallery audio');
    $('._audio_expanded_in_gallery ._expanded').hide();
    $('._audio_expanded_in_gallery').removeClass('_audio_expanded_in_gallery');
    $('#audio_track_in_video_editor_input').val(audio_id);
    $('#empty_audio_track_placeholder_in_video_editor').hide();
    $('#full_audio_track_placeholder_in_video_editor').show();
    $('#full_audio_track_placeholder_in_video_editor').data('duration', $(this).data('duration'));
    var new_html_title = $('#gallery_audio_' + audio_id + ' ._compact p').html();
    new_html_title += ('<br/>' + secondsToDateString($(this).data('duration')));
    $('#full_audio_track_placeholder_in_video_editor ._title').html(new_html_title);
    $('#video_editor_preview_container').append($('#empty_audio_track_preview_for_video_editor').html());
    var new_audio_track = $('#video_editor_preview_container ._audio_track_preview');
    new_audio_track.data('duration', $(this).data('duration'));
    new_audio_track.find('source[type="audio/mp3"]').attr('src', $(this).data('mp3'));
    new_audio_track.find('source[type="audio/ogg"]').attr('src', $(this).data('ogg'));
    new_audio_track.find('audio').load();
  });
  
  $('body').on('click', '#full_audio_track_placeholder_in_video_editor ._remove', function() {
    $('#video_editor_preview_container video').prop('muted', false);
    var audio_id = $('#audio_track_in_video_editor_input').val();
    $('#video_editor_preview_container ._audio_track_preview').remove();
    $('#audio_track_in_video_editor_input').val('');
    $('#full_audio_track_placeholder_in_video_editor').hide();
    $('#empty_audio_track_placeholder_in_video_editor').show();
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
      var content = $('#text_component_preview textarea').val().split("\n").join('<br/>');
      var component = $('#video_editor_mixed_gallery_container ._texts ._temporary').html();
      closeGalleryInVideoEditor('mixed');
      if($('#info_container').data('replacing-component')) {
        var current_component = $('#info_container').data('current-component');
        setTimeout(function() {
          highlightAndUpdateVideoComponentIcon(current_component);
        }, 700);
        replaceTextComponentInVideoEditor(component, content, current_component, duration, background_color, text_color);
      } else {
        addTextComponentInVideoEditor(component, content, duration, background_color, text_color);
      }
    }
  });
  
  $('body').on('click', '#commit_video_editor', function() {
    stopCacheLoop();
    submitMediaElementEditorCacheForm($('#video_editor_form'));
    if($(this).hasClass('_with_choice')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('save-media-element-editor-title');
      var confirm = captions.data('save-media-element-editor-confirm');
      var yes = captions.data('save-media-element-editor-yes');
      var no = captions.data('save-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        closePopUp('dialog-confirm');
        $('._video_editor_bottom_bar').hide();
        $('#video_editor #form_info_update_media_element_in_editor').show();
      }, function() {
        closePopUp('dialog-confirm');
        $('#video_editor_title ._titled').hide();
        $('#video_editor_title ._untitled').show();
        $('._video_editor_bottom_bar').hide();
        $('#video_editor #form_info_new_media_element_in_editor').show();
      });
    } else {
      $('._video_editor_bottom_bar').hide();
      $('#video_editor #form_info_new_media_element_in_editor').show();
    }
  });
  
  $('body').on('click', '#video_editor #form_info_new_media_element_in_editor ._commit', function() {
    $('#video_editor_form').attr('action', '/videos/commit/new');
    $('#video_editor_form').submit();
  });
  
  $('body').on('click', '#video_editor #form_info_update_media_element_in_editor ._commit', function() {
    if($('#info_container').data('used-in-private-lessons')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('overwrite-media-element-editor-title');
      var confirm = captions.data('overwrite-media-element-editor-confirm');
      var yes = captions.data('overwrite-media-element-editor-yes');
      var no = captions.data('overwrite-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        $('dialog-confirm').hide();
        $('#video_editor_form').attr('action', '/videos/commit/overwrite');
        $('#video_editor_form').submit();
      }, function() {
        closePopUp('dialog-confirm');
      });
    } else {
      $('#video_editor_form').attr('action', '/videos/commit/overwrite');
      $('#video_editor_form').submit();
    }
  });
  
  $('body').on('click', '#video_editor #form_info_new_media_element_in_editor ._cancel', function() {
    $('#video_editor_form').attr('action', '/videos/cache/save');
    resetMediaElementEditorForms();
    if($('#video_editor_title ._titled').length > 0) {
      $('#video_editor_title ._titled').show();
      $('#video_editor_title ._untitled').hide();
    }
    $('._video_editor_bottom_bar').show();
    $('#video_editor #form_info_new_media_element_in_editor').hide();
    startCacheLoop();
  });
  
  $('body').on('click', '#video_editor #form_info_update_media_element_in_editor ._cancel', function() {
    $('#video_editor_form').attr('action', '/videos/cache/save');
    resetMediaElementEditorForms();
    $('._video_editor_bottom_bar').show();
    $('#video_editor #form_info_update_media_element_in_editor').hide();
    startCacheLoop();
  });
  
  $('body').on('click', '._video_component_cutter ._precision_arrow_left', function() {
    var cutter = $(this).parents('._video_component_cutter');
    var identifier = getVideoComponentIdentifier(cutter.attr('id'));
    var single_slider = cutter.find('._media_player_slider');
    var double_slider = cutter.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp > 0 && resp > double_slider.slider('values', 0)) {
        selectVideoComponentCutterHandle(cutter, resp - 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp > 0) {
        double_slider.slider('values', 0, resp - 1);
        cutVideoComponentLeftSide(identifier, resp - 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp > double_slider.slider('values', 0) + 1) {
        if(single_slider.slider('value') == resp) {
          selectVideoComponentCutterHandle(cutter, resp - 1);
        }
        double_slider.slider('values', 1, resp - 1);
        cutVideoComponentRightSide(identifier, resp - 1);
      }
    }
  });
  
  $('body').on('click', '._video_component_cutter ._precision_arrow_right', function() {
    var cutter = $(this).parents('._video_component_cutter');
    var identifier = getVideoComponentIdentifier(cutter.attr('id'));
    var duration = cutter.data('max-to');
    var single_slider = cutter.find('._media_player_slider');
    var double_slider = cutter.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp < duration && resp < double_slider.slider('values', 1)) {
        selectVideoComponentCutterHandle(cutter, resp + 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp < double_slider.slider('values', 1) - 1) {
        if(single_slider.slider('value') == resp) {
          selectVideoComponentCutterHandle(cutter, resp + 1);
        }
        double_slider.slider('values', 0, resp + 1);
        cutVideoComponentLeftSide(identifier, resp + 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp < duration) {
        double_slider.slider('values', 1, resp + 1);
        cutVideoComponentRightSide(identifier, resp + 1);
      }
    }
  });
  
  initializeVideoEditor();
  
  
  // AUDIO EDITOR
  
  $('body').on('mouseover', '._audio_editor_component ._box_ghost', function() {
    $(this).parent().find('._sort_handle').addClass('current');
  });
  
  $('body').on('mouseout', '._audio_editor_component ._box_ghost', function(e) {
    if($(this).is(':visible') && !$(e.relatedTarget).hasClass('_remove')) {
      $(this).parent().find('._sort_handle').removeClass('current');
    }
  });
  
  $('body').on('click', '._audio_editor_component ._sort_handle', function() {
    selectAudioEditorComponent($(this).parent().parent());
  });
  
  $('body').on('click', '._audio_editor_component ._box_ghost', function() {
    selectAudioEditorComponent($(this).parent());
  });
  
  $('body').on('click', '._audio_editor_component ._remove', function() {
    removeAudioEditorComponent($(this).parent());
  });
  
  $('body').on('click', '#add_new_audio_component_in_audio_editor', function() {
    if(!$('#add_new_audio_component_in_audio_editor').hasClass('disabled')) {
      var selected_component = $('._audio_editor_component._selected');
      if(selected_component.length > 0) {
        selected_component.find('._media_player_pause_in_audio_editor_preview').click();
      }
      if($('#audio_editor_gallery_container').data('loaded')) {
        showGalleryInAudioEditor();
      } else {
        $.ajax({
          type: 'get',
          url: '/audios/galleries/audio'
        });
      }
    }
  });
  
  $('body').on('click', '._add_audio_component_to_audio_editor', function() {
    stopMedia('._audio_expanded_in_gallery audio');
    $('._audio_expanded_in_gallery ._expanded').hide();
    $('._audio_expanded_in_gallery').removeClass('_audio_expanded_in_gallery');
    var audio_id = $(this).data('audio-id');
    closeGalleryInAudioEditor();
    stopMedia('#gallery_audio_' + audio_id + ' audio');
    $('#gallery_audio_' + audio_id + ' ._expanded').hide();
    addComponentInAudioEditor(audio_id, $(this).data('ogg'), $(this).data('mp3'), $(this).data('duration'), $(this).data('title'));
  });
  
  $('body').on('click', '._exit_audio_editor', function() {
    stopCacheLoop();
    var captions = $('#popup_captions_container');
    showConfirmPopUp(captions.data('exit-audio-editor-title'), captions.data('exit-audio-editor-confirm'), captions.data('exit-audio-editor-yes'), captions.data('exit-audio-editor-no'), function() {
      $('dialog-confirm').hide();
      $.ajax({
        type: 'post',
        url: '/audios/cache/empty',
        beforeSend: unbindLoader(),
        success: function() {
          window.location = '/media_elements';
        }
      }).always(bindLoader);
    }, function() {
      if($('#form_info_update_media_element_in_editor').length == 0) {
        if(!$('#form_info_new_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      } else {
        if(!$('#form_info_new_media_element_in_editor').is(':visible') && !$('#form_info_update_media_element_in_editor').is(':visible')) {
          startCacheLoop();
        }
      }
      closePopUp('dialog-confirm');
    });
  });
  
  $('body').on('click', '#start_audio_editor_preview', function() {
    if(!$(this).hasClass('disabled')) {
      enterAudioEditorPreviewMode();
    }
  });
  
  $('body').on('click', '#rewind_audio_editor_preview', function() {
    if(!$(this).hasClass('disabled')) {
      var selected_component = $('._audio_editor_component').first();
      selectAudioEditorComponent(selected_component);
      disableCommitAndPreviewInAudioEditor();
      scrollToFirstSelectedAudioEditorComponent(function() {
        enableCommitAndPreviewInAudioEditor();
        var from = selected_component.data('from');
        selected_component.find('._media_player_slider').slider('value', from);
        selected_component.find('._current_time').html(secondsToDateString(from));
        setCurrentTimeToMedia(selected_component.find('audio'), selected_component.find('._media_player_slider').slider('value'));
      });
    }
  });
  
  $('body').on('click', '#stop_audio_editor_preview', function() {
    leaveAudioEditorPreviewMode();
  });
  
  $('body').on('click', '#commit_audio_editor', function() {
    stopCacheLoop();
    submitMediaElementEditorCacheForm($('#audio_editor_form'));
    if($(this).hasClass('_with_choice')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('save-media-element-editor-title');
      var confirm = captions.data('save-media-element-editor-confirm');
      var yes = captions.data('save-media-element-editor-yes');
      var no = captions.data('save-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        closePopUp('dialog-confirm');
        showCommitAudioEditorForm('update');
      }, function() {
        closePopUp('dialog-confirm');
        $('#audio_editor_title ._titled').hide();
        $('#audio_editor_title ._untitled').show();
        showCommitAudioEditorForm('new');
      });
    } else {
      showCommitAudioEditorForm('new');
    }
  });
  
  $('body').on('click', '#audio_editor #form_info_new_media_element_in_editor ._cancel', function() {
    $('#audio_editor_form').attr('action', '/audios/cache/save');
    resetMediaElementEditorForms();
    if($('#audio_editor_title ._titled').length > 0) {
      $('#audio_editor_title ._titled').show();
      $('#audio_editor_title ._untitled').hide();
    }
    hideCommitAudioEditorForm('new');
    startCacheLoop();
  });
  
  $('body').on('click', '#audio_editor #form_info_update_media_element_in_editor ._cancel', function() {
    $('#audio_editor_form').attr('action', '/audios/cache/save');
    resetMediaElementEditorForms();
    hideCommitAudioEditorForm('update');
    startCacheLoop();
  });
  
  $('body').on('click', '#audio_editor #form_info_new_media_element_in_editor ._commit', function() {
    $('#audio_editor_form').attr('action', '/audios/commit/new');
    $('#audio_editor_form').submit();
  });
  
  $('body').on('click', '#audio_editor #form_info_update_media_element_in_editor ._commit', function() {
    if($('#info_container').data('used-in-private-lessons')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('overwrite-media-element-editor-title');
      var confirm = captions.data('overwrite-media-element-editor-confirm');
      var yes = captions.data('overwrite-media-element-editor-yes');
      var no = captions.data('overwrite-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        $('dialog-confirm').hide();
        $('#audio_editor_form').attr('action', '/audios/commit/overwrite');
        $('#audio_editor_form').submit();
      }, function() {
        closePopUp('dialog-confirm');
      });
    } else {
      $('#audio_editor_form').attr('action', '/audios/commit/overwrite');
      $('#audio_editor_form').submit();
    }
  });
  
  $('body').on('click', '._audio_editor_component ._precision_arrow_left', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var single_slider = component.find('._media_player_slider');
    var double_slider = component.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp > 0 && resp > double_slider.slider('values', 0)) {
        selectAudioComponentCutterHandle(component, resp - 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp > 0) {
        double_slider.slider('values', 0, resp - 1);
        cutAudioComponentLeftSide(identifier, resp - 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp > double_slider.slider('values', 0) + 1) {
        if(single_slider.slider('value') == resp) {
          selectAudioComponentCutterHandle(component, resp - 1);
        }
        double_slider.slider('values', 1, resp - 1);
        cutAudioComponentRightSide(identifier, resp - 1);
      }
    }
  });
  
  $('body').on('click', '._audio_editor_component ._precision_arrow_right', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var duration = component.data('max-to');
    var single_slider = component.find('._media_player_slider');
    var double_slider = component.find('._double_slider');
    if(single_slider.find('.ui-slider-handle').hasClass('selected')) {
      var resp = single_slider.slider('value');
      if(resp < duration && resp < double_slider.slider('values', 1)) {
        selectAudioComponentCutterHandle(component, resp + 1);
      }
    } else if(double_slider.find('.ui-slider-handle').first().hasClass('selected')) {
      var resp = double_slider.slider('values', 0);
      if(resp < double_slider.slider('values', 1) - 1) {
        if(single_slider.slider('value') == resp) {
          selectAudioComponentCutterHandle(component, resp + 1);
        }
        double_slider.slider('values', 0, resp + 1);
        cutAudioComponentLeftSide(identifier, resp + 1);
      }
    } else {
      var resp = double_slider.slider('values', 1);
      if(resp < duration) {
        double_slider.slider('values', 1, resp + 1);
        cutAudioComponentRightSide(identifier, resp + 1);
      }
    }
  });
  
  initializeAudioEditor();
  
  
  // PLAYERS
  
  $('body').on('click', '._media_player_play', function() {
    var container_id = $(this).parent().attr('id');
    var type = $(this).parent().data('media-type');
    var media = $('#' + container_id + ' ' + type);
    if(media[0].error) {
      //traduzzione
      showErrorPopUp('Media Error code: '+ media[0].error.code);
    } else {
      $('#' + container_id + ' ._media_player_slider_disabler').show();
      $('#' + container_id + ' ._media_player_pause').show();
      $(this).hide();
      if(media[0].readyState != 0) {
        media[0].play();
      } else {
        media.on('loadedmetadata', function() {
          media[0].play();
        });
      }
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
  
  $('body').on('click', '._media_player_play_in_video_editor_preview', function() {
    var identifier = getVideoComponentIdentifier($(this).parents('._video_component_cutter').attr('id'));
    var video = $('#video_component_' + identifier + '_preview video');
    if(video[0].error){
      //traduzzione
      showErrorPopUp('Media Error code: '+ media[0].error.code);
    } else {
      $(this).hide();
      $(this).parents('._video_component_cutter').data('playing', true);
      $('#video_component_' + identifier + '_cutter ._media_player_rewind_in_video_editor_preview').hide();
      $('#video_component_' + identifier + '_cutter ._media_player_slider_disabler').show();
      $('#video_component_' + identifier + '_cutter ._media_player_pause_in_video_editor_preview').show();
      $('#video_component_' + identifier + '_cutter .ui-slider-handle').removeClass('selected');
      if(video.readyState != 0) {
        video[0].play();
      } else {
        video.on('loadedmetadata', function() {
          video[0].play();
        });
      }
    }
    var actual_audio_track_time = calculateVideoComponentStartSecondInVideoEditor(identifier);
    if(videoEditorWithAudioTrack() && actual_audio_track_time < $('#full_audio_track_placeholder_in_video_editor').data('duration')) {
      var audio_track = $('#video_editor_preview_container audio');
      if(audio_track[0].error) {
        //traduzzione
        showErrorPopUp('Media Error code: '+ media[0].error.code);
      } else {
        setCurrentTimeToMedia(audio_track, actual_audio_track_time);
        if(audio_track.readyState != 0) {
          audio_track[0].play();
        } else {
          audio_track.on('loadedmetadata', function() {
            audio_track[0].play();
          });
        }
      }
    }
  });
  
  $('body').on('click', '._media_player_pause_in_video_editor_preview', function() {
    $(this).hide();
    $(this).parents('._video_component_cutter').data('playing', false);
    var cutter_id = $(this).parents('._video_component_cutter').attr('id');
    var preview_id = cutter_id.replace('cutter', 'preview');
    $('#' + cutter_id + ' ._media_player_rewind_in_video_editor_preview').show();
    $('#' + cutter_id + ' ._media_player_slider_disabler').hide();
    $('#' + cutter_id + ' ._media_player_play_in_video_editor_preview').show();
    $('#' + cutter_id + ' ._media_player_slider .ui-slider-handle').addClass('selected');
    $('#' + preview_id + ' video')[0].pause();
    if(videoEditorWithAudioTrack()) {
      $('#video_editor_preview_container audio')[0].pause();
    }
    setCurrentTimeToMedia($('#' + preview_id + ' video'), $('#' + cutter_id + ' ._media_player_slider').slider('value'));
  });
  
  $('body').on('click', '._media_player_rewind_in_video_editor_preview', function() {
    var identifier = getVideoComponentIdentifier($(this).parents('._video_component_cutter').attr('id'));
    var initial_time = $('#video_component_' + identifier + '_cutter').data('from');
    $('#video_component_' + identifier + '_cutter ._media_player_slider').slider('value', initial_time);
    setCurrentTimeToMedia($('#video_component_' + identifier + '_preview video'), initial_time);
  });
  
  $('body').on('click', '._video_component_cutter ._double_slider .ui-slider-range', function(e) {
    var cutter = $(this).parents('._video_component_cutter');
    var percent = cutter.data('max-to') * (e.pageX - cutter.find('._double_slider').offset().left) / cutter.find('._double_slider').width();
    resp = parseInt(percent);
    if(percent - parseInt(percent) > 0.5) {
      resp += 1;
    }
    cutter.find('.ui-slider-handle').removeClass('selected');
    cutter.find('._media_player_slider .ui-slider-handle').addClass('selected');
    selectVideoComponentCutterHandle(cutter, resp);
  });
  
  $('body').on('click', '._media_player_play_in_audio_editor_preview', function() {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var audio = component.find('audio');
    if(audio[0].error) {
      //traduzzione
      showErrorPopUp('Media Error code: '+ media[0].error.code);
    } else {
      $(this).hide();
      $('#start_audio_editor_preview').addClass('disabled');
      $('#rewind_audio_editor_preview').addClass('disabled');
      component.data('playing', true);
      component.find('._media_player_slider_disabler').show();
      component.find('._media_player_rewind_in_audio_editor_preview').hide();
      component.find('._media_player_pause_in_audio_editor_preview').show();
      deselectAllAudioEditorCursors(identifier);
      var single_slider = component.find('._media_player_slider');
      if(audio[0].currentTime < single_slider.slider('value')) {
        setCurrentTimeToMedia(audio, single_slider.slider('value'));
      }
      if(audio.readyState != 0) {
        audio[0].play();
      } else {
        audio.on('loadedmetadata', function() {
          audio[0].play();
        });
      }
    }
  });
  
  $('body').on('click', '._media_player_pause_in_audio_editor_preview', function() {
    $(this).hide();
    $('#start_audio_editor_preview').removeClass('disabled');
    $('#rewind_audio_editor_preview').removeClass('disabled');
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    component.data('playing', false);
    component.find('._media_player_slider_disabler').hide();
    component.find('._media_player_rewind_in_audio_editor_preview').show();
    component.find('._media_player_play_in_audio_editor_preview').show();
    selectAudioEditorCursor(identifier);
    component.find('audio')[0].pause();
    setCurrentTimeToMedia(component.find('audio'), component.find('._media_player_slider').slider('value'));
  });
  
  $('body').on('click', '._media_player_rewind_in_audio_editor_preview', function() {
    var component = $(this).parents('._audio_editor_component');
    var initial_time = component.data('from');
    component.find('._media_player_slider').slider('value', initial_time);
    setCurrentTimeToMedia(component.find('audio'), initial_time);
    component.find('._current_time').html(secondsToDateString(initial_time));
  });
  
  $('body').on('click', '._audio_editor_component ._double_slider .ui-slider-range', function(e) {
    var component = $(this).parents('._audio_editor_component');
    var identifier = getAudioComponentIdentifier(component);
    var percent = component.data('max-to') * (e.pageX - component.find('._double_slider').offset().left) / component.find('._double_slider').width();
    resp = parseInt(percent);
    if(percent - parseInt(percent) > 0.5) {
      resp += 1;
    }
    selectAudioEditorCursor(identifier);
    selectAudioComponentCutterHandle(component, resp);
  });
  
  
  // NELLA HOMEPAGE APERTURA AUTOMATICA DELLA FINESTRA DI LOGIN 
  // SE C'É L'ATTRIBUTO login NELLA PARTE DELLA QUERY DELL'URL
  if ( currentPageIs('prelogin', 'home') ) {
    var parsedLocation = UrlParser.parse(window.location.href);
    if ( _.contains( _.keys(parsedLocation.searchObj), 'login') ) {
      $('._show_login_form_container').click();
    }
  }
  
});
