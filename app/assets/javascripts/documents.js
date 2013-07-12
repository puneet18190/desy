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
  $('body').on('click', '#my_documents .buttons .preview', function() {
    
    alert('previewing document ' + $(this).data('document-id')); // TODO
    
  });
  $('body').on('click', '#my_documents .buttons .edit', function() {
    
    alert('editing document ' + $(this).data('document-id')); // TODO
    
  });
  $('body').on('click', '#my_documents .buttons .destroy', function() {
    
    alert('destroying document ' + $(this).data('document-id')); // TODO
    
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
  $('body').on('click', '._empty_documents, #upload_document', function() {
    openNewDocumentLoader();
  });
  $('body').on('change', '#order_documents', function() {
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
  $('body').on('click', '#search_documents_submit', function() {
    $('#search_documents').submit();
  });
  $('body').on('focus', '#search_documents ._word_input', function() {
    if($('#search_documents_placeholder').val() == '') {
      $(this).val('');
      $(this).css('color', '#939393');
      $('#search_documents_placeholder').val('0');
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
