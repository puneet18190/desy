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

function showErrorPopUp(content) {
  var new_content = '<img src="/assets/testa.jpg"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-error');
}

function showOkPopUp(content) {
  var new_content = '<img src="/assets/testa.jpg"/><h1>' + content + '</h1>';
  showTimedPopUp(new_content, 'dialog-ok');
}
