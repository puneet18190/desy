function addLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/add'
  });
}

function copyLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/copy'
  });
}

function destroyLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/destroy'
  });
}

function dislikeLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/dislike'
  });
}

function likeLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/like'
  });
}

function previewLesson(lesson_id) {
  
}

function publishLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/publish'
  });
}

function removeLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/remove'
  });
}

function reportLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/remove'
  });
}

function unpublishLesson(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/unpublish'
  });
}

function addLessonToVirtualClassroom(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/add_lesson'
  });
}

function removeLessonFromVirtualClassroom(lesson_id) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/remove_lesson'
  });
}

function addMediaElement(media_element_id) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/add'
  });
}

function destroyMediaElement(media_element_id) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/destroy'
  });
}

function previewMediaElement(media_element_id) {
  
}

function removeMediaElement(media_element_id) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/remove'
  });
}

function reportMediaElement(media_element_id) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/report'
  });
}

function handleLikeForLesson(lesson_id, liked) {
  if(liked) {
    dislikeLesson(lesson_id);
  } else {
    likeLesson(lesson_id);
  }
  return;
}

function handleVirtualClassroom(lesson_id, in_virtual_classroom) {
  if(in_virtual_classroom) {
    removeLessonFromVirtualClassroom(lesson_id);
  } else {
    addLessonToVirtualClassroom(lesson_id);
  }
  return;
}
