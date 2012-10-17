function initializeNotifications() {
  var fumetto = $('#tooltip_arancione');
  var button = $('#notifications_button');
  var tooltip = $('#tooltip_content');
  if(parseInt(fumetto.data('number')) > 0) {
    fumetto.css('display', 'block');
    button.addClass('current');
  }
  button.click(function() {
    if(tooltip.css('display') == 'none') {
      setNotificationsSeen();
      tooltip.css('display', 'block');
    } else {
      $('#tooltip_content ._to_be_set_gray').addClass('current');
      tooltip.css('display', 'none');
      $('#notifications_button').removeClass('current');
    }
  });
}

function setNotificationsSeen() {
  if($('#tooltip_arancione').data('number') != '0') {
    $.ajax({
      type: 'post',
      url: '/notifications/seen'
    });
  }
}

function initializeHelp() {
  var tooltip_help = $('#tooltip_help');
  var help = $('#help');
  help.click(function() {
    if(tooltip_help.css('display') == 'none') {
      tooltip_help.css('display', 'block');
      help.addClass('current');
    } else {
      tooltip_help.css('display', 'none');
      help.removeClass('current');
    }
  });
}
