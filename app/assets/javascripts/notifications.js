function initializeNotifications() {
  var fumetto = $('#tooltip_arancione');
  var button = $('#notifications_button');
  var tooltip = $('#tooltip_content');
  if(parseInt(fumetto.data('number')) > 0) {
    fumetto.css('display', 'block');
    button.addClass('current');
  }
  button.click(function() {
    $('#tooltip_help').css('display', 'none');
    $('#help').removeClass('current');
    if(tooltip.css('display') == 'none') {
      $('#tooltip_arancione').css('display', 'none');
      setNotificationsSeen();
      tooltip.css('display', 'block');
      button.addClass('current');
    } else {
      $('#tooltip_content ._to_be_set_gray').addClass('current');
      tooltip.css('display', 'none');
      if(parseInt(fumetto.data('number')) > 0) {
        fumetto.css('display', 'block');
      } else {
        button.removeClass('current');
      }
    }
  });
}

function setNotificationsSeen() {
  if($('#tooltip_arancione').data('fired') != 'true') {
    var offset = $('#tooltip_content').data('offset');
    $.ajax({
      type: 'post',
      url: '/notifications/seen?offset=' + offset
    });
  }
}

function initializeHelp() {
  var tooltip_help = $('#tooltip_help');
  var help = $('#help');
  help.click(function() {
    $('#tooltip_content').css('display', 'none');
    $('#notifications_button').removeClass('current');
    if(tooltip_help.css('display') == 'none') {
      tooltip_help.css('display', 'block');
      help.addClass('current');
    } else {
      tooltip_help.css('display', 'none');
      help.removeClass('current');
    }
  });
}
