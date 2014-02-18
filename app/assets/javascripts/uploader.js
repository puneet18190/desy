/**
Javascript functions used in the media element and document loader.
@module uploader
**/





/**
Recursive animation of the loading bar, according to the function h * x / (x + 1). Time is divided by 400 to slow down the animation.
@method uploadAnimationRecursion
@for UploadCallbacks
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
      uploadAnimationRecursion(item, (time + increment), increment, max_width)
    }, increment);
  } else {
    item.data('can-move', true);
  }
}

/**
Handles correct uploading process (correct in the sense that the file is not too large and could correctly be received by the web server).
@method uploadDone
@for UploadCallbacks
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
@for UploadCallbacks
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
@for UploadCallbacks
@param selector {String} either 'document' or 'media-element'
**/
function uploadFileTooLarge(selector) {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $window.unbind('beforeunload');
    unbindLoader();
    $.ajax({
      type: 'get',
      url: selector + 's/create/fake',
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
  })
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
  })
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











function showPercentLessonEditorUploadinBar(scope, percent) {
  var pixels = percent * 2984 / 100;
  if(pixels > 450) {
    $(scope + 'loading-square-1').show();
    pixels -= 450;
    if(pixels > 590) {
      $(scope + 'loading-square-2').show();
      pixels -= 590;
      if(pixels > 900) {
        $(scope + 'loading-square-3').show();
        pixels -= 900;
        if(pixels > 590) {
          $(scope + 'loading-square-4').show();
          pixels -= 590;
          // TODO
        } else {
          // TODO
        }
      } else {
        // TODO
      }
    } else {
      // TODO
    }
  } else {
    // TODO
  }
}
