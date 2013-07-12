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
}

/**
Initializer for documents functionality (search and placeholders javascripts).
@method documentsDocumentReadySearch
@for DocumentsDocumentReady
**/
function documentsDocumentReadySearch() {
  $('body').on('click', '#search_documents_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_documents').submit();
      $(this).addClass('current');
    }
  });
  $('body').on('focus', '#search_documents ._word_input', function() {
    if($('#search_documents_placeholder').val() == '') {
      $('#search_documents_submit').removeClass('current');
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
