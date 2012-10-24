function initializeNotifications() {
  if(parseInt($('#tooltip_arancione').data('number')) > 0) {
    showNotificationsFumetto();
    showNotificationsButton();
  }
  $('body').on('click', '#notifications_button', function() {
    if($('#tooltip_content').css('display') == 'none') {
      hideHelpTooltip();
      hideHelpButton();
      showNotificationsTooltip();
      hideNotificationsFumetto();
      if(!$('#notifications_button').hasClass('current')) {
        showNotificationsButton();
      }
    } else {
      hideNotificationsTooltip();
      if(parseInt($('#tooltip_arancione').data('number')) > 0) {
        showNotificationsFumetto();
      } else {
        hideNotificationsButton();
      }
    }
  });
  $('body').on('click', '._single_notification a', function() {
    var my_content = $('#' + $(this).closest('li').attr('id') + ' ._expanded_notification').html();
    var my_expanded = $('#expanded_notification');
    if(my_expanded.css('display') == 'none') {
      hideAllExpandedNotifications();
      my_expanded.html(my_content);
      my_expanded.css('display', 'block');
      if(!$(this).hasClass('current')) {
        $.ajax({
          type: 'post',
          url: 'notifications/' + $(this).data('param') + '/seen'
        });
      }
    } else {
      hideAllExpandedNotifications();
    }
  });
}

function initializeHelp() {
  $('#help').click(function() {
    if($('#tooltip_help').css('display') == 'none') {
      hideNotificationsTooltip();
      hideNotificationsButton();
      hideNotificationsFumetto();
      showHelpTooltip();
      showHelpButton();
    } else {
      hideHelpTooltip();
      hideHelpButton();
      if($('#tooltip_arancione').data('number') > 0) {
        showNotificationsButton();
        showNotificationsFumetto();
      }
    }
  });
}

function hideAllExpandedNotifications() {
  $('#expanded_notification').html('');
  $('#expanded_notification').css('display', 'none');
}

function hideNotificationsTooltip() {
  $('#tooltip_content').css('display', 'none');
  hideAllExpandedNotifications();
}

function showNotificationsTooltip() {
  $('#tooltip_content').css('display', 'block');
}

function hideHelpTooltip() {
  $('#tooltip_help').css('display', 'none');
}

function showHelpTooltip() {
  $('#tooltip_help').css('display', 'block');
}

function hideNotificationsButton() {
  $('#notifications_button').removeClass('current');
}

function showNotificationsButton() {
  $('#notifications_button').addClass('current');
}

function hideNotificationsFumetto() {
  $('#tooltip_arancione').css('display', 'none');
}

function showNotificationsFumetto() {
  $('#tooltip_arancione').css('display', 'block');
}

function hideHelpButton() {
  $('#help').removeClass('current');
}

function showHelpButton() {
  $('#help').addClass('current');
}
