function initializeVideoEditor() {
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('._video_editor_component_menu').hide();
}

function closeMixedGalleryInVideoEditor() {
  $('#video_editor_mixed_gallery_container').hide();
  $('#video_editor').css('display', 'inline-block');
}

function switchToOtherGalleryInMixedGalleryInVideoEditor(type) {
  if($('#video_editor_mixed_gallery_container ' + type).css('display') == 'none') {
    var big_selector = '#video_editor_mixed_gallery_container ._videos, #video_editor_mixed_gallery_container ._images, #video_editor_mixed_gallery_container ._texts';
    $(big_selector).each(function() {
      if($(this).css('display') == 'block') {
        big_selector = this;
      }
    });
    $(big_selector).hide();
    if(type == 'text') {
      resetVideoEditorTextComponent();
    }
    $('#video_editor_mixed_gallery_container ' + type).show();
  }
}

function removeComponentInVideoEditor(position) {
}

function addImageComponentInVideoEditor(image_id, component, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in ultima posizione, per una durata di ' + duration + ' secondi');
  // mettere flash
}

function replaceImageComponentInVideoEditor(image_id, component, position, duration) {
  var identifier = position.split('_');
  identifier = identifier[identifier.length - 1];
  $('#' + position + ' ._video_component_thumb').replaceWith(component);
  clearSpecificVideoEditorComponentParameters(position);
  $('#' + position + ' ._video_component_input_type').val('image');
  var to_be_appended = fillVideoEditorSingleParameter('image', identifier, image_id);
  to_be_appended += fillVideoEditorSingleParameter('duration', identifier, duration);
  $('#' + position + ' ._video_editor_component_hover').append(to_be_appended);
  // mettere flash
}

function addVideoComponentInVideoEditor(video_id, component, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in ultima posizione  (il video dura ' + duration + ' secondi)');
  // mettere flash
}

function replaceVideoComponentInVideoEditor(video_id, component, position, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in posizione ' + position + ', rimpiazzando quella già esistente (il video dura ' + duration + ' secondi)');
  // mettere flash
}

function addTextComponentInVideoEditor(content, duration, background_color, text_color) {
  alert('stai aggiungendo la componente testuale -- ' + content + ' in ultima posizione, con una durata di ' + duration + ' secondi, con colore di sfondo ' + background_color + ' e colore testuale ' + text_color);
  // mettere flash
}

function replaceTextComponentInVideoEditor(content, position, duration, background_color, text_color) {
  alert('stai aggiungendo la componente -- ' + content + ' in posizione ' + position + ', rimpiazzando quella già esistente, con una durata di ' + duration + ' secondi, con colore di sfondo ' + background_color + ' e colore testuale ' + text_color);
  // mettere flash
}

function resetVideoEditorTextComponent() {
  $('#text_component_preview textarea').val($('#popup_captions_container').data('text-component-placeholder-in-video-editor'));
  $('#video_editor_mixed_gallery_container ._texts ._duration_selector input').val('');
  $('#text_component_preview').data('placeholder', true);
  var old_background_color = $('#text_component_preview').data('background-color');
  var old_text_color = $('#text_component_preview').data('text-color');
  switchTextComponentBackgroundColor(old_background_color, 'white');
  switchTextComponentTextColor(old_text_color, 'black');
}

function switchTextComponentBackgroundColor(old_color, new_color) {
  $('#text_component_preview').removeClass('background_color_' + old_color).addClass('background_color_' + new_color);
  $('._text_component_in_video_editor_background_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_background_color_selector .background_color_' + new_color).addClass('current');
  $('#text_component_preview').data('background-color', new_color);
}

function switchTextComponentTextColor(old_color, new_color) {
  $('#text_component_preview textarea').removeClass('color_' + old_color).addClass('color_' + new_color);
  $('._text_component_in_video_editor_text_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_text_color_selector .background_color_' + new_color).addClass('current');
  $('#text_component_preview').data('text-color', new_color);
}

function changeDurationVideoEditorComponent(component_id, new_duration) {
  var old_duration = $('#' + component_id).data('duration');
  var total_length = $('#info_container').data('total-length');
  total_length -= old_duration;
  total_length += new_duration;
  $('#' + component_id).data('duration', new_duration);
  $('#info_container').data('total-length', total_length);
  $('#visual_video_editor_total_length').html(secondsToDateString(total_length));
}

function fillVideoEditorSingleParameter(input, identifier, value) {
  return '<input id="' + input + '_' + identifier + '" type="hidden" value="' + value + '" name="' + input + '_' + identifier + '">';
}

function clearSpecificVideoEditorComponentParameters(component_id) {
  var huge_selector = '#' + component_id + ' ._video_component_input_content';
  huge_selector += ', #' + component_id + ' ._video_component_input_background_color';
  huge_selector += ', #' + component_id + ' ._video_component_input_text_color';
  huge_selector += ', #' + component_id + ' ._video_component_input_duration';
  huge_selector += ', #' + component_id + ' ._video_component_input_image';
  huge_selector += ', #' + component_id + ' ._video_component_input_video';
  huge_selector += ', #' + component_id + ' ._video_component_input_from';
  huge_selector += ', #' + component_id + ' ._video_component_input_until';
  $(huge_selector).remove();
}
