/**
Notification info and help assistant messages handler.
@module notifications
**/





/**
Empty and hide expanded notifications.
@method hideExpandedNotification
@for NotificationsAccessories
**/
function hideExpandedNotification() {
  $('#expanded_notification').html('');
  $('#expanded_notification').hide();
}

/**
Hide help button.
@method hideHelpButton
@for NotificationsAccessories
**/
function hideHelpButton() {
  $('#help').removeClass('current');
}

/**
Hide help tooltip.
@method hideHelpTooltip
@for NotificationsAccessories
**/
function hideHelpTooltip() {
  $('#tooltip_help').hide();
}

/**
Hide notifications button.
@method hideNotificationsButton
@for NotificationsAccessories
**/
function hideNotificationsButton() {
  $('#notifications_button').removeClass('current');
}

/**
Hide notifications balloon.
@method hideNotificationsFumetto
@for NotificationsAccessories
**/
function hideNotificationsFumetto() {
  $('#tooltip_arancione').hide();
}

/**
Hide notifications tooltip. Uses: [hideExpandedNotification](../classes/hideExpandedNotification.html#method_hideExpandedNotification)
@method hideNotificationsTooltip
@for NotificationsAccessories
**/
function hideNotificationsTooltip() {
  $('#tooltip_content').hide();
  hideExpandedNotification();
}

/**
Show help button.
@method showHelpButton
@for NotificationsAccessories
**/
function showHelpButton() {
  $('#help').addClass('current');
}

/**
Show help tooltip.
@method showHelpTooltip
@for NotificationsAccessories
**/
function showHelpTooltip() {
  $('#tooltip_help').show();
}

/**
Show notifications button.
@method showNotificationsButton
@for NotificationsAccessories
**/
function showNotificationsButton() {
  $('#notifications_button').addClass('current');
}

/**
Show notifications fumetto.
@method showNotificationsFumetto
@for NotificationsAccessories
**/
function showNotificationsFumetto() {
  $('#tooltip_arancione').show();
}

/**
Show notifications tooltip.
@method showNotificationsTooltip
@for NotificationsAccessories
**/
function showNotificationsTooltip() {
  $('#tooltip_content').show();
}





/**
bla bla bla
@method notificationsDocumentReady
@for NotificationsDocumentReady
**/
function notificationsDocumentReady() {
  notificationsDocumentReadyTooltips();
  notificationsDocumentReadyLessonModification();
}

/**
bla bla bla
@method notificationsDocumentReadyLessonModification
@for NotificationsDocumentReady
**/
function notificationsDocumentReadyLessonModification() {
  $('body').on('click', '#lesson-notification ._no', function(e) {
    e.preventDefault();
    closePopUp('lesson-notification');
    var lesson_id = $('#lesson-notification').data('lesson-id');
    $('#' + lesson_id).removeClass('_lesson_change_not_notified');
    $('#' + lesson_id + ' .unpublish').attr('title', $('#popup_captions_container').data('title-unpublish'));
    var id = lesson_id.split('_');
    id = id[id.length - 1];
    $.ajax({
      type: 'post',
      url: '/lessons/' + id + '/dont_notify_modification',
      beforeSend: unbindLoader()
    }).always(bindLoader);
  });
  $('body').on('focus', '#lesson-notification #lesson_notify_modification_details', function() {
    if($('#lesson-notification #lesson_notify_modification_details_placeholder').val() === '') {
      $(this).val('');
      $('#lesson-notification #lesson_notify_modification_details_placeholder').val('0');
    }
  });
}

/**
bla bla bla
@method notificationsDocumentReadyTooltips
@for NotificationsDocumentReady
**/
function notificationsDocumentReadyTooltips() {
  initializeNotifications();
  initializeHelp();
  $('#tooltip_content .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var tot_number = $('#tooltip_content').data('tot-number');
    var offset = $('#tooltip_content').data('offset');
    if(isAtBottom && (offset < tot_number)) {
      $.get('/notifications/get_new_block?offset=' + offset);
    }
  });
  $('body').on('click', '._destroy_notification', function() {
    var my_id = $(this).data('param');
    var offset = $('#tooltip_content').data('offset');
    $.post('/notifications/' + my_id + '/destroy?offset=' + offset);
  });
}





/**
Checks if any help is available and initialize them. Handles help show/hide effects.
@method initializeHelp
@for NotificationsGraphics
**/
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
Checks if any notification is available and initialize unread notification counter. Handles notifications show/hide effects.
@method initializeNotifications
@for NotificationsGraphics
**/
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
        if(click_id != 'tooltip_content' && click_id != 'expanded_notification' && click_id != 'notifications_button' && $(e.target).parents('#tooltip_content').length == 0 && $(e.target).parents('#expanded_notification').length == 0) {
          $('#notifications_button').trigger('click');
        }
      }
    }
    if($('#tooltip_help').length > 0) {
      if($('#tooltip_help').is(':visible')) {
        if(click_id != 'tooltip_help' && click_id != 'help' && $(e.target).parents('#tooltip_help').length == 0) {
          $('#help').trigger('click');
        }
      }
    }
  });
}
