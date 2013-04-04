/**
Image editor functions, crop and textarea management.
@module image-editor
**/





/**
bla bla bla
@method imageEditorDocumentReady
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReady() {
  imageEditorDocumentReadyGeneral();
  imageEditorDocumentReadyCrop();
  imageEditorDocumentReadyTexts();
  imageEditorDocumentReadyUndo();
  imageEditorDocumentReadyCommit();
}

/**
bla bla bla
@method imageEditorDocumentReadyCommit
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReadyCommit() {
  $('body').on('click', '#commit_image_editor', function() {
    if($(this).hasClass('_with_choice')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('save-media-element-editor-title');
      var confirm = captions.data('save-media-element-editor-confirm');
      var yes = captions.data('save-media-element-editor-yes');
      var no = captions.data('save-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        closePopUp('dialog-confirm');
        $('._image_editor_bottom_bar').hide();
        $('#image_editor #form_info_update_media_element_in_editor').show();
      }, function() {
        closePopUp('dialog-confirm');
        $('#image_editor_title ._titled').hide();
        $('#image_editor_title ._untitled').show();
        $('._image_editor_bottom_bar').hide();
        $('#image_editor #form_info_new_media_element_in_editor').show();
      });
    } else {
      $('._image_editor_bottom_bar').hide();
      $('#image_editor #form_info_new_media_element_in_editor').show();
    }
  });
  $('body').on('click', '#image_editor #form_info_new_media_element_in_editor ._commit', function() {
    var form = $('#image_editor_form');
    form.attr('action', '/images/' + form.data('param') + '/commit/new');
    form.submit();
  });
  $('body').on('click', '#image_editor #form_info_update_media_element_in_editor ._commit', function() {
    if($('#info_container').data('used-in-private-lessons')) {
      var captions = $('#popup_captions_container');
      var title = captions.data('overwrite-media-element-editor-title');
      var confirm = captions.data('overwrite-media-element-editor-confirm');
      var yes = captions.data('overwrite-media-element-editor-yes');
      var no = captions.data('overwrite-media-element-editor-no');
      showConfirmPopUp(title, confirm, yes, no, function() {
        $('dialog-confirm').hide();
        var form = $('#image_editor_form');
        form.attr('action', '/images/' + form.data('param') + '/commit/overwrite');
        form.submit();
      }, function() {
        closePopUp('dialog-confirm');
      });
    } else {
      var form = $('#image_editor_form');
      form.attr('action', '/images/' + form.data('param') + '/commit/overwrite');
      form.submit();
    }
  });
  $('body').on('click', '#image_editor #form_info_new_media_element_in_editor ._cancel', function() {
    resetMediaElementEditorForms();
    if($('#image_editor_title ._titled').length > 0) {
      $('#image_editor_title ._titled').show();
      $('#image_editor_title ._untitled').hide();
    }
    $('._image_editor_bottom_bar').show();
    $('#image_editor #form_info_new_media_element_in_editor').hide();
  });
  $('body').on('click', '#image_editor #form_info_update_media_element_in_editor ._cancel', function() {
    resetMediaElementEditorForms();
    $('._image_editor_bottom_bar').show();
    $('#image_editor #form_info_update_media_element_in_editor').hide();
  });
}

/**
bla bla bla
@method imageEditorDocumentReadyCrop
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReadyCrop() {
  $('#cropped_image').imgAreaSelect({
    hide: true,
    disable: true,
    handles: true,
    onSelectEnd: function(img, selection) {
      $('input[name="x1"]').val(selection.x1);
      $('input[name="y1"]').val(selection.y1);
      $('input[name="x2"]').val(selection.x2);
      $('input[name="y2"]').val(selection.y2);
      if($('.imgareaselect-outer').first().is(':visible')) {
        $('#image_editor_crop_buttons ._do').removeClass('disabled');
      }
    }
  });
  $('body').on('click', '.imgareaselect-outer', function() {
    $('#image_editor_crop_buttons ._do').addClass('disabled');
  });
  $('body').on('click', '#image_editor_crop_action', function() {
    if(!$(this).hasClass('current')) {
      resetImageEditorOperationsChoice();
      resetImageEditorTexts();
      $(this).addClass('current');
      $('#image_editor_empty_buttons').hide();
      $('#image_editor_crop_buttons').show();
      $('#image_wrapper img').addClass('forCrop');
      $('#commit_image_editor').css('visibility', 'hidden');
      $('#cropped_image').imgAreaSelect({
        hide: false,
        disable: false
      });
    }
  });
  $('body').on('click', '#image_editor_crop_buttons ._cancel', function() {
    resetImageEditorOperationsChoice();
    resetImageEditorCrop();
    $('#commit_image_editor').css('visibility', 'visible');
  });
  $('body').on('click', '#image_editor_crop_buttons ._do', function() {
    if(!$(this).hasClass('disabled')) {
      var form = $('#image_editor_form');
      form.attr('action', '/images/' + form.data('param') + '/crop');
      form.submit();
    }
  });
}

/**
bla bla bla
@method imageEditorDocumentReadyGeneral
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReadyGeneral() {
  $('.image_editor_only #form_info_new_media_element_in_editor, .image_editor_only #form_info_update_media_element_in_editor').css("left",($(window).width()/2)-495);
  $('#image_gallery_for_image_editor ._select_image_from_gallery').addClass('_add_image_to_image_editor');
  $('#image_gallery_for_image_editor .gallery-header').css("left",($(window).width()/2)-420);
  $('body').on('click', '._add_image_to_image_editor', function() {
    var parser = document.createElement('a');
    parser.href = $('._exit_url').attr('href');
    window.location = '/images/' + $(this).data('image-id') + '/edit?back=' + encodeURIComponent(parser.pathname+parser.search+parser.hash);
  });
}

/**
bla bla bla
@method imageEditorDocumentReadyTexts
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReadyTexts() {
  $('body').on('click', '#image_editor_text_action', function() {
    if(!$(this).hasClass('current')) {
      resetImageEditorOperationsChoice();
      resetImageEditorCrop();
      $(this).addClass('current');
      $('#image_editor_empty_buttons').hide();
      $('#image_editor_text_buttons').show();
      $('#image_wrapper img').addClass('forText');
      $('#commit_image_editor').css('visibility', 'hidden');
      $('#image_editor_container').addClass('_text_enabled');
    }
  });
  $('body').on('click', '#image_editor_text_buttons ._cancel', function() {
    resetImageEditorOperationsChoice();
    resetImageEditorTexts();
    $('#commit_image_editor').css('visibility', 'visible');
  });
  $('body').on('click', '#image_editor_container._text_enabled img', function(e) {
    var coords = getRelativePositionInImageEditor($(this), e);
    var textCount = $('#info_container').data('current-textarea-identifier');
    $('#image_editor_text_buttons ._do').removeClass('disabled');
    $('#info_container').data('current-textarea-identifier', textCount + 1);
    $('#image_editor_container').append(textAreaImageEditorContent(coords, textCount));
    $('#image_editor_text_' + textCount).draggable({
      containment: 'parent',
      handle: '._move',
      cursor: '-webkit-grabbing',
      stop: function() {
        coords = getDragPosition($(this));
        $('#image_editor_textarea_' + textCount).data('coords', coords[0] + ',' + coords[1]);
      }
    });
    coords = getDragPosition($('#image_editor_text_' + textCount));
    $('#image_editor_textarea_' + textCount).data('coords', coords[0] + ',' + coords[1]);
    offlightTextareas();
    enlightTextarea(textCount);
  });
  $('body').on('focus', '._inner_textarea', function() {
    offlightTextareas();
    enlightTextarea($(this).parent().attr('id').split('_')[3]);
  });
  $('body').on('click', 'a._delete', function() {
    var id = $(this).parent().attr('id').split('_')[4];
    $('#image_editor_text_' + id).remove();
    if($('._image_editor_text').length == 0) {
      $('#image_editor_text_buttons ._do').addClass('disabled');
    }
  });
  $('body').on('click', '._image_editor_text .text_colors a', function() {
    if(!$(this).hasClass('current')) {
      var new_color = $(this).attr('class').replace(' ', '').replace('background_', '');
      var id = $(this).parent().parent().attr('id').split('_')[4];
      var textarea = $('#image_editor_textarea_' + id);
      var tools = $('#image_editor_textarea_tools_' + id);
      tools.find('.text_colors a').removeClass('current');
      $(this).addClass('current');
      var old_color = textarea.data('color');
      textarea.data('color', new_color);
      textarea.removeClass(old_color).addClass(new_color);
    }
  });
  $('body').on('click', '._image_editor_text .font_sizes a', function() {
    if(!$(this).hasClass('current')) {
      var new_size = $(this).attr('class').replace(' ', '').replace('upper', '');
      var id = $(this).parent().parent().attr('id').split('_')[4];
      var textarea = $('#image_editor_textarea_' + id);
      var tools = $('#image_editor_textarea_tools_' + id);
      tools.find('.font_sizes a').removeClass('current');
      $(this).addClass('current');
      var old_size = textarea.data('size');
      textarea.data('size', new_size);
      textarea.removeClass(old_size).addClass(new_size);
    }
  });
  $('body').on('click', '#image_editor_text_buttons ._do', function() {
    if(!$(this).hasClass('disabled')) {
      var form = $('#image_editor_form');
      $('._image_editor_text ._inner_textarea').each(function() {
        var id = $(this).attr('id').split('_')[3];
        var coords = '<input class="_additional" type="hidden" name="coords_' + id + '" value="' + $(this).data('coords') + '"/>';
        var text = '<input class="_additional" type="hidden" name="text_' + id + '" value="' + $(this).val() + '"/>';
        var color = '<input class="_additional" type="hidden" name="color_' + id + '" value="' + $(this).data('color') + '"/>';
        var font = '<input class="_additional" type="hidden" name="font_' + id + '" value="' + $(this).data('size') + '"/>';
        form.prepend(coords).prepend(text).prepend(color).prepend(font);
      });
      form.attr('action', '/images/' + form.data('param') + '/add_text');
      form.submit();
    }
  });
}

/**
bla bla bla
@method imageEditorDocumentReadyUndo
@for ImageEditorDocumentReady
**/
function imageEditorDocumentReadyUndo() {
  $('body').on('click', '#image_editor_empty_buttons ._undo', function() {
    $.ajax({
      url: '/images/' + $('#image_editor_form').data('param') + '/undo',
      type: 'post'
    });
  });
}





