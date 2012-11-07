function showTimedPopUp(content, id) {
  var obj = $('#' + id);
  if(obj.hasClass('ui-dialog-content')) {
    obj.html(content);
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
    obj.html(content);
    obj.dialog({
      modal: true,
      resizable: false,
      width: 485,
      show: "fade",
      hide: "fade",
      open: function(event, ui) {
        setTimeout(function() {
          closePopUp(id)
        }, window.desy.timeOutDialog);
      }
    });
  }
}

function showConfirmPopUp(content, msg_ok, msg_no) {
  var obj = $('#dialog-confirm');
  content = '<img src="/assets/alert.png"/><h1>' + content + '</h1>';
  var dialog_buttons = {};
  dialog_buttons[msg_ok] = function() {
    alert('Okkk');
  }
  dialog_buttons[msg_no] = function() {
    obj.dialog('close');
  }
  if(obj.hasClass('ui-dialog-content')) {
    obj.html(content);
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
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


function showLoadMediaElementPopUp() {
  var obj = $('#load-media-element');
  if(obj.hasClass('ui-dialog-content')) {
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
    obj.dialog({
      modal: true,
      resizable: false,
      width: 874,
      show: "fade",
      hide: "fade"
    });
  }
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function showImageMediaElementPopUp(id) {
  thumb = '._gallery_img_expanded_'+id;
  var obj = $(thumb);
  if(obj.hasClass('ui-dialog-content')) {
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
    obj.dialog({
      modal: true,
      resizable: false,
      width: 410,
      show: "fade",
      hide: "fade"
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
  if(obj.hasClass('ui-dialog-content')) {
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
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
