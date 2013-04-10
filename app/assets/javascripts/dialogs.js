/**
This module contains the javascript functions that use JQueryUi dialogs. Some of them are closed with a time delay (class {{#crossLink "DialogsTimed"}}{{/crossLink}}), other are closed with buttons by the user (class {{#crossLink "DialogsConfirmation"}}{{/crossLink}}), and other ones contain a form to be filled in by the user (class {{#crossLink "DialogsWithForm"}}{{/crossLink}}).
@module dialogs
**/





/**
Close a dialog with given HTML id.
@method closePopUp
@for DialogsAccessories
@param id {String} HTML id of the dialog
**/
function closePopUp(id) {
  $('#' + id).dialog('close');
}

/**
Adds the class <i>close on click out</i> to the widget overlay: this function is called on the callbacks of dialog functions, to allow the user to close the dialog directly clicking out.
@method customOverlayClose
@for DialogsAccessories
**/
function customOverlayClose() {
  $('.ui-widget-overlay').show().css('height', (2 * $(window).height()) + 'px');
  $('.ui-widget-overlay').addClass('_close_on_click_out');
}

/**
Close and successively remove HTML for a given media element popup.
@method removeCompletelyMediaElementPopup
@for DialogsAccessories
@param media_element_id {Number} id of the element in the database, used to extract the HTML id of the dialog
**/
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

/**
Opposite of {{#crossLink "DialogsAccessories/customOverlayClose:method"}}{{/crossLink}}. Remember that the widget-overlay object is unique for every dialog built with JQueryUi, thus it's compulsory to remove the class <i>close on click out</i> before opening a new dialog.
@method removeCustomOverlayClose
@for DialogsAccessories
**/
function removeCustomOverlayClose() {
  $('.ui-widget-overlay').removeClass('_close_on_click_out');
}





/**
Generic popup for confirmation prompt
@method showConfirmPopUp
@for DialogsConfirmation
@param title {String} popup title
@param content {String} popup content
@param msg_ok {String} text for ok button
@param msg_no {String} text for cancel button
@param callback_ok {Object} ok callback function
@param callback_no {Object} cancel callback function
**/
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
      show: 'fade',
      hide: {effect: 'fade'},
      buttons: dialog_buttons
    });
  }
}

/**
Modal for media element editor, asking whether or not restore cached content. Available for audio and video editor only.
@method showRestoreCacheMediaElementEditorPopUp
@for DialogsConfirmation
@param callback_ok {Object} restore callback function
@param callback_no {Object} don't restore callback function
**/
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
      width: 520,
      show: 'fade',
      hide: {effect: 'fade'},
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





/**
Image popup for image gallery Uses: [resizedWidthForImageGallery](../classes/resizedWidthForImageGallery.html#method_resizedWidthForImageGallery) and [customOverlayClose](../classes/customOverlayClose.html#method_customOverlayClose) and [removeCustomOverlayClose](../classes/removeCustomOverlayClose.html#method_removeCustomOverlayClose)
@method showImageInGalleryPopUp
@for DialogsGalleries
@param image_id {Number} image id
@param callback {Object} callback function
**/
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
      show: 'fade',
      hide: {
        effect: 'fade',
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

/**
Video popup for video gallery Uses: [customOverlayClose](../classes/customOverlayClose.html#method_customOverlayClose) and [initializeMedia](../classes/initializeMedia.html#method_initializeMedia) and [stopMedia](../classes/stopMedia.html#method_stopMedia) and [removeCustomOverlayClose](../classes/removeCustomOverlayClose.html#method_removeCustomOverlayClose)
@method showVideoInGalleryPopUp
@for DialogsGalleries
@param video_id {Number} video id
**/
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
      show: 'fade',
      hide: {
        effect: 'fade',
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





/**
Modal with error icon and custom content Uses: [showTimedPopUp](../classes/showTimedPopUp.html#method_showTimedPopUp)
@method showErrorPopUp
@for DialogsTimed
@param content {Object} modal text content
**/
function showErrorPopUp(content) {
  var new_content = '<img src="/assets/unsuccess.png"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-error');
}

/**
Modal with ok icon and custom content Uses: [showTimedPopUp](../classes/showTimedPopUp.html#method_showTimedPopUp)
@method showOkPopUp
@for DialogsTimed
@param content {Object} modal text content
**/
function showOkPopUp(content) {
  var new_content = '<img src="/assets/success.png"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-ok');
}

/**
Show timed popup that auto close after _n_ seconds. Timeout is handled with data-timeout into `_popup_parameters_container_` Uses: [closePopUp](../classes/closePopUp.html#method_closePopUp)
@method showTimedPopUp
@for DialogsTimed
@param content {Object} lessons list partial
@param id {String} dialog select id 
**/
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
      show: 'fade',
      hide: {effect: 'fade'},
      open: function(event, ui) {
        setTimeout(function() {
          closePopUp(id);
        }, $('#popup_parameters_container').data('timeout'));
      }
    });
  }
}





/**
Modal warning on unpublish lesson.
@method showLessonNotificationPopUp
@for DialogsWithForm
@param lesson_id {Number} lesson id
**/
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
      hide: {effect: 'fade'},
      show: 'fade',
      open: function() {
        $('#lesson-notification #lesson_notify_modification_details').blur();
        $('#lesson-notification #lesson_notify_modification_details').val($('#lesson-notification').data('message-placeholder'));
        $('#lesson-notification #lesson_notify_modification_details_placeholder').val('');
      }
    });
  }
}

/**
Modal for new media element form
@method showLoadMediaElementPopUp
@for DialogsWithForm
**/
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

/**
Modal for media element update form Uses: [customOverlayClose](../classes/customOverlayClose.html#method_customOverlayClose) and [removeCustomOverlayClose](../classes/removeCustomOverlayClose.html#method_removeCustomOverlayClose) and [resetMediaElementChangeInfo](../classes/resetMediaElementChangeInfo.html#method_resetMediaElementChangeInfo) and [stopMedia](../classes/stopMedia.html#method_stopMedia)
@method showMediaElementInfoPopUp
@for DialogsWithForm
@param media_element_id {Number} media element id
**/
function showMediaElementInfoPopUp(media_element_id) {
  var obj = $('#dialog-media-element-' + media_element_id);
  if(!$('._media_element_item_id_' + media_element_id).data('preview-loaded')) {
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
        show: 'fade',
        hide: {effect: 'fade'},
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

/**
Share lesson link popup in virtual classroom 
@method showSendLessonLinkPopUp
@for DialogsWithForm
@param lesson_id {Number} lesson id
**/
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
      show: 'fade',
      hide: {effect: 'fade'},
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

/**
Modal with lessons to add to virtual classroom. Uses: [showOkPopUp](../classes/showOkPopUp.html#method_showOkPopUp) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method showVirtualClassroomQuickSelectPopUp
@for DialogsWithForm
@param content {Object} lessons list partial
**/
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
      show: 'fade',
      hide: {effect: 'fade'},
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
