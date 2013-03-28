/**
* New media element popup handler, form validation errors handling.
* 
* @module MediaElementLoader
*/

/**
* Set iframe as target for form submit, added a callback function to control 413 status error.
*
* Uses: [uploadDone](../classes/uploadDone.html#method_uploadDone)
* 
* @method initMediaElementLoader
* @for initMediaElementLoader
*/
function initMediaElementLoader() {
  document.getElementById('new_media_element').onsubmit=function() {
    $('.form_error').removeClass('form_error');
    $('.too_large').remove();
    document.getElementById('new_media_element').target = 'upload_target'; //'upload_target' is the name of the iframe
    document.getElementById("upload_target").onload = uploadDone;
  }
}

/**
* Handle 413 status error, file too large
* 
* @method uploadDone
* @for uploadDone
*/
function uploadDone(){
  var ret = document.getElementById("upload_target").contentWindow.document.title;
  if(ret && ret.match(/413/g)){
    $('.barraLoading img').hide();
    $('iframe').before("<p class='too_large' style='padding: 20px 0 0 40px;'><img src='/assets/puntoesclamativo.png' style='margin: 20px 5px 0 20px;'><span class='lower' style='color:black'>" + $('#load-media-element').data('media-file-too-large') + "</span></p>");
    $('#media_element_media_show').text($('#load-media-element').data('placeholder-media'));
  }
  return false;
}

/**
* Update form fields with error labels
* 
* @method uploadMediaElementLoaderError
* @for uploadMediaElementLoaderError
* @param errors {Object} errors list
*/
function uploadMediaElementLoaderError(errors) {
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

/**
* Reload media elements page after new media element is successfully loaded.
* 
* @method uploadMediaElementLoadeDoneRedirect
* @for uploadMediaElementLoadeDoneRedirect
*/
function uploadMediaElementLoadeDoneRedirect() {
  $('.barraLoading').css('background-color', '#41A62A');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/media_elements';
}

/**
* Fill in media element update form with media element values.
* 
* @method resetMediaElementChangeInfo
* @for resetMediaElementChangeInfo
* @param media_element_id {Number} media element id
*/
function resetMediaElementChangeInfo(media_element_id) {
  var container = $('#dialog-media-element-' + media_element_id + ' ._change_info_container');
  container.find('#title').val(container.data('title'));
  container.find('#description').val(container.data('description'));
  container.find('.form_error').removeClass('form_error');
  container.find('._error_messages').html('');
  container.find('._tags_container span').remove();
  container.find('._tags_placeholder span').each(function() {
    var copy = $(this)[0].outerHTML;
    container.find('._tags_container').prepend(copy);
  });
  container.find('#tags_value').val(container.data('tags'));
}