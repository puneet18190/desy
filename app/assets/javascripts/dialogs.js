function showRestoreCacheMediaElementEditorPopUp(callback_ok, callback_no) {
  var obj = $('#dialog-restore-cache-media-element-editor');
  var caption = $('#popup_captions_container').data('restore-cache-media-element-editor-message');
  var msg_ok = $('#popup_captions_container').data('restore-cache-media-element-editor-yes');
  var msg_no = $('#popup_captions_container').data('restore-cache-media-element-editor-no');
  content = '<p class="upper">' + caption + '</p>';
  var dialog_buttons = {};
  dialog_buttons[msg_ok] = callback_ok;
  dialog_buttons[msg_no] = callback_no;
  if(obj.data('dialog')) {
    obj.html(content);
    obj.dialog('option', 'buttons', dialog_buttons);
    obj.dialog('open');
  } else {
    obj.show();
    obj.html(content);
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 485,
      show: "fade",
      hide: {effect: "fade"},
      buttons: dialog_buttons,
      open: function(event, ui) {
        var overlay = obj.parent().prev();
        overlay.addClass('dialog_opaco');
      },
      beforeClose: function() {
        $('.dialog_opaco').removeClass('dialog_opaco');
      },
      create:function () {
        $(this).closest('.ui-dialog').find('.ui-button').addClass('upper').addClass('schiacciato');
      }
    });
  }
}

function showLessonNotificationPopUp(lesson_id) {
  var lesson_id_number = lesson_id.split('_');
  lesson_id_number = lesson_id_number[lesson_id_number.length - 1];
  var obj = $('#lesson-notification');
  $('#lesson-notification form').attr('action', ('/lessons/' + lesson_id_number + '/notify_modification'));
  var html_cover_content = $('._lesson_thumb._lesson_' + lesson_id_number).html();
  $('._lesson_notification_cover').html(html_cover_content);
  obj.data('lesson-id', lesson_id);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 710,
      height: 300,
      hide: {effect: "fade"},
      show: "fade",
      open: function() {
        $('#lesson-notification #lesson_notify_modification_details').blur();
        $('#lesson-notification #lesson_notify_modification_details').val($('#lesson-notification').data('message-placeholder'));
        $('#lesson-notification #lesson_notify_modification_details_placeholder').val('');
      }
    });
  }
}

function showSendLessonLinkPopUp(lesson_id) {
  var obj = $('#dialog-virtual-classroom-send-link');
  $('#dialog-virtual-classroom-send-link form').attr('action', ('/virtual_classroom/' + lesson_id + '/send_link'));
  var html_cover_content = $('#virtual_classroom_lesson_' + lesson_id + ' ._lesson_thumb').html();
  $('#dialog-virtual-classroom-send-link ._lesson_thumb').html(html_cover_content);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 690,
      height: 410,
      show: "fade",
      hide: {effect: "fade"},
      beforeClose: function() {
        $('#virtual_classroom_send_link_mails_box').data('jsp').destroy();
      },
      open: function() {
        $('#virtual_classroom_emails_selector').blur();
        $('#virtual_classroom_send_link_message').blur();
        $('#virtual_classroom_emails_selector').val(obj.data('emails-placeholder'));
        $('#virtual_classroom_send_link_message').val(obj.data('message-placeholder'));
        $('#virtual_classroom_emails_selector').data('placeholdered', true);
        $('#virtual_classroom_send_link_message_placeholder').val('');
        $('#virtual_classroom_send_link_hidden_emails').val('');
        $('#virtual_classroom_send_link_mails_box').html('');
        $('#select_mailing_list option[selected]').removeAttr('selected');
        var placeholder_select_box = $('#select_mailing_list option').first();
        placeholder_select_box.attr('selected', 'selected');
        $($('#select_mailing_list').next().find('a')[1]).html(placeholder_select_box.html());
      }
    });
  }
}

function showVirtualClassroomQuickSelectPopUp(content) {
  var obj = $('#dialog-virtual-classroom-quick-select');
  obj.html(content);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 920,
      show: "fade",
      hide: {effect: "fade"},
      open: function(event, ui) {
        var overlay = obj.parent().prev();
        overlay.addClass('dialog_opaco');
      },
      close: function() {
        if(obj.data('loaded')) {
          var loaded_msg = obj.data('loaded-msg');
          if(obj.data('loaded-correctly')) {
            showOkPopUp(loaded_msg);
          } else {
            showErrorPopUp(loaded_msg);
          }
        }
        obj.data('loaded', false);
      }
    });
  }
}

function showTimedPopUp(content, id) {
  var obj = $('#' + id);
  obj.html(content);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 485,
      show: "fade",
      hide: {effect: "fade"},
      open: function(event, ui) {
        setTimeout(function() {
          closePopUp(id);
        }, $('#popup_parameters_container').data('timeout'));
      }
    });
  }
}

// FUNCTIONS DIRECTLY USED IN THE APPLICATION

function showErrorPopUp(content) {
  var new_content = '<img src="/assets/unsuccess.png"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-error');
}

function showOkPopUp(content) {
  var new_content = '<img src="/assets/success.png"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-ok');
}

