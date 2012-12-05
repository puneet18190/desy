function initializeVideoEditor() {
  $('#media_elements_list_in_video_editor').jScrollPane({
    autoReinitialise: true
  });
  $('._video_editor_component_menu').css('display', 'none');
}

function switchToOtherGalleryInMixedGalleryInVideoEditor(type) {
  if($('#video_editor_mixed_gallery_container ' + type).css('display') == 'none') {
    var big_selector = '#video_editor_mixed_gallery_container ._videos, #video_editor_mixed_gallery_container ._images, #video_editor_mixed_gallery_container ._texts';
    $(big_selector).each(function() {
      if($(this).css('display') == 'block') {
        big_selector = this;
      }
    });
    $(big_selector).hide('fade', {}, 500, function() {
      $(this).css('display', 'none');
      $('#video_editor_mixed_gallery_container ' + type).css('display', 'block');
    });
  }
}
