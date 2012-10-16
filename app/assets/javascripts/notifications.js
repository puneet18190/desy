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
      $.ajax({
        type: 'post',
        url: '/notifications/seen'
      });
      tooltip.css('display', 'block');
    } else {
      tooltip.css('display', 'none');
    }
  });
}
