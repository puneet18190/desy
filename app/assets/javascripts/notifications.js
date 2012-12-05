function initializeNotifications() {
  if($('#tooltip_arancione').data('number') > 0) {
    showNotificationsFumetto();
    showNotificationsButton();
  }
  $('body').on('click', '#notifications_button', function() {
    if($('#tooltip_content').css('display') == 'none') {
      hideHelpTooltip();
      hideHelpButton();
      $('#tooltip_content').show('fade', {}, 500, function() {
        showNotificationsTooltip();
      });
      hideNotificationsFumetto();
      if(!$('#notifications_button').hasClass('current')) {
        showNotificationsButton();
      }
    } else {
      $('#tooltip_content, #expanded_notification').hide('fade', {}, 500, function() {
        hideNotificationsTooltip();
      });
      if($('#tooltip_arancione').data('number') > 0) {
        showNotificationsFumetto();
      } else {
        hideNotificationsButton();
      }
    }
  });
  $('body').on('click', '._single_notification a', function() {
    var closest_li = $(this).closest('li');
    var my_own_id = closest_li.attr('id')
    var my_content = $('#' + my_own_id + ' ._expanded_notification').html();
    var my_expanded = $('#expanded_notification');
    if(my_expanded.css('display') == 'none') {
      my_expanded.html(my_content);
      my_expanded.data('contentid', my_own_id);
      my_expanded.show('fade', {}, 500, function() {
        my_expanded.show();
        if(!$(this).hasClass('current')) {
          $.ajax({
            type: 'post',
            url: 'notifications/' + closest_li.data('param') + '/seen'
          });
        }
      });
    } else {
      if(my_expanded.data('contentid') != my_own_id) {
        my_expanded.html(my_content);
        my_expanded.data('contentid', my_own_id);
        if(!$(this).hasClass('current')) {
          $.ajax({
            type: 'post',
            url: 'notifications/' + closest_li.data('param') + '/seen'
          });
        }
      } else {
        my_expanded.hide('fade', {}, 500, function() {
          hideExpandedNotification();
        });
      }
    }
  });
}

function initializeHelp() {
  $('#help').click(function() {
    if($('#tooltip_help').css('display') == 'none') {
      hideNotificationsTooltip();
      hideNotificationsButton();
      hideNotificationsFumetto();
      $('#tooltip_help').show('fade', {}, 500, function() {
        showHelpTooltip();
      });
      showHelpButton();
    } else {
      $('#tooltip_help').hide('fade', {}, 500, function() {
        hideHelpTooltip();
      });
      hideHelpButton();
      if($('#tooltip_arancione').data('number') > 0) {
        showNotificationsButton();
        showNotificationsFumetto();
      }
    }
  });
}

function hideExpandedNotification() {
  $('#expanded_notification').html('');
  $('#expanded_notification').hide();
}

function hideNotificationsTooltip() {
  $('#tooltip_content').hide();
  hideExpandedNotification();
}

function showNotificationsTooltip() {
  $('#tooltip_content').show();
}

function hideHelpTooltip() {
  $('#tooltip_help').hide();
}

function showHelpTooltip() {
  $('#tooltip_help').show();
}

function hideNotificationsButton() {
  $('#notifications_button').removeClass('current');
}

function showNotificationsButton() {
  $('#notifications_button').addClass('current');
}

function hideNotificationsFumetto() {
  $('#tooltip_arancione').hide();
}

function showNotificationsFumetto() {
  $('#tooltip_arancione').show();
}

function hideHelpButton() {
  $('#help').removeClass('current');
}

function showHelpButton() {
  $('#help').addClass('current');
}
