/**
Javascript functions used in the media element and document loader.
@module uploader
**/





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
    closePopUp('load-media-element');
  })
  $body.on('click', '#new_media_element_submit', function() {
    $('input,textarea').removeClass('form_error');
    $('.barraLoading img').show();
    $('.barraLoading img').attr('src', '/assets/loadingBar.gif');
    $(this).closest('#new_media_element').submit();
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
    $('.form_error').removeClass('form_error');
    $('.too_large').remove();
    document.getElementById('new_media_element').target = 'upload_target';
    document.getElementById('upload_target').onload = uploadDone;
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
    closePopUp('load-document');
  })
  $body.on('click', '#new_document_submit', function() {
    $('input,textarea').removeClass('form_error');
    $('.barraLoading img').show();
    $('.barraLoading img').attr('src', '/assets/loadingBar-document.gif');
    $(this).closest('#new_document').submit();
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
    $('.form_error').removeClass('form_error');
    $('.too_large').remove();
    document.getElementById('new_document').target = 'upload_doc_target';
    document.getElementById('upload_doc_target').onload = uploadDocumentDone;
  });
}



















/**
Handles 413 status error, file too large.
@method uploadDone
@for MediaElementLoaderDone
@return {Boolean} false, for some reason
**/
function uploadDone() {
  $('#upload_target').css('height', '60px');
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $('.barraLoading img').hide();
    $('iframe').before('<p class="too_large" style="padding: 20px 0 0 40px;"><img src="/assets/puntoesclamativo.png" style="margin: 20px 5px 0 20px;"><span class="lower" style="color:black">' + $('#load-media-element').data('media-file-too-large') + '</span></p>');
    $('#media_element_media_show').text($('#load-media-element').data('placeholder-media'));
  }
  return false;
}

/**
Reloads media elements page after new media element is successfully loaded.
@method uploadMediaElementLoaderDoneRedirect
@for MediaElementLoaderDone
**/
function uploadMediaElementLoaderDoneRedirect() {
  $('.barraLoading').css('background-color', '#41A62A');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/media_elements';
}

/**
Update form fields with error labels.
@method uploadMediaElementLoaderError
@for MediaElementLoaderErrors
@param errors {Array} errors list
**/
function uploadMediaElementLoaderError(errors) {
  for (var i = 0; i < errors.length; i++) {
    var error = errors[i];
    if(error == 'media') {
      $('#load-media-element #media_element_media_show').addClass('form_error');
    } else if(error == 'tags') {
      $('#load-media-element ._tags_container').addClass('form_error');
      $('#load-media-element ._tags_container ._placeholder').hide();
    } else {
      $('#load-media-element #' + error).addClass('form_error');
      if($('#load-media-element #' + error + '_placeholder').val() == '') {
        $('#load-media-element #' + error).val('');
      }
    }
  }
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
}

/**
Handles 413 status error, file too large.
@method uploadDocumentDone
@for DocumentsUploader
@return {Boolean} false, for some reason
**/
function uploadDocumentDone() {
  $('#upload_doc_target').css('height', '60px');
  var ret = document.getElementById('upload_doc_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)) {
    $('.barraLoading img').hide();
    $('iframe').before('<p class="too_large" style="padding: 20px 0 0 40px;"><img src="/assets/puntoesclamativo.png" style="margin: 20px 5px 0 20px;"><span class="lower" style="color:black">' + $('#load-document').data('attachment-too-large') + '</span></p>');
    $('#document_attachment_show').text($('#load-document').data('placeholder-attachment'));
  }
  return false;
}

/**
Reloads documents page after new document is successfully loaded.
@method uploadDocumentLoaderDoneRedirect
@for DocumentsUploader
**/
function uploadDocumentLoaderDoneRedirect() {
  $('.barraLoading').css('background-color', '#5D5C5C');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/documents';
}

/**
Update form fields with error labels.
@method uploadDocumentLoaderError
@for DocumentsUploader
@param errors {Array} errors list
**/
function uploadDocumentLoaderError(errors) {
  for (var i = 0; i < errors.length; i++) {
    var error = errors[i];
    if(error == 'attachment') {
      $('#load-document #document_attachment_show').addClass('form_error');
    } else {
      $('#load-document #' + error).addClass('form_error');
      if($('#load-document #' + error + '_placeholder').val() == '') {
        $('#load-document #' + error).val('');
      }
    }
  }
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
}
