function initializeNotifications() {
  if(parseInt($('#tooltip_arancione').data('number')) > 0) {
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
      $('#tooltip_content').hide('fade', {}, 500, function() {
        hideNotificationsTooltip();
      });
      if(parseInt($('#tooltip_arancione').data('number')) > 0) {
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
        my_expanded.css('display', 'block');
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
  $('#expanded_notification').css('display', 'none');
}

function hideNotificationsTooltip() {
  $('#tooltip_content').css('display', 'none');
  hideExpandedNotification();
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
