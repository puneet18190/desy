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
    $('#video_editor_mixed_gallery_container ' + type).show();
  }
}

function removeComponentInVideoEditor(position) {
}

function addImageComponentInVideoEditor(component, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in ultima posizione, per una durata di ' + duration + ' secondi');
  // mettere flash
}

function replaceImageComponentInVideoEditor(component, position, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in posizione ' + position + ', rimpiazzando quella già esistente, per una durata di ' + duration + ' secondi');
  // mettere flash
}

function addVideoComponentInVideoEditor(component, duration) {
  alert('stai aggiungendo la componente -- ' + component + ' in ultima posizione  (il video dura ' + duration + ' secondi)');
  // mettere flash
}

function replaceVideoComponentInVideoEditor(component, position, duration) {
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

function switchTextComponentBackgroundColor(old_color, new_color) {
  $('._text_component_preview').removeClass('background_color_' + old_color).addClass('background_color_' + new_color);
  $('._text_component_in_video_editor_background_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_background_color_selector .background_color_' + new_color).addClass('current');
}

function switchTextComponentTextColor(old_color, new_color) {
  $('._text_component_preview textarea').removeClass('color_' + old_color).addClass('color_' + new_color);
  $('._text_component_in_video_editor_text_color_selector ._color').removeClass('current');
  $('._text_component_in_video_editor_text_color_selector .background_color_' + new_color).addClass('current');
}
