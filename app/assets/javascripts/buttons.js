/**
Lessons and Elements actions triggered via buttons.
@module buttons
**/





/**
bla bla bla
@method mediaElementButtonsDocumentReady
@for ButtonsDocumentReady
**/
function mediaElementButtonsDocumentReady() {
  $('body').on('click', '._Video_button_add, ._Audio_button_add, ._Image_button_add', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      addMediaElement(my_param, destination, current_url, reload);
    }
  });
  $('body').on('click', '._Video_button_destroy, ._Audio_button_destroy, ._Image_button_destroy', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var current_url = $('#info_container').data('currenturl');
      var used_in_private_lessons = $(this).data('media-element-used-in-private-lessons');
      destroyMediaElement(my_param, destination, current_url, used_in_private_lessons);
    }
  });
  $('body').on('click', '._Video_button_preview, ._Audio_button_preview, ._Image_button_preview', function(e) {
    if(!$(this).parents('._media_element_item').hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      showMediaElementInfoPopUp(my_param);
    }
  });
  $('body').on('click', '._Video_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var video_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/videos/' + video_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  $('body').on('click', '._Audio_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var audio_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/audios/' + audio_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  $('body').on('click', '._Image_button_edit', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      e.preventDefault();
      var image_id = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      var parser = document.createElement('a');
      parser.href = redirect_back_to;
      window.location = '/images/' + image_id + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
      return false;
    }
  });
  $('body').on('click', '._Video_button_remove, ._Audio_button_remove, ._Image_button_remove', function(e) {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      removeMediaElement(my_param, destination, current_url, reload);
    }
  });
}

/**
bla bla bla
@method lessonButtonsDocumentReady
@for ButtonsDocumentReady
**/
function lessonButtonsDocumentReady() {
  $('body').on('click', '._Lesson_button_add', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      addLesson(my_param, destination, current_url, reload);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_copy', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      copyLesson(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_destroy', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var current_url = $('#info_container').data('currenturl');
      destroyLesson(my_param, destination, current_url);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_dislike', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      dislikeLesson(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_like', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      likeLesson(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_preview', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var redirect_back_to = $("#info_container").data('currenturl');
      previewLesson(my_param, redirect_back_to);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_publish', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      publishLesson(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_remove', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var reload = $(this).data('reload');
      var current_url = $('#info_container').data('currenturl');
      removeLesson(my_param, destination, current_url, reload);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_unpublish', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      var lesson_parent = $('#found_lesson_' + my_param + ', #compact_lesson_' + my_param + ', #expanded_lesson_' + my_param);
      if(lesson_parent.hasClass('_lesson_change_not_notified')) {
        showLessonNotificationPopUp(destination + '_' + my_param);
      } else {
        unpublishLesson(my_param, destination);
      }
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_add_virtual_classroom', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      addLessonToVirtualClassroom(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_remove_virtual_classroom', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      var destination = $(this).data('destination');
      removeLessonFromVirtualClassroom(my_param, destination);
    }
    return false;
  });
  $('body').on('click', '._Lesson_button_edit', function(e) {
    e.preventDefault();
    if(!$(this).parent().hasClass('_disabled')) {
      var my_param = $(this).data('clickparam');
      window.location = '/lessons/' + my_param + '/slides/edit';
    }
    return false;
  });
}





/**
Add item removed from a view to the current destination url
@method addDeleteItemToCurrentUrl
@for ButtonsAccessories
@return {String} updated url
**/
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
Add lessons from dashboard to my lessons. Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method addLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
@param reload {Boolean}
**/
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
Create user own copy of the lesson
@method copyLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
function copyLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/copy?destination=' + destination
  });
}

/**
Destroy lessons lesson Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method destroyLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
**/
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
Remove like from a lesson
@method dislikeLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
function dislikeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/dislike?destination=' + destination
  });
}

/**
Add like to a lesson
@method likeLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
function likeLesson(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/lessons/' + lesson_id + '/like?destination=' + destination
  });
}

/**
View lesson link
@method previewLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param redirect_to {String} link url to come back from lesson viewer 
**/
function previewLesson(lesson_id, redirect_to) {
  var parser = UrlParser.parse(redirect_to);
  var back = '';
  if(parser) {
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
Make a lesson public Uses [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp) and [closePopUp](../classes/closePopUp.html#method_closePopUp)
@method publishLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
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
Remove a lesson from yours (unlink).Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method removeLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
@param reload {Boolean}
**/
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
Make a lesson private Uses [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp) and [closePopUp](../classes/closePopUp.html#method_closePopUp)
@method unpublishLesson
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
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
Make the lesson available in the virtual classroom
@method addLessonToVirtualClassroom
@for ButtonsLesson
@param lessons_id {Number} lesson id
@param destination {String} destination view
**/
function addLessonToVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/add_lesson?destination=' + destination
  });
}

/**
Remove lesson availability in the virtual classroom
@method removeLessonFromVirtualClassroom
@for ButtonsLesson
@param lessons_id {Number} lesson_id
@param destination {String} destination view
**/
function removeLessonFromVirtualClassroom(lesson_id, destination) {
  $.ajax({
    type: 'post',
    url: '/virtual_classroom/' + lesson_id + '/remove_lesson?destination=' + destination
  });
}





/**
Add media element from dashboard to my lessons Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method addMediaElement
@for ButtonsMediaElement
@param media_element_id {Number} media_element id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
@param reload {Boolean}
**/
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
Destroy Media Element Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showConfirmPopUp](../classes/showConfirmPopUp.html#method_showConfirmPopUp) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp) and [closePopUp](../classes/closePopUp.html#method_closePopUp)
@method destroyMediaElement
@for ButtonsMediaElement
@param lessons_id {Number} lesson_id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
@param used_in_private_lessons {Boolean}
**/
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
Remove a media element from yours (unlink). Uses [addDeleteItemToCurrentUrl](../classes/addDeleteItemToCurrentUrl.html#method_addDeleteItemToCurrentUrl) and [showErrorPopUp](../classes/showErrorPopUp.html#method_showErrorPopUp)
@method removeMediaElement
@for ButtonsMediaElement
@param media_element_id {Number} media element id
@param destination {String} destination view
@param current_url {String} url where the lesson is added from
@param reload {Boolean}
**/
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
