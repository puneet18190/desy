/**
Javascript functions used in the media element and document loader.
<br/><br/>
The class {{#crossLink "UploaderGlobal"}}{{/crossLink}} contains functions that handle uploading processes in regular sections, such as dashboard, my elements, my documents, and also Lesson Editor ({{#crossLinkModule "lesson-editor"}}{{/crossLinkModule}}, see the initializer {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyUploaderInGallery:method"}}{{/crossLink}}).
@module uploader
**/





/**
Disables the loading form while uploading is working.
@method disableUploadForm
@for UploaderGlobal
@param container {Object} JQuery object representing the container
@param window_caption {String} message that is shown to the user if he tries to reload the window while the uploader is working
**/
function disableUploadForm(container, window_caption) {
  container.find('.part3 .submit').addClass('disabled');
  container.find('.part3 .close').addClass('disabled');
  container.find('.part1 .attachment .file').on('click', function(e) {
    e.preventDefault();
  });
  $window.on('beforeunload', function() {
    return window_caption;
  });
}

/**
Enables the loading form when uploading ended.
@method enableUploadForm
@for UploaderGlobal
@param container {Object} JQuery object representing the container
**/
function enableUploadForm(container) {
  $window.unbind('beforeunload');
  container.find('.part3 .close').removeClass('disabled');
  container.find('.part3 .submit').removeClass('disabled');
  container.find('.part1 .attachment .file').unbind('click');
}

/**
Handles the recursion of uploading animation, in a linear way, until a fixed time which is defined as 500 seconds. It is called by {{#crossLink "UploaderGlobal/recursionUploadingBar:method"}}{{/crossLink}}.
@method linearRecursionUploadingBar
@for UploaderGlobal
@param container {Object} JQuery object for the specific uploader (audio, video, image or document)
@param time {Number} current time in the recursion
@param k {Number} linear coefficient of recursion
@param start {Number} starting point of recursion
@param callback {Function} function to be fired after the animation is over
**/
function linearRecursionUploadingBar(container, time, k, start, callback) {
  if(time <= 500) {
    showPercentUploadingBar(container, (k * time + start));
    setTimeout(function() {
      linearRecursionUploadingBar(container, time + 5, k, start, callback);
    }, 5);
  } else {
    setTimeout(callback, 500);
  }
}

/**
Handles the recursion of uploading animation.
@method recursionUploadingBar
@for UploaderGlobal
@param container {Object} JQuery object for the specific uploader (audio, video, image or document)
@param time {Number} current time in the recursion
**/
function recursionUploadingBar(container, time) {
  if(container.data('loader-can-move')) {
    if(time < 1500) {
      showPercentUploadingBar(container, 5 / 150 * time);
    } else {
      showPercentUploadingBar(container, ((100 * time + 1500) / (time + 1530)));
    }
    setTimeout(function() {
      recursionUploadingBar(container, time + 5);
    }, 5);
  } else {
    container.data('loader-can-move', true);
    if(!container.data('loader-with-errors')) {
      container.data('loader-position-stop', (100 * time + 1500) / (time + 1530));
    } else {
      container.data('loader-with-errors', false);
      showPercentUploadingBar(container, 0);
    }
  }
}

/**
Shows a percentage of the circular loading bar.
@method showPercentUploadingBar
@for UploaderGlobal
@param container {Object} JQuery object for the specific uploader (audio, video, image or document)
@param percent {Float} percentage of loading shown
**/
function showPercentUploadingBar(container, percent) {
  container.find('.loading-square').hide();
  var width = container.data('bar-width');
  var height = container.data('bar-height');
  var padding = container.data('bar-padding');
  var pixels = percent * (width * 2 + height * 2 + 4) / 100;
  if(pixels > (width / 2)) {
    container.find('.loading-square-1').css('width', ((width / 2) + 'px')).css('left', ('-' + padding + 'px')).show();
    pixels -= (width / 2);
    if(pixels > height) {
      container.find('.loading-square-2').css('height', (height + 'px')).css('top', ('-' + padding + 'px')).show();
      pixels -= height;
      if(pixels > width) {
        container.find('.loading-square-3').css('width', (width + 'px')).show();
        pixels -= width;
        if(pixels > height) {
          container.find('.loading-square-4').css('height', (height + 'px')).show();
          pixels -= height;
          container.find('.loading-square-5').css('width', (pixels + 'px')).css('left', ((width - padding - pixels) + 'px')).show();
        } else {
          container.find('.loading-square-4').css('height', (pixels + 'px')).show();
        }
      } else {
        container.find('.loading-square-3').css('width', (pixels + 'px')).show();
      }
    } else {
      container.find('.loading-square-2').css('height', (pixels + 'px')).css('top', ((height - padding - pixels) + 'px')).show();
    }
  } else {
    container.find('.loading-square-1').css('width', (pixels + 'px')).css('left', (((width / 2) - padding - pixels) + 'px')).show();
  }
}

