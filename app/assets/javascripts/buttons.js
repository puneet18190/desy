function addDeleteItemToCurrentUrl(current_url, delete_item) {
  var point_start_params = current_url.indexOf('?');
  var resp = current_url;
  if(point_start_params == -1) {
    resp = resp + '?delete_item=' + delete_item;
  } else {
    resp = resp + '&delete_item=' + delete_item;
  }
  return resp;
}

function addLesson(lesson_id, destination, current_url, reload) {
  if(reload) {
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/add?destination=' + destination
    });
  } else {
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + lesson_id));
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/add?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
  }
}

function copyLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/copy?destination=' + destination
  });
}

function destroyLesson(lesson_id, destination, current_url) {
  var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + lesson_id));
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/destroy?destination=' + destination,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: redirect_url
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
  var captions_container = $('#popup_captions_container');
  showConfirmPopUp(captions_container.data('publish-title'), captions_container.data('publish-confirm'), captions_container.data('publish-yes'), captions_container.data('publish-no'), function() {
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/publish?destination=' + destination
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
  });
}

function removeLesson(lesson_id, destination, current_url, reload) {
  if(reload) {
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/remove?destination=' + destination
    });
  } else {
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + lesson_id));
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/remove?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
  }
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

function addMediaElement(media_element_id, destination, current_url, reload) {
  if(reload) {
    $.ajax({
      type: 'post',
      url: '/media_elements/' + media_element_id + '/add?destination=' + destination
    });
  } else {
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + media_element_id));
    $.ajax({
      type: 'post',
      url: '/media_elements/' + media_element_id + '/add?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
  }
}

function destroyMediaElement(media_element_id, destination, current_url) {
  var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + media_element_id));
  $.ajax({
    type: 'post',
    url: '/media_elements/' + media_element_id + '/destroy?destination=' + destination,
    success: function(data) {
      $.ajax({
        type: 'get',
        url: redirect_url
      });
    }
  });
}

function removeMediaElement(media_element_id, destination, current_url, reload) {
  if(reload) {
    $.ajax({
      type: 'post',
      url: '/media_elements/' + media_element_id + '/remove?destination=' + destination
    });
  } else {
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + media_element_id));
    $.ajax({
      type: 'post',
      url: '/media_elements/' + media_element_id + '/remove?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
  }
}
