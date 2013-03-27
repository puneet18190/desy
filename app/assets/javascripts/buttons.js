/**
* Lessons and Elements actions triggered via buttons. 
* 
* @module Buttons
*/

/**
* Add item removed from a view to the current destination url
* 
* @method addDeleteItemToCurrentUrl
* @for addDeleteItemToCurrentUrl
* @return {String} updated url
*/
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

/**
* Add lessons from dashboard to my lessons
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
*
* @method addLesson
* @for addLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
* @param reload {Boolean}
*/
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
        if(data.ok) {
          $('#popup_captions_container').data('temporary-msg', data.msg);
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
  }
}

/**
* Create user own copy of the lesson
*
* @method copyLesson
* @for copyLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function copyLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/copy?destination=' + destination
  });
}

/**
* Destroy lessons lesson
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
*
* @method destroyLesson
* @for destroyLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
*/
function destroyLesson(lesson_id, destination, current_url) {
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('destroy-lesson-title'), captions.data('destroy-lesson-confirm'), captions.data('destroy-lesson-yes'), captions.data('destroy-lesson-no'), function() {
    $('#dialog-confirm').hide();
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + lesson_id));
    $.ajax({
      type: 'post',
      dataType: 'json',
      url: '/lessons/' + lesson_id + '/destroy?destination=' + destination,
      success: function(data) {
        if(data.ok) {
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
  });
}

/**
* Remove like from a lesson
*
* @method dislikeLesson
* @for dislikeLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function dislikeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/dislike?destination=' + destination
  });
}

/**
* Add like to a lesson
*
* @method likeLesson
* @for likeLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function likeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/like?destination=' + destination
  });
}

/**
* View lesson link
*
* @method previewLesson
* @for previewLesson
* @param lessons_id {Number} lesson id
* @param redirect_to {String} link url to come back from lesson viewer 
*/
function previewLesson(lesson_id, redirect_to) {
  var parser = UrlParser.parse(redirect_to);
  var back = '';
  if ( parser ) {
    var pathname = parser.pathname || '';
    var search = parser.search || '';
    var hash = parser.hash || '';
    var encodedBack = encodeURIComponent(pathname+search+hash);
    if ( encodedBack) {
      back = '?back=' + encodedBack;
    }
  }

  window.location.href = '/lessons/' + lesson_id + '/view' + back;
}

/**
* Make a lesson public
*
* Uses [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp)
* and [closePopUp](../classes/closePopUp.html#method_closePopUp)
*
* @method publishLesson
* @for publishLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function publishLesson(lesson_id, destination) {
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('publish-title'), captions.data('publish-confirm'), captions.data('publish-yes'), captions.data('publish-no'), function() {
    $('#dialog-confirm').hide();
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/publish?destination=' + destination
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
  });
}

/**
* Remove a lesson from yours (unlink).
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
*
* @method removeLesson
* @for removeLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
* @param reload {Boolean}
*/
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
        if(data.ok) {
          $('#popup_captions_container').data('temporary-msg', data.msg);
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
  }
}

/**
* Make a lesson private
*
* Uses [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp)
* and [closePopUp](../classes/closePopUp.html#method_closePopUp)
*
* @method unpublishLesson
* @for unpublishLesson
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function unpublishLesson(lesson_id, destination) {
  var captions = $('#popup_captions_container');
  showConfirmPopUp(captions.data('unpublish-title'), captions.data('unpublish-confirm'), captions.data('unpublish-yes'), captions.data('unpublish-no'), function() {
    $('#dialog-confirm').hide();
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/unpublish?destination=' + destination
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
  });
}

/**
* Make the lesson available in the virtual classroom
*
* @method addLessonToVirtualClassroom
* @for addLessonToVirtualClassroom
* @param lessons_id {Number} lesson id
* @param destination {String} destination view
*/
function addLessonToVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/add_lesson?destination=' + destination
  });
}

/**
* Remove lesson availability in the virtual classroom
*
* @method removeLessonFromVirtualClassroom
* @for removeLessonFromVirtualClassroom
* @param lessons_id {Number} lesson_id
* @param destination {String} destination view
*/
function removeLessonFromVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/remove_lesson?destination=' + destination
  });
}

/**
* Add media element from dashboard to my lessons
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
*
* @method addMediaElement
* @for addMediaElement
* @param media_element_id {Number} media_element id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
* @param reload {Boolean}
*/
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
        if(data.ok) {
          $('#popup_captions_container').data('temporary-msg', data.msg);
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
  }
}

/**
* Destroy Media Element
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
* and [closePopUp](../classes/closePopUp.html#method_closePopUp)
*
* @method destroyMediaElement
* @for destroyMediaElement
* @param lessons_id {Number} lesson_id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
* @param used_in_private_lessons {Boolean}
*/
function destroyMediaElement(media_element_id, destination, current_url, used_in_private_lessons) {
  var captions = $('#popup_captions_container');
  var title = captions.data('destroy-media-element-title');
  var confirm = captions.data('destroy-media-element-confirm');
  var yes = captions.data('destroy-media-element-yes');
  var no = captions.data('destroy-media-element-no');
  if(used_in_private_lessons) {
    confirm = captions.data('destroy-media-element-confirm-bis');
  }
  showConfirmPopUp(title, confirm, yes, no, function() {
    $('#dialog-confirm').hide();
    var redirect_url = addDeleteItemToCurrentUrl(current_url, (destination + '_' + media_element_id));
    $.ajax({
      type: 'post',
      dataType: 'json',
      url: '/media_elements/' + media_element_id + '/destroy?destination=' + destination,
      success: function(data) {
        if(data.ok) {
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
    closePopUp('dialog-confirm');
  }, function() {
    closePopUp('dialog-confirm');
  });
}

/**
* Remove a media element from yours (unlink).
*
* Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl)
* and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
*
* @method removeMediaElement
* @for removeMediaElement
* @param media_element_id {Number} media element id
* @param destination {String} destination view
* @param current_url {String} url where the lesson is added from
* @param reload {Boolean}
*/
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
        if(data.ok) {
          $('#popup_captions_container').data('temporary-msg', data.msg);
          $.ajax({
            type: 'get',
            url: redirect_url
          });
        } else {
          showErrorPopUp(data.msg);
        }
      }
    });
  }
}
