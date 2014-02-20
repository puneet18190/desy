/**
Javascript functions used in the media element and document loader.
<br/><br/>
The class {{#crossLink "UploaderDashboard"}}{{/crossLink}} contains functions that handle uploading processes in regular sections, such as dashboard, my elements, my documents, whereas the class {{#crossLink "UploaderLessonEditor"}}{{/crossLink}} contains functions to upload files in the {{#crossLinkModule "lesson-editor"}}{{/crossLinkModule}}.
@module uploader
**/





/**
Recursive animation of the loading bar, according to the function h * x / (x + 1). Time is divided by 400 to slow down the animation.
@method uploadAnimationRecursion
@for UploaderDashboard
@param item {Object} the selected loading bar
@param time {Number} the current time
@param increment {Number} the increment of time
@param max_width {Number} the total width in pixels of loading bar
**/
function uploadAnimationRecursion(item, time, increment, max_width) {
  if(item.data('can-move')) {
    var reduced_time = time / 400;
    var current_width = max_width * reduced_time / (reduced_time + 1);
    item.css('width', (current_width + 'px'));
    setTimeout(function() {
      uploadAnimationRecursion(item, (time + increment), increment, max_width);
    }, increment);
  } else {
    item.data('can-move', true);
  }
}

/**
Handles correct uploading process (correct in the sense that the file is not too large and could correctly be received by the web server).
@method uploadDone
@for UploaderDashboard
@param selector {String} either 'document' or 'media-element'
@param errors {Array} an array of strings to be shown on the bottom of the loading popup
@param fields {Array} an array of fields that must be bordered with red because they correspond to an error
**/
function uploadDone(selector, errors, fields) {
  $window.unbind('beforeunload');
  if(errors != undefined) {
    top.uploaderErrors(selector, errors, fields);
  } else {
    $('#load-' + selector + ' .barraLoading .loading-internal').data('can-move', false).css('width', '760px');
    setTimeout(function() {
      window.location = '/' + selector.replace('-', '_') + 's';
    }, 500);
  }
}

/**
Handles the errors of loading popup.
@method uploaderErrors
@for UploaderDashboard
@param selector {String} either 'document' or 'media-element'
@param errors {Array} an array of strings to be shown on the bottom of the loading popup
@param fields {Array} an array of fields that must be bordered with red because they correspond to an error
**/
function uploaderErrors(selector, errors, fields) {
  var obj_name = selector.replace('-', '_');
  var item = $('#load-' + selector);
  var input_selector = '.' + selector.substr(0, 3) + 'load_';
  var loading_errors = item.find('.barraLoading .loading-errors');
  item.find('.form_error').removeClass('form_error');
  item.find('.barraLoading .loading-internal').data('can-move', false).css('width', '0px').hide();
  loading_errors.show();
  item.find('#new_' + obj_name + '_submit').removeClass('disabled');
  item.find('#new_' + obj_name + '_input').unbind('click');
  item.find('._close').removeClass('disabled');
  errors_appended = '';
  for(var i = 0; i < errors.length; i++) {
    if(i == errors.length - 1) {
      errors_appended += (errors[i] + '');
    } else {
      errors_appended += (errors[i] + '; ');
    }
  }
  loading_errors.html('<span class="lower">' + errors_appended + '</span>');
  for(var i = 0; i < fields.length; i++) {
    if(fields[i] == 'media') {
      item.find('#media_element_media_show').addClass('form_error');
    } else if(fields[i] == 'tags') {
      item.find('._tags_container').addClass('form_error');
    } else if(fields[i] == 'attachment') {
      item.find('#document_attachment_show').addClass('form_error');
    } else {
      item.find(input_selector + fields[i]).addClass('form_error');
    }
  }
}

