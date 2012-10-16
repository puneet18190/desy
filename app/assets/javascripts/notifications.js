function initializeNotifications() {
  var fumetto = $('#tooltip_arancione');
  var button = $('#notifications_button');
  var tooltip = $('#tooltip_content');
  if(fumetto.data('number') > 0) {
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
  if($('#tooltip_arancione').data('number') > 0) {
    $.ajax({
      type: 'post',
      url: '/notifications/seen'
    });
  }
}