function showMediaElementInfoPopUp(media_element_id) {
  var obj = $('#dialog-media-element-' + media_element_id);
  if(!obj.data('loaded')) {
    $.ajax({
      type: 'get',
      url: '/media_elements/' + media_element_id + '/preview/load'
    });
  } else {
    if(obj.data('dialog')) {
      obj.dialog('open');
    } else {
      obj.show();
      obj.dialog({
        modal: true,
        resizable: false,
        draggable: false,
        width: 874,
        show: "fade",
        hide: {effect: "fade"},
        open: function() {
          customOverlayClose();
        },
        beforeClose: function() {
          removeCustomOverlayClose();
        },
        close: function() {
          resetMediaElementChangeInfo(media_element_id);
          $(this).find('._report_form_content').hide();
          $(this).find('._report_media_element_click').removeClass('report_light');
          var player_container = $('#dialog-media-element-' + media_element_id + ' ._instance_of_player');
          if(player_container.length > 0) {
            stopMedia('#dialog-media-element-' + media_element_id + ' ' + player_container.data('media-type'));
          }
          $('#dialog-media-element-' + media_element_id + ' ._audio_preview_in_media_element_popup').show();
          $('#dialog-media-element-' + media_element_id + ' ._change_info_container').hide();
          var change_info_button = $('#dialog-media-element-' + media_element_id + ' ._change_info_to_pick');
          if(change_info_button.hasClass('change_info_light')) {
            change_info_button.addClass('change_info');
            change_info_button.removeClass('change_info_light');
          }
        }
      });
    }
  }
}

function showLoadMediaElementPopUp() {
  var obj = $('#load-media-element');
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 760,
      show: 'fade',
      hide: {effect: 'fade'},
      open: function(event, ui) {
        $('input').blur();
        $('#load-media-element #title').val($('#load-media-element').data('placeholder-title'));
        $('#load-media-element #description').val($('#load-media-element').data('placeholder-description'));
        $('#load-media-element #title_placeholder').val('');
        $('#load-media-element #description_placeholder').val('');
        $('#load-media-element #tags_value').val('');
        $('#load-media-element ._tags_container span').remove();
        $('#load-media-element ._tags_container ._placeholder').show();
        $('#media_element_media_show').text($('#load-media-element').data('placeholder-media'));
        $('#load-media-element .form_error').removeClass('form_error');
        $('#load-media-element .innerUploadFileButton').val('');
      },
      close: function() {
        $('#load-media-element iframe').attr('src', 'about:blank');
      }
    });
  }
}

function showImageInGalleryPopUp(image_id, callback) {
  var obj = $('#dialog-image-gallery-' + image_id);
  var my_width = resizedWidthForImageGallery(obj.find('a').data('width'), obj.find('a').data('height'));
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      closeOnEscape: true,
      modal: true,
      width: my_width,
      resizable: false,
      draggable: false,
      show: "fade",
      hide: {
        effect: "fade",
        duration: 500
      },
      open: function() {
        customOverlayClose();
      },
      beforeClose: function() {
        removeCustomOverlayClose();
      },
      close: function() {
        if(typeof(callback) != 'undefined') {
          callback();
        }
      }
    });
  }
}

function showVideoInGalleryPopUp(video_id) {
  var obj = $('#dialog-video-gallery-' + video_id);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      closeOnEscape: true,
      modal: true,
      resizable: false,
      draggable: false,
      width: 446,
      height: 360,
      show: "fade",
      hide: {
        effect: "fade",
        duration: 500
      },
      open: function() {
        customOverlayClose();
        var instance_id = $('#dialog-video-gallery-' + video_id + ' ._empty_video_player, #dialog-video-gallery-' + video_id + ' ._instance_of_player').attr('id');
        if(!$('#' + instance_id).data('initialized')) {
          var button = $(this).find('._select_video_from_gallery');
          var duration = button.data('duration');
          $('#' + instance_id + ' source[type="video/mp4"]').attr('src', button.data('mp4'));
          $('#' + instance_id + ' source[type="video/webm"]').attr('src', button.data('webm'));
          $('#' + instance_id + ' video').load();
          $('#' + instance_id + ' ._media_player_total_time').html(secondsToDateString(duration));
          $('#' + instance_id).data('duration', duration);
          $('#' + instance_id).removeClass('_empty_video_player').addClass('_instance_of_player');
          initializeMedia(instance_id, 'video');
        }
      },
      beforeClose: function() {
        stopMedia('#dialog-video-gallery-' + video_id + ' video');
        removeCustomOverlayClose();
      }
    });
  }
}

function showConfirmPopUp(title, content, msg_ok, msg_no, callback_ok, callback_no) {
  var obj = $('#dialog-confirm');
  content = '<img src="/assets/alert.png"/><h1>' + title + '</h1><p>' + content + '</p>';
  var dialog_buttons = {};
  dialog_buttons[msg_ok] = callback_ok;
  dialog_buttons[msg_no] = callback_no;
  if(obj.data('dialog')) {
    obj.html(content);
    obj.dialog('option', 'buttons', dialog_buttons);
    obj.dialog('open');
  } else {
    obj.show();
    obj.html(content);
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 485,
      show: "fade",
      hide: {effect: "fade"},
      buttons: dialog_buttons
    });
  }
}

function removeCompletelyMediaElementPopup(media_element_id) {
  var obj = $('#dialog-media-element-' + media_element_id);
  if(obj.length == 0) {
    return;
  }
  if(obj.data('dialog')) {
    obj.dialog('destroy');
  }
  obj.remove();
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function customOverlayClose() {
  $('.ui-widget-overlay').show().css('height', (2 * $(window).height()) + 'px');
  $('.ui-widget-overlay').addClass('_close_on_click_out');
}

function removeCustomOverlayClose() {
  $('.ui-widget-overlay').removeClass('_close_on_click_out');
}
