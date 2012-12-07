function initializeVideoEditor() {
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('._video_editor_component_menu').hide();
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

function replaceComponentInVideoEditor(component, position) {

// mettere flash

}

function addComponentInVideoEditor(component) {

// mettere flash

}
