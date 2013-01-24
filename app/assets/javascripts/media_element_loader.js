function initMediaElementLoader() {
  document.getElementById('new_media_element').onsubmit=function() {
    document.getElementById('new_media_element').target = 'upload_target'; //'upload_target' is the name of the iframe
  }
}

function uploadMediaElementLoaderError(errors) {
  for (var i = 0; i < errors.length; i++) {
    var error = errors[i];
    $('#' + error).addClass('form_error');
    if($('#' + error + '_placeholder').val() == '') {
      $('#' + error).val('');
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