/**
Handles correct uploading process (correct in the sense that the file is not too large and could correctly be received by the web server).
@method uploadDone
@for UploaderGlobal
@param selector {String} HTML selector representing the container
@param errors {Array} an array of strings to be shown on the bottom of the loading popup
@param callback {Function} success callback
**/
function uploadDone(selector, errors, callback) {
  var container = $(selector);
  enableUploadForm(container);
  if(errors != undefined) {
    uploaderErrors(container, errors);
  } else {
    $(selector).data('loader-can-move', false);
    setTimeout(function() {
      var position_now = container.data('loader-position-stop');
      var coefficient = (100 - position_now) / 500;
      linearRecursionUploadingBar(container, 0, coefficient, position_now, function() {
        container.data('loader-position-stop', 0);
        callback();
      });
    }, 100);
  }
}

/**
Handles the errors of loading files.
@method uploaderErrors
@for UploaderGlobal
@param container {Object} JQuery object for the specific uploader (audio, video, image or document)
@param errors {Hash} a hash of the kind 'field': 'error'. It can't be undefined!
**/
function uploaderErrors(container, errors) {
  container.find('.form_error').removeClass('form_error');
  container.find('.errors_layer').hide();
  $.each(errors, function(key, value) {
    if(key == 'full') {
      container.find('form').hide();
      container.find('.full_folder .msge').text(value);
      container.find('.full_folder').show();
    } else {
      container.find('.errors_layer.' + key).text(value).show();
      if(key == 'tags') {
        container.find('._tags_container').addClass('form_error');
      } else {
        container.find('.' + key).addClass('form_error');
      }
    }
  });
  container.data('loader-can-move', false).data('loader-with-errors', true);
}

/**
Handles 413 status error, file too large.
@method uploadFileTooLarge
@for UploaderGlobal
@param container {Object} JQuery object for the specific uploader (audio, video, image or document)
**/
function uploadFileTooLarge(container) {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $window.unbind('beforeunload');
    unbindLoader();
    $.ajax({
      type: 'get',
      url: container.data('fake-url'),
      data: container.find('form').serialize()
    }).always(bindLoader);
  }
}





