function initializeDraggableVirtualClassroomLesson(id) {
  if($('#' + id).hasClass('ui-draggable')) {
    $('#' + id).draggable('enable');
  } else {
    $('#' + id).draggable({
      revert: true,
      handle: '._cover_slide_thumb',
      cursor: 'move',
      helper: function() {
        var current_z_index = getMaximumZIndex('_virtual_classroom_lesson') + 1;
        var div_to_return = $('#' + this.id + ' ._cover_slide_thumb')[0].outerHTML;
        div_to_return = '<div ' + 'style="' + current_z_index + ';outline:1px solid white" ' + div_to_return.substr(5,div_to_return.length);
        return div_to_return;
      },
      start: function() {
        $('#' + id + ' ._cover_slide_thumb').addClass('current');
      },
      stop: function(event, ui) {
        if(!ui.helper.hasClass('_lesson_dropped')) {
          $('#' + id + ' ._cover_slide_thumb').removeClass('current');
        }
      }
    });
  }
}

function reloadPlaylist() {
  initializeDroppablePlaylist();
  $('#virtual_classroom_playlist .scroll-pane').jScrollPane();
  initializeScollReloadPlaylist();
}

function initializeDroppablePlaylist() {
  $('#virtual_classroom_playlist').droppable({
    drop: function(event, ui) {
      ui.helper.css('display', 'none');
      ui.helper.addClass('_lesson_dropped');
      var offset = $(this).data('offset');
      $.ajax({
        type: 'post',
        url: '/virtual_classroom/' + ui.draggable.data('lesson-id') + '/add_lesson_to_playlist?offset=' + offset
      });
    },
    hoverClass: 'current'
  });
}

function initializeScollReloadPlaylist() {
  //$('#tooltip_content .scroll-pane').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {
  //  if(isAtBottom && (parseInt($('#tooltip_content').data('offset')) < parseInt($('#tooltip_content').data('totnumber')))) {
  //    var offset = $('#tooltip_content').data('offset');
  //    $.get('/notifications/get_new_block?offset=' + offset);
  //  }
  //});
}

function initializeDraggableVirtualClassroom() {
  $('._virtual_classroom_lesson').each(function() {
    if($(this).data('in-playlist')) {
      $('#' + this.id + ' ._cover_slide_thumb').addClass('current');
    } else {
      initializeDraggableVirtualClassroomLesson(this.id);
    }
  });
  initializeDroppablePlaylist();
  initializeScollReloadPlaylist();
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
