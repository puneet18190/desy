/**
Javascript  functions to be used in the section 'documents'.
@module documents
**/





/**
Initializer for documents functionality.
@method documentsDocumentReady
@for DocumentsDocumentReady
**/
function documentsDocumentReady() {
  documentsDocumentReadyGeneral();
  documentsDocumentReadySearch();
  documentsDocumentReadyButtons();
  documentsDocumentReadyUploader();
}

/**
Initializer for documents functionality (buttons javascripts).
@method documentsDocumentReadyButtons
@for DocumentsDocumentReady
**/
function documentsDocumentReadyButtons() {
  $('body').on('click', '#my_documents .buttons .preview', function() {
    var document_id = $(this).data('document-id');
    var obj = $('#dialog-document-' + document_id);
    if(obj.data('dialog')) {
      obj.dialog('open');
    } else {
      obj.show();
      obj.dialog({
        modal: true,
        resizable: false,
        draggable: false,
        width: 586,
        show: 'fade',
        hide: {effect: 'fade'},
        open: function() {
          customOverlayClose();
          var word = $('#search_documents ._word_input').val()
          $('#dialog-document-' + document_id + ' ._hidden_word').val(word);
        },
        beforeClose: function() {
          removeCustomOverlayClose();
        },
        close: function() {
          var container = $('#dialog-document-' + document_id);
          container.find('._doc_title').val(container.data('title'));
          container.find('._doc_description').val(container.data('description'));
          container.find('._doc_description_placeholder').val(container.data('description-placeholder'));
          container.find('.form_error').removeClass('form_error');
          container.find('._error_messages').html('');
          $('#dialog-document-' + document_id + ' ._document_change_info_container').hide();
          var change_info_button = $('#dialog-document-' + document_id + ' ._document_change_info_to_pick');
          change_info_button.addClass('change_info').removeClass('change_info_light');
        }
      });
    }
  });
  $('body').on('click', '#my_documents .buttons .destroy', function() {
    var current_url = $('#info_container').data('currenturl');
    var document_id = $(this).data('document-id');
    var captions = $('#popup_captions_container');
    var title = captions.data('destroy-document-title');
    var confirm = captions.data('destroy-document-confirm');
    var yes = captions.data('destroy-document-yes');
    var no = captions.data('destroy-document-no');
    if($(this).data('used-in-your-lessons')) {
      confirm = captions.data('destroy-document-confirm-bis');
    }
    showConfirmPopUp(title, confirm, yes, no, function() {
      $('#dialog-confirm').hide();
      var redirect_url = addDeleteItemToCurrentUrl(current_url, 'document_' + document_id);
      $.ajax({
        type: 'post',
        dataType: 'json',
        url: '/documents/' + document_id + '/destroy',
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
  });
}

/**
Initializer for documents functionality (general javascripts).
@method documentsDocumentReadyGeneral
@for DocumentsDocumentReady
**/
function documentsDocumentReadyGeneral() {
  $('body').on('mouseover', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').addClass('current');
  });
  $('body').on('mouseout', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').removeClass('current');
  });
  $('body').on('click', '._empty_documents, #upload_document a', function() {
    $('#upload_document ._attached').click();
  });
  $('body').on('change', '#order_documents', function() {
    var order = $('#order_documents option:selected').val();
    var redirect_url = getCompleteDocumentsUrlWithoutOrder() + '&order=' + order;
    $('#search_documents_hidden_order').val(order);
    $.get(redirect_url);
  });
  $('body').on('focus', '._document_change_info_container ._doc_description', function() {
    var placeholder = $('#dialog-document-' + $(this).data('document-id') + ' ._doc_description_placeholder');
    if(placeholder.val() != '') {
      placeholder.val('');
      $(this).val('');
    }
  });
  $('body').on('click', '._close_document_preview_popup', function() {
    var document_id = $(this).data('document-id');
    closePopUp('dialog-document-' + document_id);
  });
  $('body').on('click', '._document_change_info_container ._cancel, ._document_change_info_to_pick.change_info_light', function() {
    var document_id = $(this).data('document-id');
    $('#dialog-document-' + document_id + ' ._document_change_info_container').hide('fade', {}, 500, function() {
      var icon = $('#dialog-document-' + document_id + ' ._document_change_info_to_pick');
      icon.addClass('change_info');
      icon.removeClass('change_info_light');
      var container = $('#dialog-document-' + document_id);
      container.find('._doc_title').val(container.data('title'));
      container.find('._doc_description').val(container.data('description'));
      container.find('._doc_description_placeholder').val(container.data('description-placeholder'));
      container.find('.form_error').removeClass('form_error');
      container.find('._error_messages').html('');
    });
  });
  $('body').on('click', '._document_change_info_to_pick.change_info', function() {
    var document_id = $(this).data('document-id');
    $('#dialog-document-' + document_id + ' ._document_change_info_container').show('fade', {}, 500);
    $(this).removeClass('change_info');
    $(this).addClass('change_info_light');
  });
  $('body').on('click', '._document_pop_up_container ._download', function() {
    
    alert('scaricando il documento id ' + $(this).data('document-id')); // TODO
    
  });
}

/**
Initializer for documents functionality (search and placeholders javascripts).
@method documentsDocumentReadySearch
@for DocumentsDocumentReady
**/
function documentsDocumentReadySearch() {
  $('body').on('keydown', '#search_documents ._word_input', function(e) {
    if(e.which == 13) {
      e.preventDefault();
    } else if(e.which != 39 && e.which != 37) {
      var letters = $(this).data('letters');
      letters += 1;
      $(this).data('letters', letters);
      $('#search_documents ._loader').show();
      setTimeout(function() {
        if($('#search_documents ._word_input').data('letters') == letters) {
          $('#search_documents ._loader').hide();
          $('#search_documents').submit();
        }
      }, 1500);
    }
  });
}

/**
Initializer for the loading form.
@method documentsDocumentReadyUploader
@for DocumentsDocumentReady
**/
function documentsDocumentReadyUploader() {
  $('body').on('click', '._load_document', function(e) {
    e.preventDefault();
    showLoadDocumentPopUp();
  });
  $('body').on('change', 'input#new_document_input', function() {
    var file_name = $(this).val().replace("C:\\fakepath\\", '');
    if(file_name.length > 20) {
      file_name = file_name.substring(0, 20) + '...';
    }
    $('#document_attachment_show').text(file_name);
  });
  $('body').on('click', '#load-document ._close', function() {
    closePopUp('load-document');
  })
  $('body').on('click', '#new_document_submit', function() {
    $('input,textarea').removeClass('form_error');
    $('.barraLoading img').show();
    $('.barraLoading img').attr('src', '/assets/loadingBar.gif');
    $(this).closest('#new_document').submit();
  });
  $('body').on('focus', '#load-document #title', function() {
    if($('#load-document #title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document #title_placeholder').attr('value', '0');
    }
  });
  $('body').on('focus', '#load-document #description', function() {
    if($('#load-document #description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-document #description_placeholder').attr('value', '0');
    }
  });
}





/**
Dialog containing the form to upload a new document.
@method showLoadDocumentPopUp
@for DocumentsUploader
**/
function showLoadDocumentPopUp() {
  var obj = $('#load-document');
  if(obj.data('dialog')) {
    obj.dialog('open');
  } else {
    obj.show();
    obj.dialog({
      modal: true,
      resizable: false,
      draggable: false,
      width: 760,
      show: 'fade',
      hide: {effect: 'fade'},
      open: function(event, ui) {
        $('input').blur();
        $('#load-document #title').val($('#load-mdocument').data('placeholder-title'));
        $('#load-document #description').val($('#load-document').data('placeholder-description'));
        $('#load-document #title_placeholder').val('');
        $('#load-document #description_placeholder').val('');
        $('#document_attachment_show').text($('#load-document').data('placeholder-attachment'));
        $('#load-document .form_error').removeClass('form_error');
        $('#load-document .innerUploadFileButton').val('');
      },
      close: function() {
        $('#load-document iframe').attr('src', 'about:blank');
      }
    });
  }
}

/**
Handles 413 status error, file too large.
@method uploadDocumentDone
@for DocumentsUploader
@return {Boolean} false, for some reason
**/
function uploadDocumentDone() {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)){
    $('.barraLoading img').hide();
    $('iframe').before('<p class="too_large" style="padding: 20px 0 0 40px;"><img src="/assets/puntoesclamativo.png" style="margin: 20px 5px 0 20px;"><span class="lower" style="color:black">' + $('#load-document').data('media-file-too-large') + '</span></p>');
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
  $('.barraLoading').css('background-color', '#41A62A');
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

/**
Sets iframe as target for form submit, and adds a callback function to control 413 status error; notice that <b>upload target</b> is the HTML id of the frame.
@method initDocumentLoader
@for DocumentsUploader
**/
function initDocumentLoader() {
  document.getElementById('new_document').onsubmit = function() {
    $('.form_error').removeClass('form_error');
    $('.too_large').remove();
    document.getElementById('new_document').target = 'upload_target';
    document.getElementById('upload_target').onload = uploadDone;
  }
}
