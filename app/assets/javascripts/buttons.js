function addLesson(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/lessons/' + lesson_id + '/add?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function copyLesson(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/lessons/' + lesson_id + '/copy?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function destroyLesson(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/lessons/' + lesson_id + '/destroy?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
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
  // TODO forse andrà rimossa e messa direttamente in dialogs.js
}

function publishLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/publish?destination=' + destination
  });
}

function removeLesson(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/lessons/' + lesson_id + '/remove?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function unpublishLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/unpublish?destination=' + destination
  });
}

function addLessonToVirtualClassroom(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/virtual_classroom/' + lesson_id + '/add_lesson?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function removeLessonFromVirtualClassroom(lesson_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/virtual_classroom/' + lesson_id + '/remove_lesson?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function addMediaElement(media_element_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/media_elements/' + media_element_id + '/add?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function destroyMediaElement(media_element_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/media_elements/' + media_element_id + '/destroy?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}

function removeMediaElement(media_element_id, destination, container, html_params) {
  $.ajax({
    type: 'post',
    dataType: 'json',
    url: '/media_elements/' + media_element_id + '/remove?destination=' + destination + '&container=' + container + '&html_params=' + html_params,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: data.redirect_url
      });
    }
  });
}
