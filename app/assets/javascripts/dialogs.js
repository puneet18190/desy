function showSendLessonLinkPopUp(lesson_id) {
  var obj = $('#dialog-virtual-classroom-send-link');
  $('#dialog-virtual-classroom-send-link form').attr('action', ('/virtual_classroom/' + lesson_id + '/send_link'));
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    var dialog_buttons = {};
    var msg_ok = $('#popup_captions_container_virtual_classroom').data('ok-send-lesson-link');
    var msg_no = $('#popup_captions_container_virtual_classroom').data('dont-send-lesson-link');
    dialog_buttons[msg_ok] = function() {
      alert('yesss');
      closePopUp('dialog-virtual-classroom-send-link');
    };
    dialog_buttons[msg_no] = function() {
      alert('noooo');
      closePopUp('dialog-virtual-classroom-send-link');
    };
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      width: 920,
      show: "fade",
      hide: "fade",
      buttons: dialog_buttons
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
      width: 920,
      show: "fade",
      hide: "fade",
      open: function(event, ui) {
        $(".ui-widget-overlay").css({
          opacity: 0.9,
          filter: "Alpha(Opacity=100)",
          backgroundColor: "#000",
          zIndex: 11,
        });
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
      width: 874,
      show: "fade",
      hide: "fade",
      close: function() {
        $('#dialog-media-element-' + media_element_id + ' ._change_info_container').css('display', 'none');
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
      width: 760,
      show: "fade",
      hide: "fade"
    });
  }
}

function showImageMediaElementPopUp(id) {
  var thumb = '._gallery_img_expanded_'+id;
  var obj = $(thumb);
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      closeOnEscape: true,
      modal: true,
      resizable: true,
      resize:"auto",
      maxWidth: 440,
      maxHeight: 480,
      show: "fade",
      hide: "fade"
    });
  }
  
  $('.ui-widget-overlay').click(function() { 
    $(thumb).dialog("close");
  });
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
