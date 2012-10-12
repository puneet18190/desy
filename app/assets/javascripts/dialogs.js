function showNormalPopUp(content, title) {
  $("#dialog-normal").attr('title', title);
  $("#dialog-normal").html(content);
  $("#dialog-normal").dialog("open");
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
