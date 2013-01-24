function initMediaElementLoader() {
  document.getElementById('new_media_element').onsubmit=function() {
    document.getElementById('new_media_element').target = 'upload_target'; //'upload_target' is the name of the iframe
  }
}

function uploadMediaElementLoaderError(errors) {
  var errs = errors.replace(/[\[\:\] ]/g, '').split(',');
  $.each(errs, function() {
    $('#media_element_' + this).addClass('form_error');
  });
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
}

function uploadMediaElementLoadeDoneRedirect() {
  $('.barraLoading').css('background-color', '#41A62A');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/media_elements';
}
