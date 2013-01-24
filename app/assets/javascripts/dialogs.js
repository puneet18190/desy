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

function showSendLessonLinkPopUp(lesson_id) {
  var obj = $('#dialog-virtual-classroom-send-link');
  $('#dialog-virtual-classroom-send-link form').attr('action', ('/virtual_classroom/' + lesson_id + '/send_link'));
  var html_cover_content = $('#virtual_classroom_lesson_' + lesson_id + ' ._lesson_thumb').html();
  $('#dialog-virtual-classroom-send-link ._lesson_thumb').html(html_cover_content);
  if(obj.data('dialog')) {
    obj.dialog('open');
    initializeBlurTextFieldsSendLessonLink();
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 654,
      height: 400,
      show: "fade",
      open: function() {
        initializeBlurTextFieldsSendLessonLink();
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
        var player_container = $('#dialog-media-element-' + media_element_id + ' ._instance_of_player');
        if(player_container.length > 0) {
          stopMedia('#dialog-media-element-' + media_element_id + ' ' + player_container.data('media-type'));
        }
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
        $('#load-media-element #tags').val($('#load-media-element').data('placeholder-tags'));
        $('#load-media-element #title_placeholder').val('');
        $('#load-media-element #description_placeholder').val('');
        $('#load-media-element #tags_placeholder').val('');
        $('#media_element_media_show').text($('#load-media-element').data('placeholder-media'));
        $('#load-media-element .form_error').removeClass('form_error');
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
      open: function(){
        customOverlayClose();
        var instance_id = $('#dialog-video-gallery-' + video_id + ' ._instance_of_player').attr('id');
        if(!$('#' + instance_id).data('initialized')) {
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

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function customOverlayClose(){
  $(".ui-widget-overlay").css('display','block').css('height',(2*$(window).height())+"px");
  $(".ui-widget-overlay").addClass("_close_on_click_out");
}

function removeCustomOverlayClose(){
  $(".ui-widget-overlay").removeClass("_close_on_click_out");
}
