/**
This module contains javascript functions common to all the editors ({{#crossLinkModule "audio-editor"}}{{/crossLinkModule}}, {{#crossLinkModule "image-editor"}}{{/crossLinkModule}}, {{#crossLinkModule "video-editor"}}{{/crossLinkModule}}).
@module media-element-editor
**/





/**
One step of the repeated <b>cache</b> saving (used in {{#crossLinkModule "image-editor"}}{{/crossLinkModule}} and {{#crossLinkModule "video-editor"}}{{/crossLinkModule}})
@method saveCacheLoop
@for MediaElementEditorCache
**/
function saveCacheLoop() {
  var cache_form = '';
  if( $html.hasClass('video_editor-controller') ) {
    cache_form = $('#video_editor_form');
  }
  if( $html.hasClass('audio_editor-controller') ) {
    cache_form = $('#audio_editor_form');
  }
  var time = $parameters.data('cache-time');
  if(cache_form != '' && $('#info_container').data('save-cache')) {
    submitMediaElementEditorCacheForm(cache_form);
    setTimeout(function() {
      saveCacheLoop();
    }, time);
  }
}

/**
Initializes the <b>cache loop</b> and starts it calling {{#crossLink "MediaElementEditorCache/saveCacheLoop:method"}}{{/crossLink}}.
@method startCacheLoop
@for MediaElementEditorCache
**/
function startCacheLoop() {
  $('#info_container').data('save-cache', true);
  saveCacheLoop();
}

/**
Stops the cache loop.
@method stopCacheLoop
@for MediaElementEditorCache
**/
function stopCacheLoop() {
  $('#info_container').data('cache-enabled-first-time', false);
  $('#info_container').data('save-cache', false);
}

/**
Submethod of {{#crossLink "MediaElementEditorCache/saveCacheLoop:method"}}{{/crossLink}}.
@method submitMediaElementEditorCacheForm
@for MediaElementEditorCache
**/
function submitMediaElementEditorCacheForm(form) {
  unbindLoader();
  $.ajax({
    type: 'post',
    url: form.attr('action'),
    timeout: 5000,
    data: form.serialize()
  }).always(bindLoader);
}





/**
Function that checks the conversion of the unconverted media elements in the page.
@method mediaElementLoaderConversionOverview
@for MediaElementEditorConversion
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
Initializes the placeholder of the <b>commit forms</b> used in {{#crossLinkModule "audio-editor"}}{{/crossLinkModule}}, {{#crossLinkModule "image-editor"}}{{/crossLinkModule}} and {{#crossLinkModule "video-editor"}}{{/crossLinkModule}}.
@method mediaElementEditorDocumentReady
@for MediaElementEditorDocumentReady
**/
function mediaElementEditorDocumentReady() {
  $body.on('focus', '#form_info_new_media_element_in_editor #new_title', function() {
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags').removeClass('disabled');
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags #check_ad_hoc').removeAttr('disabled').removeAttr('checked');
    if($('#form_info_new_media_element_in_editor #new_title_placeholder').val() == '') {
      $(this).val('');
      $('#form_info_new_media_element_in_editor #new_title_placeholder').val('0');
    }
  });
  $body.on('focus', '#form_info_new_media_element_in_editor #new_description', function() {
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags').removeClass('disabled');
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags #check_ad_hoc').removeAttr('disabled').removeAttr('checked');
    if($('#form_info_new_media_element_in_editor #new_description_placeholder').val() == '') {
      $(this).val('');
      $('#form_info_new_media_element_in_editor #new_description_placeholder').val('0');
    }
  });
  $body.on('click', '#form_info_new_media_element_in_editor #only_to_conserve_tags', function() {
    if(!$(this).hasClass('disabled')) {
      var form = $('#form_info_new_media_element_in_editor');
      $(this).addClass('disabled');
      form.find('#only_to_conserve_tags #check_ad_hoc').attr('checked', 'checked').attr('disabled', 'disabled');
      form.find('#new_title').val(form.find('#only_to_conserve_tags .edited_container .edited_title').val());
      form.find('#new_title_placeholder').val('0');
      form.find('#new_description').val(form.find('#only_to_conserve_tags .edited_container .edited_description').val());
      form.find('#new_description_placeholder').val('0');
      var old_tags_placeholder = form.find('._tags_container ._placeholder')[0].outerHTML;
      var old_tags_value = form.find('._tags_container #new_tags_value')[0].outerHTML;
      var old_tags = form.find('#new_tags')[0].outerHTML;
      form.find('._tags_container').html(form.find('#only_to_conserve_tags .edited_container .edited_tags_container').html());
      form.find('._tags_container').append(old_tags + old_tags_placeholder + old_tags_value);
      form.find('._tags_container ._placeholder').hide();
      form.find('#new_tags_value').val(form.find('#only_to_conserve_tags .edited_container .edited_tags').val());
      form.find('._tags_container, #new_title, #new_description').removeClass('form_error');
    }
  });
  $body.on('keydown', '#form_info_update_media_element_in_editor #update_title, #form_info_update_media_element_in_editor #update_description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('keydown', '#form_info_new_media_element_in_editor #new_title, #form_info_new_media_element_in_editor #new_description', function() {
    $(this).removeClass('form_error');
  });
  $body.on('keydown', '#form_info_update_media_element_in_editor #update_tags, #form_info_new_media_element_in_editor #new_tags', function() {
    $(this).parent().removeClass('form_error');
  });
}





