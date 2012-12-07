function showSendLessonLinkPopUp(lesson_id) {
  var obj = $('#dialog-virtual-classroom-send-link');
  $('#dialog-virtual-classroom-send-link form').attr('action', ('/virtual_classroom/' + lesson_id + '/send_link'));
  var html_cover_content = $('#virtual_classroom_lesson_' + lesson_id + ' ._cover_slide_thumb').html();
  $('#dialog-virtual-classroom-send-link ._cover_slide_thumb').html(html_cover_content);
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
      hide: "fade",
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
      hide: "fade",
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
      hide: "fade",
      close: function() {
        var player_container = $('#dialog-media-element-' + media_element_id + ' ._instance_of_player_' + media_element_id);
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
      show: "fade",
      hide: "fade"
    });
  }
}

function showImageInGalleryPopUp(image_id) {
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
      hide: "fade",
      open: function() {
        customOverlayClose();
      },
      beforeClose: function() {
        removeCustomOverlayClose();
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
      hide: "fade",
      open: function(){
        customOverlayClose();
      },
      beforeClose: function() {
        removeCustomOverlayClose();
      },
      close: function() {
        stopMedia('#dialog-video-gallery-' + video_id + ' video');
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
      hide: "fade",
      buttons: dialog_buttons
    });
  }
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function customOverlayClose(){
  $(".ui-widget-overlay").addClass("_close_on_click_out");
}

function removeCustomOverlayClose(){
  $(".ui-widget-overlay").removeClass("_close_on_click_out");
}
