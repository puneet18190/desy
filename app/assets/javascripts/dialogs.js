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

function closePopUp(id) {
  $('#' + id).dialog('close');
}


// FUNCTIONS DIRECTLY USED IN THE APPLICATION

function showErrorPopUp(content) {
  var new_content = '<img src="/assets/unsuccess.svg"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-error');
}

function showOkPopUp(content) {
  var new_content = '<img src="/assets/success.svg"/><h1>' + content + '</h1>';
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