/**
Handles 413 status error, file too large.
@method uploadFileTooLarge
@for UploaderDashboard
@param selector {String} either 'document' or 'media-element'
**/
function uploadFileTooLarge(selector) {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $window.unbind('beforeunload');
    unbindLoader();
    $.ajax({
      type: 'get',
      url: '/' + selector + 's/create/fake',
      data: $('#new_' + selector).serialize()
    }).always(bindLoader);
  }
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
      $('#media_element_media_show').text(file_name).removeClass('form_error');
    } else {
      $('#media_element_media_show').text($('#load-media-element').data('placeholder-media')).removeClass('form_error');
    }
  });
  $body.on('click', '#load-media-element ._close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-media-element');
    }
  });
  $body.on('click', '#new_media_element_submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $('#load-media-element #new_media_element_input').on('click', function(e) {
        e.preventDefault();
      });
      $('#load-media-element ._close').addClass('disabled');
      $('#load-media-element .barraLoading .loading-errors').html('').hide();
      $('#load-media-element .barraLoading .loading-internal').show();
      $window.on('beforeunload', function() {
        return $captions.data('dont-leave-page-upload-media-element');
      });
      uploadAnimationRecursion($('#load-media-element .barraLoading .loading-internal'), 0, 5, 760);
      $(this).closest('#new_media_element').submit();
    } else {
      e.preventDefault();
    }
  });
  $body.on('focus', '#load-media-element .medload_title', function() {
    if($('#load-media-element .medload_title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element .medload_title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-media-element .medload_description', function() {
    if($('#load-media-element .medload_description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element .medload_description_placeholder').attr('value', '0');
    }
  });
  $body.on('submit', '#new_media_element', function() {
    document.getElementById('new_media_element').target = 'upload_target';
    document.getElementById('upload_target').onload = function() {
      uploadFileTooLarge('media_element');
    }
  });
  $body.on('keydown', '.medload_title, .medload_description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('keydown', '.medload_tags', function() {
    $(this).parent().removeClass('form_error');
  });
}

/**
Initializer for the loading form.
@method documentsDocumentReadyUploader
@for UploaderDocumentReady
**/
function documentsDocumentReadyUploader() {
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
  $body.on('click', '#load-document ._close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-document');
    }
  });
  $body.on('click', '#new_document_submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $('#load-document #new_document_input').on('click', function(e) {
        e.preventDefault();
      });
      $('#load-document ._close').addClass('disabled');
      $('#load-document .barraLoading .loading-errors').html('').hide();
      $('#load-document .barraLoading .loading-internal').show();
      $window.on('beforeunload', function() {
        return $captions.data('dont-leave-page-upload-document');
      });
      uploadAnimationRecursion($('#load-document .barraLoading .loading-internal'), 0, 5, 760);
      $(this).closest('#new_document').submit();
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
      uploadFileTooLarge('document');
    }
  });
  $body.on('keydown', '.docload_title, .docload_description', function() {
    $(this).removeClass('form_error');
  });
}





/**
This function replaces {{#crossLink "TagsAccessories/disableTagsInputTooHigh:method"}}{{/crossLink}} in case the tags are used into the lesson editor uploader.
@method disableTagsInputTooHighForLessonEditorLoader
@for UploaderLessonEditor
@param scope_id {String} HTML id for the specific kind of element
**/
function disableTagsInputTooHighForLessonEditorLoader(scope_id) {
  var container = $('#' + scope_id + ' .part2 ._tags_container');
  var line = 1;
  var curr_width = 12;
  container.find('span').each(function() {
    curr_width += $(this).outerWidth(true);
    if(curr_width > 377.5) {
      curr_width = $(this).outerWidth(true) + 12;
      line += 1;
    }
  });
  if(line > 5) {
    container.find('.tags').hide();
  }
}

/**
Handles the recursion of uploading animation, in a linear way, until a fixed time which is defined as 500 seconds. It is called by {{#crossLink "UploaderLessonEditor/recursionLessonEditorUploadinBar:method"}}{{/crossLink}}.
@method linearRecursionLessonEditorUploadinBar
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
@param time {Number} current time in the recursion
@param k {Number} linear coefficient of recursion
@param start {Number} starting point of recursion
**/
function linearRecursionLessonEditorUploadinBar(selector, time, k, start) {
  if(time <= 500) {
    showPercentLessonEditorUploadinBar(selector, (k * time + start));
    setTimeout(function() {
      linearRecursionLessonEditorUploadinBar(selector, time + 5, k, start)
    }, 5);
  }
}

/**
Handles the recursion of uploading animation.
@method recursionLessonEditorUploadinBar
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
@param time {Number} current time in the recursion
**/
function recursionLessonEditorUploadinBar(selector, time) {
  var container = $(selector);
  if(container.data('loader-can-move')) {
    if(time < 1500) {
      showPercentLessonEditorUploadinBar(selector, 5 / 150 * time);
    } else {
      showPercentLessonEditorUploadinBar(selector, ((100 * time + 1500) / (time + 1530)));
    }
    setTimeout(function() {
      recursionLessonEditorUploadinBar(selector, time + 5);
    }, 5);
  } else {
    container.data('loader-can-move', true);
    if(!container.data('loader-with-errors')) {
      var position_now = (100 * time + 1500) / (time + 1530);
      var coefficient = (100 - position_now) / 500;
      linearRecursionLessonEditorUploadinBar(selector, 0, coefficient, position_now);
    } else {
      container.data('loader-with-errors', false);
      showPercentLessonEditorUploadinBar(selector, 0);
    }
  }
}

/**
Shows a percentage of the circular loading bar.
@method showPercentLessonEditorUploadinBar
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
@param percent {Float} percentage of loading shown
**/
function showPercentLessonEditorUploadinBar(selector, percent) {
  $(selector + ' .loading-square').hide();
  var pixels = percent * 2984 / 100;
  if(pixels > 450) {
    $(selector + ' .loading-square-1').css('width', '450px').css('left', '-50px').show();
    pixels -= 450;
    if(pixels > 590) {
      $(selector + ' .loading-square-2').css('height', '590px').css('top', '-50px').show();
      pixels -= 590;
      if(pixels > 900) {
        $(selector + ' .loading-square-3').css('width', '900px').show();
        pixels -= 900;
        if(pixels > 590) {
          $(selector + ' .loading-square-4').css('height', '590px').show();
          pixels -= 590;
          $(selector + ' .loading-square-5').css('width', (pixels + 'px')).css('left', ((850 - pixels) + 'px')).show();
        } else {
          $(selector + ' .loading-square-4').css('height', (pixels + 'px')).show();
        }
      } else {
        $(selector + ' .loading-square-3').css('width', (pixels + 'px')).show();
      }
    } else {
      $(selector + ' .loading-square-2').css('height', (pixels + 'px')).css('top', ((540 - pixels) + 'px')).show();
    }
  } else {
    $(selector + ' .loading-square-1').css('width', (pixels + 'px')).css('left', ((400 - pixels) + 'px')).show();
  }
}

