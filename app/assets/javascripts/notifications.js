function initializeNotifications() {
  var fumetto = $('#tooltip_arancione');
  var button = $('#notifications_button');
  if(fumetto.data('number') > 0) {
    fumetto.css('display', 'block');
    button.addClass('current');
  }
  button.click(function() {
  }
}
