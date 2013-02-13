function checkDifferencesBetweenTextAndHiddenFieldEmailsSendLinkLesson() {
  var to_emails = $('#virtual_classroom_send_link_email_addresses').val();
  var hidden_input = $('#virtual_classroom_send_link_hidden_mailing_lists').val();
  var options = $('#select_mailing_list option');
  for(var i = 1; i < options.length; i++) {
    var caption = '[' + $.trim($(options[i]).html()) + ']';
    var value = '[' + $.trim($(options[i]).val()) + ']';
    if(to_emails.indexOf(caption) == -1) {
      hidden_input = hidden_input.replace(value, '[]');
    }
  }
  $('#virtual_classroom_send_link_hidden_mailing_lists').val(hidden_input);
}

function initializeNotAvailableLessonsToLoadQuick() {
  $('._virtual_classroom_quick_loaded_lesson').each(function() {
    if(!$(this).data('available')) {
      $('#' + this.id + ' ._lesson_thumb').addClass('current');
    }
  });
}

function initializeScrollPaneQuickLessonSelector() {
  $('#virtual_classroom_quick_select_container.scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
    var page = $('#virtual_classroom_quick_select_container').data('page');
    var tot_pages = $('#virtual_classroom_quick_select_container').data('tot-pages');
    if(isAtBottom && (page < tot_pages)) {
      $.get('/virtual_classroom/select_lessons_new_block?page=' + (page + 1));
    }
  });
}

function initializeVirtualClassroom() {
  $('._virtual_classroom_lesson').each(function() {
    if($(this).data('in-playlist')) {
      $('#' + this.id + ' ._lesson_thumb').addClass('current');
    } else {
      initializeDraggableVirtualClassroomLesson(this.id);
    }
  });
  initializePlaylist();
}

function initializeDraggableVirtualClassroomLesson(id) {
  var lesson_cover = $('#' + id + ' ._lesson_thumb');
  var object = $('#' + id);
  if(object.hasClass('ui-draggable')) {
    object.draggable('enable');
  } else {
    object.draggable({
      revert: true,
      handle: '._lesson_thumb',
      cursor: 'move',
      helper: function() {
        var current_z_index = getMaximumZIndex('_virtual_classroom_lesson') + 1;
        var div_to_return = $('#' + this.id + ' ._lesson_thumb')[0].outerHTML;
        div_to_return = '<div ' + 'style="' + current_z_index + ';outline:1px solid white" ' + div_to_return.substr(5,div_to_return.length);
        return div_to_return;
      },
      start: function() {
        lesson_cover.addClass('current');
      },
      stop: function(event, ui) {
        if(!ui.helper.hasClass('_lesson_dropped')) {
          lesson_cover.removeClass('current');
        }
      }
    });
  }
  if(lesson_cover.hasClass('current')) {
    lesson_cover.removeClass('current');
  }
  if(object.data('in-playlist')) {
    object.data('in-playlist', false);
  }
}

function initializePlaylist() {
  $('#lessons_list_in_playlist').jScrollPane({
    autoReinitialise: true
  });
  $('#virtual_classroom_playlist').droppable({
    accept: '._virtual_classroom_lesson',
    drop: function(event, ui) {
      ui.helper.hide();
      ui.helper.addClass('_lesson_dropped');
      $.ajax({
        type: 'post',
        url: '/virtual_classroom/' + ui.draggable.data('lesson-id') + '/add_lesson_to_playlist'
      });
    },
    hoverClass: 'current'
  });
  $('#virtual_classroom_playlist .jspPane').sortable({
    scroll: true,
    handle: '._lesson_in_playlist',
    axis: 'y',
    cursor: 'move',
    cancel: '._remove_lesson_from_playlist',
    helper: function(event, ui) {
      var current_z_index = getMaximumZIndex('_lesson_in_playlist') + 1;
      var div_to_return = $($('#' + ui.attr('id'))[0].outerHTML);
      div_to_return.addClass('current');
      div_to_return = div_to_return[0].outerHTML;
      var my_index = div_to_return.indexOf('<div class="_remove_lesson_from_playlist');
      var second_half_string = div_to_return.substring(my_index, div_to_return.length);
      var my_second_index = my_index + second_half_string.indexOf('</div>') + 6;
      return div_to_return.substring(0, (my_index - 1)) + div_to_return.substring((my_second_index + 1), div_to_return.length);
    },
    stop: function(event, ui) {
      var previous = ui.item.prev();
      var new_position = 0;
      var old_position = ui.item.data('position');
      if(previous.length == 0) {
        new_position = 1;
      } else {
        var previous_item_position = previous.data('position');
        if(old_position > previous_item_position) {
          new_position = previous_item_position + 1;
        } else {
          new_position = previous_item_position;
        }
      }
      if(old_position != new_position) {
        $.ajax({
          type: 'post',
          url: '/virtual_classroom/' + ui.item.data('lesson-id') + '/playlist/' + new_position + '/change_position'
        });
      }
    }
  });
}

function getMaximumZIndex(a_class) {
  var index_highest = 0;
  $('.' + a_class).each(function() {
    var index_current = parseInt($(this).css("zIndex"), 10);
    if(index_current > index_highest) {
      index_highest = index_current;
    }
  });
  return index_highest;
}
