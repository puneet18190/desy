function showTimedPopUp(content, title, id) {
  var obj = $('#' + id);
  if(obj.hasClass('ui-dialog-content')) {
    obj.dialog('option', 'title', title);
    obj.html(content);
    obj.dialog('open');
  } else {
    obj.css('display', 'block');
    obj.attr('title', title);
    obj.html(content);
    obj.dialog({
      modal: true,
      resizable: false,
      open: function(event, ui) {
        setTimeout(function() {
          closePopUp('dialog-error')
        }, window.desy.timeOutDialog);
      }
    });
  }
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function showErrorPopUp(content, title) {
  showTimedPopUp(content, title, 'dialog-error');
}

function showOkPopUp(content, title) {
  showTimedPopUp(content, title, 'dialog-ok');
}
