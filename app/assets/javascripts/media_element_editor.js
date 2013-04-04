function mediaElementEditorDocumentReady() {
  
  $('body').on('focus', '#form_info_new_media_element_in_editor #new_title', function() {
    if($('#form_info_new_media_element_in_editor #new_title_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#form_info_new_media_element_in_editor #new_title_placeholder').attr('value', '0');
    }
  });
  
  $('body').on('focus', '#form_info_new_media_element_in_editor #new_description', function() {
    if($('#form_info_new_media_element_in_editor #new_description_placeholder').val() == '') {
      $(this).attr('value', '');
      $('#form_info_new_media_element_in_editor #new_description_placeholder').attr('value', '0');
    }
  });
  
}

function getNormalizedPositionTimelineHorizontalScrollPane(jscrollpane_id, component_width, component_position, components_visible_number) {
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width);
  var resp = how_many_hidden_to_left * component_width;
  if(how_many_hidden_to_left + components_visible_number < component_position) {
    resp += component_width;
  }
  return resp;
}

function getAbsolutePositionTimelineHorizontalScrollPane(jscrollpane_id, component_width, component_position, components_visible_number) {
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width);
  if($('#' + jscrollpane_id).data('jsp').getPercentScrolledX() == 1) {
    how_many_hidden_to_left += 1;
  }
  var resp = (components_visible_number - 1);
  if(how_many_hidden_to_left + components_visible_number >= component_position) {
   resp = (component_position - how_many_hidden_to_left - 1);
  }
  return resp * component_width;
}

function getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width) {
  var hidden_to_left = $('#' + jscrollpane_id).data('jsp').getContentPositionX();
  return parseInt(hidden_to_left / component_width);
}

function calculateCorrectMovementHorizontalScrollLeft(hidden, movement) {
  if(movement > hidden) {
    return hidden;
  } else {
    return movement;
  }
}

function calculateCorrectMovementHorizontalScrollRight(hidden, movement, tot, visible) {
  return calculateCorrectMovementHorizontalScrollLeft(tot - hidden - visible, movement);
}

function recenterMyMediaElements() {
  var WW = $(window).width();
  var elNumber = WW / 220;
  $('._boxViewExpandedMediaElementWrapper').css('width', (100/parseInt(elNumber)) + '%');
}

function resetMediaElementEditorForms() {
  $('#form_info_new_media_element_in_editor .error_messages, #form_info_update_media_element_in_editor .error_messages').html('');
  var new_form = $('#form_info_new_media_element_in_editor');
  var update_form = $('#form_info_update_media_element_in_editor');
  new_form.find('#new_title').val(new_form.data('title'));
  new_form.find('#new_title').removeClass('form_error');
  new_form.find('#new_title_placeholder').val('');
  new_form.find('#new_description').val(new_form.data('description'));
  new_form.find('#new_description').removeClass('form_error');
  new_form.find('#new_description_placeholder').val('');
  new_form.find('._tags_container span').remove();
  new_form.find('._tags_container').removeClass('form_error');
  new_form.find('._tags_container ._placeholder').show();
  new_form.find('#new_tags_value').val('');
  update_form.find('#update_title').val(update_form.data('title'));
  update_form.find('#update_title').removeClass('form_error');
  update_form.find('#update_title_placeholder').val('');
  update_form.find('#update_description').val(update_form.data('description'));
  update_form.find('#update_description').removeClass('form_error');
  update_form.find('#update_description_placeholder').val('');
  update_form.find('._tags_container span').remove();
  update_form.find('._tags_placeholder span').each(function() {
    var copy = $(this)[0].outerHTML;
    update_form.find('._tags_container').prepend(copy);
  });
  update_form.find('#update_tags_value').val(update_form.find('._tags_placeholder').data('tags'));
  update_form.find('._tags_container').removeClass('form_error');
}

function startCacheLoop() {
  $('#info_container').data('save-cache', true);
  saveCacheLoop();
}

function stopCacheLoop() {
  $('#info_container').data('cache-enabled-first-time', false);
  $('#info_container').data('save-cache', false);
}

function submitMediaElementEditorCacheForm(form) {
  $.ajax({
    type: "POST",
    url: form.attr('action'),
    timeout: 5000,
    data: form.serialize(),
    beforeSend: unbindLoader()
  }).always(bindLoader);
}

function saveCacheLoop() {
  var cache_form = '';
  if($('html').hasClass('video_editor-controller')) {
    cache_form = $('#video_editor_form');
  }
  if($('html').hasClass('audio_editor-controller')) {
    cache_form = $('#audio_editor_form');
  }
  var time = $('#popup_parameters_container').data('cache-time');
  if(cache_form != '' && $('#info_container').data('save-cache')) {
    submitMediaElementEditorCacheForm(cache_form);
    setTimeout(function() {
      saveCacheLoop();
    }, time);
  }
}