/**
Resets the media element loading form; used in {{#crossLink "DialogsWithForm/showLoadMediaElementPopUp:method"}}{{/crossLink}}.
@method resetMediaElementChangeInfo
@for MediaElementEditorForms
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

/**
Resets the <b>commit forms</b> used in {{#crossLinkModule "audio-editor"}}{{/crossLinkModule}}, {{#crossLinkModule "image-editor"}}{{/crossLinkModule}} and {{#crossLinkModule "video-editor"}}{{/crossLinkModule}}. This method is associated to the button 'cancel' in these forms (see {{#crossLink "AudioEditorDocumentReady/audioEditorDocumentReadyCommit:method"}}{{/crossLink}}, {{#crossLink "ImageEditorDocumentReady/imageEditorDocumentReadyCommit:method"}}{{/crossLink}} and {{#crossLink "VideoEditorDocumentReady/videoEditorDocumentReadyCommit:method"}}{{/crossLink}}).
@method resetMediaElementEditorForms
@for MediaElementEditorForms
**/
function resetMediaElementEditorForms() {
  $('#form_info_new_media_element_in_editor .error_messages, #form_info_update_media_element_in_editor .error_messages').html('');
  var new_form = $('#form_info_new_media_element_in_editor');
  var update_form = $('#form_info_update_media_element_in_editor');
  new_form.find('#only_to_conserve_tags').removeClass('disabled');
  new_form.find('#only_to_conserve_tags #check_ad_hoc').removeAttr('disabled').removeAttr('checked');
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





/**
Submethod used in the methods of {{#crossLink "VideoEditorScrollPain"}}{{/crossLink}}: calculates the correct movement that a horizontal <b>left</b> scroll must do taking into consideration the space available (thing that obviously JScrollPain doesn't do itself).
@method calculateCorrectMovementHorizontalScrollLeft
@for MediaElementEditorHorizontalTimelines
@param hidden {Float} the portion of the scroll hidden on the left
@param movement {Float} the required movement
@return {Float} the correct movement to do
**/
function calculateCorrectMovementHorizontalScrollLeft(hidden, movement) {
  if(movement > hidden) {
    return hidden;
  } else {
    return movement;
  }
}

/**
Submethod used in the methods of {{#crossLink "VideoEditorScrollPain"}}{{/crossLink}}: calculates the correct movement that a horizontal <b>right</b> scroll must do taking into consideration the space available (thing that obviously JScrollPain doesn't do itself).
@method calculateCorrectMovementHorizontalScrollRight
@for MediaElementEditorHorizontalTimelines
@param hidden {Float} the portion of the scroll hidden on the left
@param movement {Float} the required movement
@return {Float} the correct movement to do
**/
function calculateCorrectMovementHorizontalScrollRight(hidden, movement, tot, visible) {
  return calculateCorrectMovementHorizontalScrollLeft(tot - hidden - visible, movement);
}

/**
Submethod used in the methods of {{#crossLink "VideoEditorScrollPain"}}{{/crossLink}}: calculates the absolute position to be assigned to <b>a div that must be aligned to the component</b> after having been moved to first position.
@method getAbsolutePositionTimelineHorizontalScrollPane
@for MediaElementEditorHorizontalTimelines
@param jscrollpane_id {String} the HTML id of the scroll pane
@param component_width {Number} the width in pixels of a single component
@param component_position {Number} the position among the other components
@param components_visible_number {Number} how many components are visible at the same time in the scroll pane
@return {Number} the correct position of the div in pixels (it's not float because we pass to the method only integers, unlike {{#crossLink "MediaElementEditorHorizontalTimelines/calculateCorrectMovementHorizontalScrollRight:method"}}{{/crossLink}} and {{#crossLink "MediaElementEditorHorizontalTimelines/calculateCorrectMovementHorizontalScrollRight:method"}}{{/crossLink}} that are defined generally)
**/
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

/**
Submethod used in the methods of {{#crossLink "VideoEditorScrollPain"}}{{/crossLink}}: gets how many components are hidden to the left of the scroll pane.
@method getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane
@for MediaElementEditorHorizontalTimelines
@param jscrollpane_id {String} the HTML id of the scroll pane
@param component_width {Number} the width in pixels of a single component
@return {Number} the number of components hidden to the left
**/
function getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width) {
  var hidden_to_left = $('#' + jscrollpane_id).data('jsp').getContentPositionX();
  return parseInt(hidden_to_left / component_width);
}

/**
Submethod used in the methods of {{#crossLink "VideoEditorScrollPain"}}{{/crossLink}}: exactly the same as {{#crossLink "MediaElementEditorHorizontalTimelines/getAbsolutePositionTimelineHorizontalScrollPane:method"}}{{/crossLink}}, but <b>it returns the position of the scroll pane</b> instead of the absolute pixels for an external div.
@method getNormalizedPositionTimelineHorizontalScrollPane
@for MediaElementEditorHorizontalTimelines
@param jscrollpane_id {String} the HTML id of the scroll pane
@param component_width {Number} the width in pixels of a single component
@param component_position {Number} the position among the other components
@param components_visible_number {Number} how many components are visible at the same time in the scroll pane
@return {Number} the correct position of the scroll in pixels
**/
function getNormalizedPositionTimelineHorizontalScrollPane(jscrollpane_id, component_width, component_position, components_visible_number) {
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width);
  var resp = how_many_hidden_to_left * component_width;
  if(how_many_hidden_to_left + components_visible_number < component_position) {
    resp += component_width;
  }
  return resp;
}
