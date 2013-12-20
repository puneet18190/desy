/**
Javascript functions used in the media element and document loader.
@module uploader
**/





/**
Reloads media elements page after new media element is successfully loaded.
@method uploadAnimationRecursion
@for UploadCallbacks
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
Handles 413 status error, file too large.
@method uploadDone
@for UploadCallbacks
**/
function uploadDone(selector, callback, errors, fields) {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    // TODO metti messaggio $('#load-' + selector).data('media-file-too-large')
    // TODO metti in rosso il campo del  file
    // TODO fai chiamata al server per beccare gli altri errori
  } else {
    if(callback != undefined) {
      callback(errors, fields);
    } else {
      top.uploadRedirect(selector);
    }
  }
}

/**
Reloads media elements page after new media element is successfully loaded.
@method uploadRedirect
@for UploadCallbacks
**/
function uploadRedirect(selector) {
  $('#load-' + selector + ' .barraLoading .loading-internal').data('can-move', false).css('width', '760px');
  setTimeout(function() {
    window.location = '/' + selector.replace('load-', '').replace('-', '_') + 's';
  }, 500);
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
    if(file_name.length > 20) {
      file_name = file_name.substring(0, 20) + '...';
    }
    $('#media_element_media_show').text(file_name);
  });
  $body.on('click', '#load-media-element ._close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-media-element');
    }
  })
  $body.on('click', '#new_media_element_submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $('#load-media-element ._close').addClass('disabled');
      $('input, textarea').removeClass('form_error');
      uploadAnimationRecursion($('#load-media-element .barraLoading .loading-internal'), 0, 5, 760);
      $(this).closest('#new_media_element').submit();
    } else {
      e.preventDefault();
    }
  });
  $body.on('focus', '#load-media-element #title', function() {
    if($('#load-media-element #title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-media-element #description', function() {
    if($('#load-media-element #description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #description_placeholder').attr('value', '0');
    }
  });
  $body.on('submit', '#new_media_element', function() {
    document.getElementById('new_media_element').target = 'upload_target';
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
    if(file_name.length > 20) {
      file_name = file_name.substring(0, 20) + '...';
    }
    $('#document_attachment_show').text(file_name);
  });
  $body.on('click', '#load-document ._close', function() {
    if(!$(this).hasClass('disabled')) {
      closePopUp('load-document');
    }
  })
  $body.on('click', '#new_document_submit', function(e) {
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $('#load-document ._close').addClass('disabled');
      $('input,textarea').removeClass('form_error');
      uploadAnimationRecursion($('#load-document .barraLoading .loading-internal'), 0, 5, 760);
      $(this).closest('#new_document').submit();
    } else {
      e.preventDefault();
    }
  });
  $body.on('focus', '#load-document #title', function() {
    if($('#load-document #title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document #title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-document #description', function() {
    if($('#load-document #description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document #description_placeholder').attr('value', '0');
    }
  });
  $body.on('submit', '#new_document', function() {
    document.getElementById('new_document').target = 'upload_target';
  });
}





/**
Update form fields with error labels.
@method uploaderErrorsDocuments
@for UploaderErrors
@param errors {Array} errors list
**/
function uploaderErrorsDocuments(errors, fields) {

console.log(errors);
console.log(fields);

//  for (var i = 0; i < errors.length; i++) {
//    var error = errors[i];
//    if(error == 'attachment') {
//      $('#load-document #document_attachment_show').addClass('form_error');
//    } else {
//      $('#load-document #' + error).addClass('form_error');
//      if($('#load-document #' + error + '_placeholder').val() == '') {
//        $('#load-document #' + error).val('');
//      }
//    }
//  }
//  // TODO interrompere animazione e togliere colore alla barra
}

/**
Update form fields with error labels.
@method uploaderErrorsMediaElements
@for UploaderErrors
@param errors {Array} errors list
**/
function uploaderErrorsMediaElements(errors, fields) {

console.log(errors);
console.log(fields);

//  for (var i = 0; i < errors.length; i++) {
//    var error = errors[i];
//    if(error == 'media') {
//      $('#load-media-element #media_element_media_show').addClass('form_error');
//    } else if(error == 'tags') {
//      $('#load-media-element ._tags_container').addClass('form_error');
//      $('#load-media-element ._tags_container ._placeholder').hide();
//    } else {
//      $('#load-media-element #' + error).addClass('form_error');
//      if($('#load-media-element #' + error + '_placeholder').val() == '') {
//        $('#load-media-element #' + error).val('');
//      }
//    }
//  }
//  // TODO interrompere animazione e togliere colore alla barra
}
