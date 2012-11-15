function initializeDraggableVirtualClassroomLesson(id) {
  $('#' + id).draggable({
    revert: true,
    helper: 'clone',
    stack: 'div'//,
//    start: 
  });
}

function initializeDraggableVirtualClassroom() {
  $('._virtual_classroom_lesson').each(function() {
    initializeDraggableVirtualClassroomLesson(this.id);
  });
}
