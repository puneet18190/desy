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
}

/**
Initializer for documents functionality (buttons javascripts).
@method documentsDocumentReadyButtons
@for DocumentsDocumentReady
**/
function documentsDocumentReadyButtons() {
  $body.on('click', '#my_documents .buttons .preview', function() {
    
    alert('previewing document ' + $(this).data('document-id')); // TODO
    
  });
  $body.on('click', '#my_documents .buttons .destroy', function() {
    var current_url = $('#info_container').data('currenturl');
    var document_id = $(this).data('document-id');
    var captions = $captions;
    var title = captions.data('destroy-document-title');
    var confirm = captions.data('destroy-document-confirm');
    var yes = captions.data('destroy-document-yes');
    var no = captions.data('destroy-document-no');
    if($(this).data('document-used-in-your-lessons')) {
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
  $body.on('mouseover', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').addClass('current');
  });
  $body.on('mouseout', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').removeClass('current');
  });
  $body.on('click', '._empty_documents, #upload_document', function() {
    openNewDocumentLoader();
  });
  $body.on('change', '#order_documents', function() {
    var order = $('#order_documents option:selected').val();
    var redirect_url = getCompleteDocumentsUrlWithoutOrder() + '&order=' + order;
    $('#search_documents_hidden_order').val(order);
    $.get(redirect_url);
  });
}

/**
Initializer for documents functionality (search and placeholders javascripts).
@method documentsDocumentReadySearch
@for DocumentsDocumentReady
**/
function documentsDocumentReadySearch() {
  $body.on('keydown', '#search_documents ._word_input', function(e) {
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
Initializer for documents functionality.
@method openNewDocumentLoader
@for DocumentsLoader
**/
function openNewDocumentLoader() {
  
  alert('sto aprendo il DOCUMENT LOADER'); // TODO
  
}
