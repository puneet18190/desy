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
          closePopUp(id)
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


//// FIXME FIXME FIXME temporaneo per aurelia

function showProvaPopUp(content) {
  var id = 'dialog-ok';
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
      
      dialogClass: 'alert'
    });
  }
}
