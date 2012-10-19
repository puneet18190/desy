function showPopUp(content, title, id) {
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
      resizable: false
      //open: function(event, ui) {
       // setTimeout(closePopUp('dialog-error'), 2500);
      //}
    });
    
  }
}

function closePopUp(id) {
  $('#' + id).dialog('close');
}

function showErrorPopUp(content, title) {
  showPopUp(content, title, 'dialog-error');
}

function showOkPopUp(content, title) {
  showPopUp(content, title, 'dialog-ok');
}

function showShadePopUp(content, title) {
  showPopUp(content, title, 'dialog-shade');
}

function showTimedPopUp(content, title) {
  showPopUp(content, title, 'dialog-timed');
}
