/**
* Notification info and help assistant messages handler.
* 
* @module Notifications
*/

/**
* Checks if any notification is available and initialize unread notification counter.
* Handles notifications show/hide effects.
*
* Uses: [showNotificationsFumetto](../classes/showNotificationsFumetto.html#method_showNotificationsFumetto)
* and [showNotificationsButton](../classes/showNotificationsButton.html#method_showNotificationsButton)
* and [hideHelpTooltip](../classes/hideHelpTooltip.html#method_hideHelpTooltip)
* and [hideHelpButton](../classes/hideHelpButton.html#method_hideHelpButton)
* and [showNotificationsTooltip](../classes/showNotificationsTooltip.html#method_showNotificationsTooltip)
* and [hideNotificationsFumetto](../classes/hideNotificationsFumetto.html#method_hideNotificationsFumetto)
* and [hideNotificationsTooltip](../classes/hideNotificationsTooltip.html#method_hideNotificationsTooltip)
* and [hideNotificationsButton](../classes/hideNotificationsButton.html#method_hideNotificationsButton)
* and [unbindLoader](../classes/unbindLoader.html#method_unbindLoader)
* and [bindLoader](../classes/bindLoader.html#method_bindLoader)
* and [hideExpandedNotification](../classes/hideExpandedNotification.html#method_hideExpandedNotification)
*
* @method initializeNotifications
* @for initializeNotifications
*/
function initializeNotifications() {
  if($('#tooltip_arancione').data('number') > 0) {
    showNotificationsFumetto();
    showNotificationsButton();
  }
  $('body').on('click', '#notifications_button', function() {
    if(!$('#tooltip_content').is(':visible')) {
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
  $('body').on('click', '._single_notification .notification_gatto', function() {
    var closest_li = $(this).closest('li');
    var my_own_id = closest_li.attr('id')
    var my_content = $('#' + my_own_id + ' ._expanded_notification').html();
    var my_expanded = $('#expanded_notification');
    if(!my_expanded.is(':visible')) {
      my_expanded.html(my_content);
      my_expanded.data('contentid', my_own_id);
      my_expanded.show('fade', {}, 500, function() {
        my_expanded.show();
        if(!$(this).hasClass('current')) {
          $.ajax({
            beforeSend: unbindLoader(),
            type: 'post',
            url: '/notifications/' + closest_li.data('param') + '/seen'
          }).always(bindLoader);
        }
      });
    } else {
      if(my_expanded.data('contentid') != my_own_id) {
        my_expanded.html(my_content);
        my_expanded.data('contentid', my_own_id);
        if(!$(this).hasClass('current')) {
          $.ajax({
            beforeSend: unbindLoader(),
            type: 'post',
            url: '/notifications/' + closest_li.data('param') + '/seen'
          });
        }
      } else {
        my_expanded.hide('fade', {}, 500, function() {
          hideExpandedNotification();
        });
      }
    }
  });
  $(document).bind('click', function (e) {
    var click_id = $(e.target).attr('id');
    if($('#tooltip_content').length > 0){
      if($('#tooltip_content').is(':visible')) {
        if(click_id != 'tooltip_content' && click_id != 'expanded_notification' && click_id != 'notifications_button' && $(e.target).parents('#tooltip_content').length == 0 && $(e.target).parents('#expanded_notification').length == 0){
          $('#notifications_button').trigger('click');
        }
      }
    }
    if($('#tooltip_help').length > 0) {
      if($('#tooltip_help').is(':visible')) {
        if(click_id != 'tooltip_help' && click_id != 'help' && $(e.target).parents('#tooltip_help').length == 0){
          $('#help').trigger('click');
        }
      }
    }
  });
}

/**
* Checks if any help is available and initialize them.
* Handles help show/hide effects.
*
* Uses: [hideNotificationsTooltip](../classes/hideNotificationsTooltip.html#method_hideNotificationsTooltip)
* and [hideNotificationsButton](../classes/hideNotificationsButton.html#method_hideNotificationsButton)
* and [hideNotificationsFumetto](../classes/hideNotificationsFumetto.html#method_hideNotificationsFumetto)
* and [showHelpTooltip](../classes/showHelpTooltip.html#method_showHelpTooltip)
* and [showHelpButton](../classes/showHelpButton.html#method_showHelpButton)
* and [hideHelpTooltip](../classes/hideHelpTooltip.html#method_hideHelpTooltip)
* and [hideHelpButton](../classes/hideHelpButton.html#method_hideHelpButton)
* 
* @method initializeHelp
* @for initializeHelp
*
*/
function initializeHelp() {
  $('#help').click(function() {
    if(!$('#tooltip_help').is(':visible')) {
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

/**
* Empty and hide expanded notifications.
* 
* @method hideExpandedNotification
* @for hideExpandedNotification
*/
function hideExpandedNotification() {
  $('#expanded_notification').html('');
  $('#expanded_notification').hide();
}

/**
* Hide notifications tooltip.
*
* Uses: [hideExpandedNotification](../classes/hideExpandedNotification.html#method_hideExpandedNotification)
* 
* @method hideExpandedNotification
* @for hideExpandedNotification
*/
function hideNotificationsTooltip() {
  $('#tooltip_content').hide();
  hideExpandedNotification();
}

/**
* Show notifications tooltip.
* 
* @method showNotificationsTooltip
* @for showNotificationsTooltip
*/
function showNotificationsTooltip() {
  $('#tooltip_content').show();
}

/**
* Hide help tooltip.
* 
* @method hideHelpTooltip
* @for hideHelpTooltip
*/
function hideHelpTooltip() {
  $('#tooltip_help').hide();
}

/**
* Show help tooltip.
* 
* @method showHelpTooltip
* @for showHelpTooltip
*/
function showHelpTooltip() {
  $('#tooltip_help').show();
}

/**
* Hide notifications button.
* 
* @method hideNotificationsButton
* @for hideNotificationsButton
*/
function hideNotificationsButton() {
  $('#notifications_button').removeClass('current');
}

/**
* Show notifications button.
* 
* @method showNotificationsButton
* @for showNotificationsButton
*/
function showNotificationsButton() {
  $('#notifications_button').addClass('current');
}

/**
* Hide notifications balloon.
* 
* @method hideNotificationsFumetto
* @for hideNotificationsFumetto
*/
function hideNotificationsFumetto() {
  $('#tooltip_arancione').hide();
}

/**
* Show notifications balloon.
* 
* @method showNotificationsFumetto
* @for showNotificationsFumetto
*/
function showNotificationsFumetto() {
  $('#tooltip_arancione').show();
}

/**
* Hide help button.
* 
* @method hideHelpButton
* @for hideHelpButton
*/
function hideHelpButton() {
  $('#help').removeClass('current');
}

/**
* Show help button.
* 
* @method showHelpButton
* @for showHelpButton
*/
function showHelpButton() {
  $('#help').addClass('current');
}
