function addLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/add?destination=' + destination
  });
}

function copyLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/copy?destination=' + destination
  });
}

function destroyLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/destroy?destination=' + destination
  });
}

function dislikeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/dislike?destination=' + destination
  });
}

function likeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/like?destination=' + destination
  });
}

function previewLesson(lesson_id, destination) {
  
}

function publishLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/publish?destination=' + destination
  });
}

function removeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/remove?destination=' + destination
  });
}

function unpublishLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/unpublish?destination=' + destination
  });
}

function addLessonToVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/add_lesson?destination=' + destination
  });
}

function removeLessonFromVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/remove_lesson?destination=' + destination
  });
}

function addMediaElement(media_element_id, destination) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/add?destination=' + destination
  });
}

function destroyMediaElement(media_element_id, destination) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/destroy?destination=' + destination
  });
}

function previewMediaElement(media_element_id, destination) {
  var target = $('#' + destination + '_' + media_element_id + ' ._media_element_popup');
  var content = target.html();
  target.html('');
  showMediaElementInfoPopUp(content);
}

function removeMediaElement(media_element_id, destination) {
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/remove?destination=' + destination
  });
}
