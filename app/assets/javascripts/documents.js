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
  $('body').on('mouseover', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').addClass('current');
  });
  $('body').on('mouseout', '._empty_documents', function() {
    $(this).find('._empty_documents_hover').removeClass('current');
  });
  $('body').on('click', '._empty_documents', function() {
    openNewDocumentLoader();
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
