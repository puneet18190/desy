function showErrorPopUp(content, title) {
  $("#dialog-error").attr('title', title);
  $("#dialog-error").html(content);
  $("#dialog-error").dialog("open");
}

function showShadePopUp(content, title) {
  $("#dialog-shade").attr('title', title);
  $("#dialog-shade").html(content);
  $("#dialog-shade").dialog("open");
}

function showTimedPopUp(content, title) {
  $("#dialog-timed").attr('title', title);
  $("#dialog-timed").html(content);
  $("#dialog-timed").dialog("open");
}
