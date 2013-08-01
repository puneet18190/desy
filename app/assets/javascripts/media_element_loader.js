/**
Javascript functions used in the media element loader.
@module media-element-loader
**/





/**
Function that checks the conversion of the unconverted media elements in the page.
@method mediaElementLoaderConversionOverview
@for MediaElementLoaderConversion
@param list {Array} list of media elements that are being checked
@param time {Number} time to iterate the loop
**/
function mediaElementLoaderConversionOverview(list, time) {
  $('._media_element_item._disabled').each(function() {
    var my_id = $(this).find('._Image_button_preview, ._Audio_button_preview, ._Video_button_preview').data('clickparam');
    if(list.indexOf(my_id) == -1) {
      list.push(my_id);
    }
  });
  var black_list = $('#info_container').data('media-elements-not-anymore-in-conversion');
  for(var i = 0; i < black_list.length; i ++) {
    var j = list.indexOf(black_list[i]);
    list.splice(j, 1);
  }
  if(list.length > 0) {
    var ajax_url = '/media_elements/conversion/check?';
    for(var i = 0; i < list.length; i ++) {
      ajax_url += ('me' + list[i] + '=true');
      if(i != list.length - 1) {
        ajax_url += '&';
      }
    }
    unbindLoader();
    $.ajax({
      url: ajax_url,
      type: 'get'
    }).always(bindLoader);
  }
  setTimeout(function() {
    mediaElementLoaderConversionOverview(list, time);
  }, time);
}





/**
Initializer for the loading form.
@method mediaElementLoaderDocumentReady
@for MediaElementLoaderDocumentReady
**/
function mediaElementLoaderDocumentReady() {
  $body.on('click', '._load_media_element', function(e) {
    e.preventDefault();
    showLoadMediaElementPopUp();
  });
  $body.on('change', 'input#new_media_element_input', function() {
    var file_name = $(this).val().replace("C:\\fakepath\\", '');
    if(file_name.length > 20) {
      file_name = file_name.substring(0, 20) + '...';
    }
    $('#media_element_media_show').text(file_name);
  });
  $body.on('click', '#load-media-element ._close', function() {
    closePopUp('load-media-element');
  })
  $body.on('click', '#new_media_element_submit', function() {
    $('input,textarea').removeClass('form_error');
    $('.barraLoading img').show();
    $('.barraLoading img').attr('src', '/assets/loadingBar.gif');
    $(this).closest('#new_media_element').submit();
  });
  $body.on('focus', '#load-media-element #title', function() {
    if($('#load-media-element #title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #title_placeholder').attr('value', '0');
    }
  });
  $body.on('focus', '#load-media-element #description', function() {
    if($('#load-media-element #description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#load-media-element #description_placeholder').attr('value', '0');
    }
  });
}





/**
Handles 413 status error, file too large.
@method uploadDone
@for MediaElementLoaderDone
@return {Boolean} false, for some reason
**/
function uploadDone() {
  var ret = document.getElementById('upload_target').contentWindow.document.title;
  if(ret && ret.match(/413/g)){
    $('.barraLoading img').hide();
    $('iframe').before('<p class="too_large" style="padding: 20px 0 0 40px;"><img src="/assets/puntoesclamativo.png" style="margin: 20px 5px 0 20px;"><span class="lower" style="color:black">' + $('#load-media-element').data('media-file-too-large') + '</span></p>');
    $('#media_element_media_show').text($('#load-media-element').data('placeholder-media'));
  }
  return false;
}

/**
Reloads media elements page after new media element is successfully loaded.
@method uploadMediaElementLoaderDoneRedirect
@for MediaElementLoaderDone
**/
function uploadMediaElementLoaderDoneRedirect() {
  $('.barraLoading').css('background-color', '#41A62A');
  $('.barraLoading img').hide();
  $('.barraLoading img').attr('src', '');
  window.location = '/media_elements';
}





/**
Update form fields with error labels.
@method uploadMediaElementLoaderError
@for MediaElementLoaderErrors
@param errors {Array} errors list
**/
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
Sets iframe as target for form submit, and adds a callback function to control 413 status error; notice that <b>upload target</b> is the HTML id of the frame.
@method initMediaElementLoader
@for MediaElementLoaderGeneral
**/
function initMediaElementLoader() {
  document.getElementById('new_media_element').onsubmit=function() {
    $('.form_error').removeClass('form_error');
    $('.too_large').remove();
    document.getElementById('new_media_element').target = 'upload_target';
    document.getElementById('upload_target').onload = uploadDone;
  }
}

/**
Resets the media element loading form; used in {{#crossLink "DialogsWithForm/showLoadMediaElementPopUp:method"}}{{/crossLink}}.
@method resetMediaElementChangeInfo
@for MediaElementLoaderGeneral
@param media_element_id {Number} id of the element in the database, used to extract the HTML id
**/
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
