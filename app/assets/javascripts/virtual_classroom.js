function initializeDraggableVirtualClassroomLesson(id) {
  $('#' + id).draggable({
    revert: true,
    helper: function() {
      var current_z_index = getMaximumZIndex('_virtual_classroom_lesson') + 1;
      var div_to_return = $('#' + this.id + ' ._cover_slide_thumb')[0].outerHTML;
      div_to_return = '<div ' + 'style="' + current_z_index + '" ' + div_to_return.substr(5,div_to_return.length);
      return div_to_return;
    },
    start: function() {
      $('#' + id + ' ._cover_slide_thumb').addClass('current');
    }
  });
}

function initializeDraggableVirtualClassroom() {
  $('._virtual_classroom_lesson').each(function() {
    initializeDraggableVirtualClassroomLesson(this.id);
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