/**
Reset image editor crop, disable crop state for image
@method resetImageEditorCrop
@for ImageEditorGraphics
**/
function resetImageEditorCrop() {
  $('#image_wrapper img').removeClass('forCrop');
  $('#cropped_image').imgAreaSelect({
    hide: true,
    disable: true
  });
  $('#image_editor_form input._coord').val('');
  $('#image_editor_crop_buttons ._do').addClass('disabled');
}

/**
Reset image editor functions, reset image editor to initial state
@method resetImageEditorOperationsChoice
@for ImageEditorGraphics
**/
function resetImageEditorOperationsChoice() {
  $('#image_editor_crop_buttons').hide();
  $('#image_editor_text_buttons').hide();
  $('#image_editor_empty_buttons').show();
  $('#image_editor_crop_action').removeClass('current');
  $('#image_editor_text_action').removeClass('current');
}

/**
Reset image editor textareas, disable text state for image
@method resetImageEditorTexts
@for ImageEditorGraphics
**/
function resetImageEditorTexts() {
  $('#image_wrapper img').removeClass('forText');
  $('#image_editor_container').removeClass('_text_enabled');
  $('._image_editor_text').remove();
  $('#image_editor_text_buttons ._do').addClass('disabled');
}





/**
Get image relative position into editor container
@method getRelativePositionInImageEditor
@for ImageEditorImageScale
@param obj {Object} image
@param event {Object} click event
@return {Array} image relative position coordinates
**/
function getRelativePositionInImageEditor(obj, event) {
  var posX = obj.offset().left, posY = obj.offset().top;
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY) + 25);
  return coords;
}





