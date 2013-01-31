function initMediaElementLoader() {
  document.getElementById('new_media_element').onsubmit=function() {
    document.getElementById('new_media_element').target = 'upload_target'; //'upload_target' is the name of the iframe
  }
}

function uploadMediaElementLoaderError(errors) {
  $('#load-media-element .form_error').removeClass('form_error');
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

function uploadMediaElementLoadeDoneRedirect() {
  $('.barraLoading').css('background-color', '#41A62A');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/media_elements';
}

function resetMediaElementChangeInfo(media_element_id) {
  var container = $('#dialog-media-element-' + media_element_id + ' ._change_info_container');
  container.find('#title').val(container.data('title'));
  container.find('#description').val(container.data('description'));
  container.find('.form_error').removeClass('form_error');
  container.find('._error_messages').html('');
  container.find('._tags_placeholder span').each(function() {
    var copy = $(this)[0].outerHTML;
    container.find('._tags_container').prepend(copy);
  });
  container.find('#tags_value').val(container.data('tags'));
}
