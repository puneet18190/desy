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

function closeMediaElementInfoPopUp(id) {
  
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

function showMediaElementInfoPopUp(media_element_id, destination) {
  var target = $('#' + destination + '_' + media_element_id + ' ._media_element_popup');
  var content = target.html();
  target.html('');
  var obj = $('#dialog-media-element');
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
      hide: "fade"
    });
  }
}