/**
Initializer for the loading form.
@method documentLoaderDocumentReady
@for UploaderDocumentReady
**/
function documentLoaderDocumentReady() {
  $body.on('click', '._load_document', function() {
    showLoadDocumentPopUp();
  });
  $body.on('change', 'input#new_document_input', function() {
    var file_name = $(this).val().replace("C:\\fakepath\\", '');
    if(file_name.replace(/^[\s\t]+/, '') != '') {
      if(file_name.length > 20) {
        file_name = file_name.substring(0, 20) + '...';
      }
      $('#document_attachment_show').text(file_name).removeClass('form_error');
    } else {
      $('#document_attachment_show').text($('#load-document').data('placeholder-attachment')).removeClass('form_error');
    }
  });
  $body.on('click', '#load-document .part3 .close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-document');
    }
  });
  $body.on('click', '#load-document .part3 .submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      var container = $('#load-document');
      disableUploadForm(container, $captions.data('dont-leave-page-upload-document'));
      recursionUploadingBar(container, 0);
      setTimeout(function() {
        container.find('form').submit();
      }, 1500);
    } else {
      e.preventDefault();
    }
  });
  $body.on('focus', '#load-document .docload_title', function() {
    if($('#load-document .docload_title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document .docload_title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-document .docload_description', function() {
    if($('#load-document .docload_description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document .docload_description_placeholder').attr('value', '0');
    }
  });
  $body.on('submit', '#new_document', function() {
    document.getElementById('new_document').target = 'upload_target';
    document.getElementById('upload_target').onload = function() {
      uploadFileTooLarge($('#load-document'));
    }
  });
  $body.on('keydown', '.docload_title, .docload_description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('click', '#load-document .errors_layer', function() {
    var myself = $(this);
    if(!myself.hasClass('media')) {
      myself.hide();
      $('#load-document ' + myself.data('selector')).focus();
    }
  });
  $body.on('click', '#load-document .attachment label', function() {
    $('#load-document .errors_layer.media').hide();
  });
  $body.on('click', '#load-document .full_folder .back_to_gallery', function() {
    var container = $('#load-document');
    container.find('.part1 .attachment .media').val(container.data('placeholder-attachment'));
    container.find('.form_error').removeClass('form_error');
    container.find('.errors_layer').hide();
    container.find('.part1 .attachment .file').val('');
    container.find('form').show();
    container.find('.full_folder').hide();
  });
}

/**
Initializer for the loading form.
@method mediaElementLoaderDocumentReady
@for UploaderDocumentReady
**/
function mediaElementLoaderDocumentReady() {
  $body.on('click', '._load_media_element', function(e) {
    e.preventDefault();
    showLoadMediaElementPopUp();
  });
  $body.on('change', 'input#new_media_element_input', function() {
    var file_name = $(this).val().replace("C:\\fakepath\\", '');
    if(file_name.replace(/^[\s\t]+/, '') != '') {
      if(file_name.length > 20) {
        file_name = file_name.substring(0, 20) + '...';
      }
      $('#media_element_media_show').val(file_name).removeClass('form_error');
    } else {
      $('#media_element_media_show').val($('#load-media-element').data('placeholder-media')).removeClass('form_error');
    }
  });
  $body.on('click', '#load-media-element .part3 .close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-media-element');
    }
  });
  $body.on('click', '#load-media-element .part3 .submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      var container = $('#load-media-element');
      disableUploadForm(container, $captions.data('dont-leave-page-upload-media-element'));
      recursionUploadingBar(container, 0);
      setTimeout(function() {
        container.find('form').submit();
      }, 1500);
    } else {
      e.preventDefault();
    }
  });
  $body.on('focus', '#load-media-element .part2 .title', function() {
    if($('#load-media-element .part2 .title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element .part2 .title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-media-element .part2 .description', function() {
    if($('#load-media-element .part2 .description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element .part2 .description_placeholder').attr('value', '0');
    }
  });
  $body.on('submit', '#new_media_element', function() {
    document.getElementById('new_media_element').target = 'upload_target';
    document.getElementById('upload_target').onload = function() {
      uploadFileTooLarge($('#load-media-element'));
    }
  });
  $body.on('keydown', '.part2 .title, .part2 .description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('keydown', '.part2 ._tags_container .tags', function() {
    $(this).parent().removeClass('form_error');
  });
  $body.on('click', '#load-media-element .errors_layer', function() {
    var myself = $(this);
    if(!myself.hasClass('media')) {
      myself.hide();
      $('#load-media-element ' + myself.data('selector')).focus();
    }
  });
  $body.on('click', '#load-media-element .attachment label', function() {
    $('#load-media-element .errors_layer.media').hide();
  });
  $body.on('click', '#load-media-element .full_folder .back_to_gallery', function() {
    var container = $('#load-media-element');
    container.find('.part1 .attachment .media').val(container.data('placeholder-attachment'));
    container.find('.form_error').removeClass('form_error');
    container.find('.errors_layer').hide();
    container.find('.part1 .attachment .file').val('');
    container.find('form').show();
    container.find('.full_folder').hide();
  });
}
