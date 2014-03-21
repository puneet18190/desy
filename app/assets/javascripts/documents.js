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
          $('#dialog-document-' + document_id + ' .stocazzo').hide(); // TODO formms
          var change_info_button = $('#dialog-document-' + document_id + ' .stocazzo'); // TODO formms
          change_info_button.addClass('change_info').removeClass('change_info_light');
        }
      });
    }
  });
  $body.on('click', '#my_documents .buttons .destroy', function() {
    var current_url = $('#info_container').data('currenturl');
    var document_id = $(this).data('document-id');
    var captions = $captions;
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
        type: 'delete',
        dataType: 'json',
        url: '/documents/' + document_id,
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
  $body.on('change', '#order_documents', function() {
    var order = $('#order_documents option:selected').val();
    var word = $('#search_documents ._word_input').val();
    var word_placeholder = $('#search_documents_placeholder').val();
    $('#search_documents_hidden_order').val(order);
    $.get('/documents?word=' + word + '&word_placeholder=' + word_placeholder + '&order=' + order);
  });
  $body.on('focus', '.stocazzo ._doc_description', function() { // TODO formms
    var placeholder = $('#dialog-document-' + $(this).data('document-id') + ' ._doc_description_placeholder');
    if(placeholder.val() != '') {
      placeholder.val('');
      $(this).val('');
    }
  });
  $body.on('click', '._close_document_preview_popup', function() {
    var document_id = $(this).data('document-id');
    closePopUp('dialog-document-' + document_id);
  });
  $body.on('click', '.stocazzo ._cancel, .stocazzo.change_info_light', function() { // TODO formms
    var document_id = $(this).data('document-id');
    $('#dialog-document-' + document_id + ' .stocazzo').hide('fade', {}, 500, function() { // TODO formms
      var icon = $('#dialog-document-' + document_id + ' .stocazzo'); // TODO formms
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
  $body.on('click', '.stocazzo.change_info', function() { // TODO formms
    var document_id = $(this).data('document-id');
    $('#dialog-document-' + document_id + ' .stocazzo').show('fade', {}, 500); // TODO formms
    $(this).removeClass('change_info');
    $(this).addClass('change_info_light');
  });
  $body.on('keydown', '.stocazzo ._doc_title, .stocazzo ._doc_description', function() { // TODO formms
    $(this).removeClass('form_error');
  });
  $('#order_documents option[selected]').first().attr('selected', 'selected');
  $('#order_documents').selectbox();
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