/**
Sets current textarea to active.
@method enlightTextarea
@for ImageEditorTexts
@param id {Number} identifier for textarea to set current 
**/
function enlightTextarea(id) {
  $('#image_editor_textarea_' + id).css('background-color', 'rgba(230,230,230,0.5)');
  $('#image_editor_textarea_tools_' + id).css('visibility', 'visible');
  $('#image_editor_textarea_' + id).parent('._image_editor_text').addClass('current');
}

/**
Get textarea coordinates while dragging
@method getDragPosition
@for ImageEditorTexts
@param obj {Object} textarea container
@return {Array} two items array with X,Y coords in px
**/
function getDragPosition(obj) {
  var imgOff = $('#image_wrapper').children('img').offset();
  var imgOffX = imgOff.left;
  var imgOffY = imgOff.top;
  var offX = obj.children('textarea').offset().left, offY = (obj.children('textarea').offset().top);
  coords = []
  coords.push(offX-imgOffX);
  coords.push(offY-imgOffY);
  return coords;
}

/**
Disable textareas, typically applied to all textareas, removes the current flag to active textarea.
@method offlightTextarea
@for ImageEditorTexts
**/
function offlightTextareas() {
  $('.text_tools').css('visibility', 'hidden');
  $('._inner_textarea').css('background-color', 'rgba(255,255,255,0)');
  $('._image_editor_text.current').removeClass('current');
}

/**
Append new textarea to image editor container
@method textAreaImageEditorContent
@for ImageEditorTexts
@param coords {Array} textarea coordinates
@param textCount {Number} textarea container id
@return {Object} new textarea container
**/
function textAreaImageEditorContent(coords, textCount) {
  var textarea_container = $($.trim($('#image_editor_empty_text_area_container').html()));
  textarea_container.addClass('_image_editor_text');
  textarea_container.find('#image_editor_textarea_without_id').attr('id', 'image_editor_textarea_' + textCount);
  textarea_container.find('#image_editor_textarea_tools_without_id').attr('id', 'image_editor_textarea_tools_' + textCount);
  textarea_container.attr('id', 'image_editor_text_' + textCount);
  var textarea = textarea_container.find('#image_editor_textarea_tools_' + textCount);
  textarea.data('coords', (coords[2] + ',' + coords[3]));
  textarea.attr('name', 'text_' + textCount);
  textarea_container.css('left', coords[0]);
  textarea_container.css('top', coords[1]);
  return textarea_container[0];
}
