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
    obj.dialog();
  }
}

function showErrorPopUp(content, title) {
  showPopUp(content, title, 'dialog-error');
}

function showShadePopUp(content, title) {
  showPopUp(content, title, 'dialog-shade');
}

function showTimedPopUp(content, title) {
  showPopUp(content, title, 'dialog-timed');
}
