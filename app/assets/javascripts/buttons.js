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
      dataType: 'json',
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
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('destroy-lesson-title'), captions.data('destroy-lesson-confirm'), captions.data('destroy-lesson-yes'), captions.data('destroy-lesson-no'), function() {
    $('#dialog-confirm').css('display', 'none');
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + lesson_id));
    $.ajax({
      type: 'post',
      dataType: 'json',
      url: '/lessons/' + lesson_id + '/destroy?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
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
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('publish-title'), captions.data('publish-confirm'), captions.data('publish-yes'), captions.data('publish-no'), function() {
    $('#dialog-confirm').css('display', 'none');
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
      dataType: 'json',
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
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('unpublish-title'), captions.data('unpublish-confirm'), captions.data('unpublish-yes'), captions.data('unpublish-no'), function() {
    $('#dialog-confirm').css('display', 'none');
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/unpublish?destination=' + destination
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
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
      dataType: 'json',
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
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('destroy-media-element-title'), captions.data('destroy-media-element-confirm'), captions.data('destroy-media-element-yes'), captions.data('destroy-media-element-no'), function() {
    $('#dialog-confirm').css('display', 'none');
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + media_element_id));
    $.ajax({
      type: 'post',
      dataType: 'json',
      url: '/media_elements/' + media_element_id + '/destroy?destination=' + destination,
      success: function(data) {
        $.ajax({
          type: 'get',
          url: redirect_url
        });
      }
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
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
      dataType: 'json',
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
