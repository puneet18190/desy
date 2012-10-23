function initializeNotifications() {
  var fumetto = $('#tooltip_arancione');
  var button = $('#notifications_button');
  var tooltip = $('#tooltip_content');
  if(parseInt(fumetto.data('number')) > 0) {
    fumetto.css('display', 'block');
    button.addClass('current');
  }
  $('body').on('click', '#notifications_button', function() {
    $('#tooltip_help').css('display', 'none');
    $('#help').removeClass('current');
    if(tooltip.css('display') == 'none') {
      $('#tooltip_arancione').css('display', 'none');
      tooltip.css('display', 'block');
      button.addClass('current');
    } else {
      tooltip.css('display', 'none');
      if(parseInt(fumetto.data('number')) > 0) {
        fumetto.css('display', 'block');
      } else {
        button.removeClass('current');
      }
    }
  });
  $('body').on('click', '._single_notification a', function() {
    var my_notification = $(this);
    var my_id = my_notification.closest('li').attr('id');
    var my_expanded = $('#' + my_id + ' ._expanded_notification');
    if(my_expanded.css('display') == 'none') {
      my_expanded.css('display', 'block');
      if(!my_notification.hasClass('current')) {
        $.ajax({
          type: 'post',
          url: 'notifications/' + my_notification.data('param') + '/seen'
        });
      }
    } else {
      my_expanded.css('display', 'none');
    }
  });
}

function initializeHelp() {
  var tooltip_help = $('#tooltip_help');
  var help = $('#help');
  help.click(function() {
    if(tooltip_help.css('display') == 'none') {
      $('#tooltip_content').css('display', 'none');
      $('#tooltip_arancione').css('display', 'none');
      $('#notifications_button').removeClass('current');
      tooltip_help.css('display', 'block');
      help.addClass('current');
    } else {
      if(parseInt($('#tooltip_arancione').data('number')) > 0) {
        $('#tooltip_arancione').css('display', 'block');
        $('#notifications_button').addClass('current');
      }
      tooltip_help.css('display', 'none');
      help.removeClass('current');
    }
  });
}
