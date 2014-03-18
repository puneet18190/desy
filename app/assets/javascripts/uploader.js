/**
Javascript functions used in the media element and document loader.
<br/><br/>
The class {{#crossLink "UploaderGlobal"}}{{/crossLink}} contains functions that handle uploading processes in regular sections, such as dashboard, my elements, my documents, and also Lesson Editor ({{#crossLinkModule "lesson-editor"}}{{/crossLinkModule}}, see the initializer {{#crossLink "LessonEditorDocumentReady/lessonEditorDocumentReadyUploaderInGallery:method"}}{{/crossLink}}).
@module uploader
**/





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
      linearRecursionUploadingBar(container, time + 5, k, start, callback)
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
      if(key == 'media') {
        container.find('.part1 .galleryMediaShow').addClass('form_error');
      } else if(key == 'tags') {
        container.find('.part2 ._tags_container').addClass('form_error');
      } else {
        container.find('.part2 .' + key).addClass('form_error');
      }
    }
  });
  container.data('loader-can-move', false).data('loader-with-errors', true);
  container.find('.part3 .close').removeClass('disabled');
  container.find('.part3 .submit').removeClass('disabled');
  container.find('.part1 .attachment .file').unbind('click');
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
      $(this).addClass('disabled');
      $('#load-media-element .part3 .close').addClass('disabled');
      $('#load-media-element #new_media_element_input').on('click', function(e) {
        e.preventDefault();
      });
      $window.on('beforeunload', function() {
        return $captions.data('dont-leave-page-upload-media-element');
      });
      recursionUploadingBar($('#load-media-element'), 0);
      setTimeout(function() {
        $('#load-media-element form').submit();
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
  $body.on('click', '#load-document .part3 .close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-document');
    }
  });
  $body.on('click', '#load-document .part3 .submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $('#load-document .part3 .close').addClass('disabled');
      $('#load-document #new_document_input').on('click', function(e) {
        e.preventDefault();
      });
      $window.on('beforeunload', function() {
        return $captions.data('dont-leave-page-upload-document');
      });
      recursionUploadingBar($('#load-document'), 0);
      setTimeout(function() {
        $('#load-document form').submit();
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
@param item_id {Number} id of the newly loaded item (used only for documents)
**/
function uploadDoneLessonEditor(selector, errors, gallery, pages, count, item_id) {
  var type = selector.split('-');
  type = type[type.length - 1];
  $window.unbind('beforeunload');
  if(errors != undefined) {
    top.uploaderErrorsLessonEditor(selector, errors);
  } else {
    $(selector).data('loader-can-move', false);
    setTimeout(function() {
      var position_now = $(selector).data('loader-position-stop');
      var coefficient = (100 - position_now) / 500;
      linearRecursionUploadingBar($(selector), 0, coefficient, position_now, function() {
        $(selector).data('loader-position-stop', 0);
        if(type != 'audio' && type != 'document') {
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
        var gallery_scrollable = (type == 'document') ? $('.for-scroll-pain') : $('#' + type + '_gallery_content > div');
        if(gallery_scrollable.data('jsp') != undefined) {
          gallery_scrollable.data('jsp').destroy();
        }
        var container = $('#lesson_editor_' + type + '_gallery_container');
        container.data('page', 1);
        container.data('tot-pages', pages);
        if(type == 'document') {
          container.find('#document_gallery .documentsExternal').replaceWith(gallery);
          $('#document_gallery_filter').val('');
          if(count > 6) {
            initializeDocumentGalleryInLessonEditor();
          }
          container.find('#document_gallery').data('empty', false)
          $('#gallery_document_' + item_id + ' .add_remove').click();
        } else {
          container.find('#' + type + '_gallery').replaceWith(gallery);
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
        }
        $(selector + ' .part3 .close').click();
        $(selector + ' .loading-square').hide();
      });
    }, 100);
  }
}