/**
Handles correct uploading process in the Lesson Editor (correct in the sense that the file is not too large and could correctly be received by the web server).
@method uploadDoneLessonEditor
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
@param errors {Hash} a hash of the kind 'field': 'error'
@param gallery {String} the HTML content to be replaced into the gallery, if the uploading was successful
@param pages {Number} number of pages of the newly loaded gallery
@param count {Number} number of elements inside the gallery
**/
function uploadDoneLessonEditor(selector, errors, gallery, pages, count) {
  var type = selector.split('-');
  type = type[type.length - 1];
  $window.unbind('beforeunload');
  if(errors != undefined) {
    top.uploaderErrorsLessonEditor(selector, errors);
  } else {
    $(selector).data('loader-can-move', false);
    setTimeout(function() {
      if(type != 'audio') {
        var dialogs_selector = (type == 'image') ? '.imageInGalleryPopUp' : '.videoInGalleryPopUp'
        $(dialogs_selector).each(function() {
          if($(this).hasClass('ui-dialog-content')) {
            $(this).dialog('destroy');
          }
        });
      }
      $(selector + ' .part3 .close').removeClass('disabled');
      $(selector + ' .part3 .submit').removeClass('disabled');
      $(selector + ' .part1 .attachment .file').unbind('click');
      var gallery_scrollable = $('#' + type + '_gallery_content > div');
      if(gallery_scrollable.data('jsp') != undefined) {
        gallery_scrollable.data('jsp').destroy();
      }
       var container = $('#lesson_editor_' + type + '_gallery_container');
       container.find('#' + type + '_gallery').replaceWith(gallery);
       container.data('page', 1);
       container.data('tot-pages', pages);
       $('._close_' + type + '_gallery').addClass('_close_' + type + '_gallery_in_lesson_editor');
       $('._select_' + type + '_from_gallery').addClass('_add_' + type + '_to_slide');
       if(type == 'audio') {
         if(count > 6) {
           initializeAudioGalleryInLessonEditor();
         } else {
           $('.audio_gallery .scroll-pane').css('overflow', 'hidden');
         }
       }
       if(type == 'image') {
         if(count > 21) {
           initializeImageGalleryInLessonEditor();
         } else {
           $('.image_gallery .scroll-pane').css('overflow', 'hidden');
         }
       }
       if(type == 'video') {
         if(count > 6) {
           initializeVideoGalleryInLessonEditor();
         } else {
           $('.video_gallery .scroll-pane').css('overflow', 'hidden');
         }
       }
      $(selector + ' .part3 .close').click();
      $(selector + ' .loading-square').hide();
    }, 1000);
  }
}

/**
Handles the errors of loading in Lesson Editor.
@method uploaderErrorsLessonEditor
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
@param errors {Hash} a hash of the kind 'field': 'error'. It can't be undefined!
**/
function uploaderErrorsLessonEditor(selector, errors) {
  $(selector + ' .form_error').removeClass('form_error');
  $(selector + ' .errors_layer').hide();
  $.each(errors, function(key, value) {
    $(selector + ' .errors_layer.' + key).text(value).show();
    if(key == 'media') {
      $(selector + ' .part1 .galleryMediaShow').addClass('form_error');
    } else if(key == 'tags') {
      $(selector + ' .part2 ._tags_container').addClass('form_error');
    } else {
      $(selector + ' .part2 .' + key).addClass('form_error');
    }
  });
  $(selector).data('loader-can-move', false).data('loader-with-errors', true);
  $(selector + ' .part3 .close').removeClass('disabled');
  $(selector + ' .part3 .submit').removeClass('disabled');
  $(selector + ' .part1 .attachment .file').unbind('click');
}

/**
Handles 413 status error, file too large, inside Lesson Editor.
@method uploadFileTooLargeLessonEditor
@for UploaderLessonEditor
@param selector {String} HTML selector for the specific uploader (audio, video, image or document)
**/
function uploadFileTooLargeLessonEditor(selector) {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $window.unbind('beforeunload');
    unbindLoader();
    var fake_url = (selector == 'document') ? '/lessons/galleries/documents/create/fake' : '/lessons/galleries/media_elements/create/fake'
    $.ajax({
      type: 'get',
      url: fake_url,
      data: $('#new_' + selector).serialize()
    }).always(bindLoader);
  }
}
