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
  $body.on('click', '#my_documents .buttons .preview', function() { // TODO formms uniformarla con media elements
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
        width: 760,
        height: 440,
        show: 'fade',
        hide: {effect: 'fade'},
        open: function() {
          customOverlayClose();
          var word = $('#search_documents ._word_input').val()
          $('#dialog-document-' + document_id + ' .hidden_word').val(word);
        },
        beforeClose: function() {
          removeCustomOverlayClose();
        },
        close: function() {
          var container = $('#dialog-document-' + document_id);
          container.find('.stocazzo').val(container.data('title'));
          container.find('.stocazzo').val(container.data('description'));
          container.find('.form_error').removeClass('form_error');
          container.find('._error_messages').html('');
          $('#dialog-document-' + document_id + ' .stocazzo').hide();
          var change_info_button = $('#dialog-document-' + document_id + ' .stocazzo');
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
  $body.on('keydown', '.dialogDocument .wrapper .change-info .part2 .title, .dialogDocument .wrapper .change-info .part2 .description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('click', '.dialogDocument .menu .close', function() {
    closePopUp($(this).parents('.dialogDocument').attr('id'));
  });
  $body.on('click', '.dialogDocument .menu .change-info', function() {
    var container = $(this).parents('.dialogDocument');
    var form = container.find('.wrapper .change-info');
    if($(this).hasClass('encendido')) {
      form.hide();
      container.find('.preview').show();
      resetMediaElementChangeInfo(form); // TODO formms
      $(this).removeClass('encendido');
    } else {
      container.find('.preview').hide();
      form.show();
      $(this).addClass('encendido');
      disableTagsInputTooHigh(form.find('.part2 ._tags_container'));
    }
  });
  $body.on('click', '.dialogDocument .wrapper .change-info .part3 .close', function() {
    var container = $(this).parents('.dialogDocument');
    var form = container.find('.wrapper .change-info');
    form.hide();
    container.find('.preview').show();
    container.find('.menu .change-info').removeClass('encendido');
    resetMediaElementChangeInfo(form); // TODO formms
  });
  $body.on('click', '.dialogDocument .wrapper .change-info .part3 .submit', function() {
    var container = $(this).parents('.dialogDocument');
    container.find('form').submit();
  });
  $body.on('click', '.dialogDocument .wrapper .change-info .errors_layer', function() {
    var myself = $(this);
    var container = myself.parents('.dialogDocument');
    myself.hide();
    container.find(myself.data('selector')).focus();
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
