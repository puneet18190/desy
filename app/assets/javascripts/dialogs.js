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
      open: function(event, ui) {
        setTimeout(function() {
          closePopUp('dialog-error')
        }, window.desy.timeOutDialog);
      },
      dialogClass: 'alert'
    });
  }
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function showErrorPopUp(content) {
  showTimedPopUp(content, 'dialog-error');
}

function showOkPopUp(content) {
  showTimedPopUp(content, 'dialog-ok');
}
