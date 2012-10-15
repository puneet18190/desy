function addLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/add'
  });
}

function addMediaElement(media_element_id) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/add'
  });
}

function copyLesson(lesson_id) {
  
}

function destroyLesson(lesson_id) {
  
}

function destroyMediaElement(media_element_id) {
  
}

function likeLesson(lesson_id) {
  
}

function previewLesson(lesson_id) {
  
}

function previewMediaElement(media_element_id) {
  
}

function publishLesson(lesson_id) {
  
}

function removeLesson(lesson_id) {
  
}

function removeMediaElement(media_element_id) {
  
}

function reportLesson(lesson_id) {
  
}

function reportMediaElement(media_element_id) {
  
}

function unpublishLesson(lesson_id) {
  
}

function removeLessonFromVirtualClassroom(lesson_id) {
  
}

function addLessonToVirtualClassroom(lesson_id) {
  
}

function handleVirtualClassroom(lesson_id, in_virtual_classroom) {
  if(in_virtual_classroom) {
    removeLessonFromVirtualClassroom(lesson_id);
  } else {
    addLessonToVirtualClassroom(lesson_id);
  }
  return;
}
