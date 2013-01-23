$(document).ready(function() {
  
  $('body').on('click', '#image_editor_crop_action', function() {
    if(!$(this).hasClass('current')) {
      // reset buttons
      resetImageEditorOperationsChoice();
      // reset other functions in the image
      resetImageEditorTexts();
      // buttons for crop
      $(this).addClass('current');
      $('#image_editor_empty_buttons').hide();
      $('#image_editor_crop_buttons').show();
      // class of the image
      $('#image_wrapper img').addClass('forCrop');
      // button to commit
      $('._create_new_image, ._updatable_image').css('visibility', 'hidden');
      // initialize
      $('#cropped_image').imgAreaSelect({
        enable: true,
        handles: true,
        onSelectEnd: function(img, selection) {
          $('input[name="x1"]').val(selection.x1);
          $('input[name="y1"]').val(selection.y1);
          $('input[name="x2"]').val(selection.x2);
          $('input[name="y2"]').val(selection.y2);
        }
      });
    }
  });
  
  $('body').on('click', '#image_editor_crop_buttons ._cancel', function() {
    resetImageEditorOperationsChoice();
    resetImageEditorCrop();
    $('._create_new_image, ._updatable_image').css('visibility', 'visible');
  });
  
  $('body').on('click', '#image_editor_text_action', function() {
    if(!$(this).hasClass('current')) {
      // reset buttons
      resetImageEditorOperationsChoice();
      // reset other functions in the image
      resetImageEditorCrop();
      // buttons for texts
      $(this).addClass('current');
      $('#image_editor_empty_buttons').hide();
      $('#image_editor_text_buttons').show();
      // class of the image
      $('#image_wrapper img').addClass('forText');
      // button to commit
      $('._create_new_image, ._updatable_image').css('visibility', 'hidden');
      // initialize
      $('#image_editor_container').addClass('_text_enabled');
    }
  });
  
  $('body').on('click', '#image_editor_text_buttons ._cancel', function() {
    resetImageEditorOperationsChoice();
    resetImageEditorTexts();
    $('._create_new_image, ._updatable_image').css('visibility', 'visible');
  });
  
  $('body').on('click', '#image_editor_container._text_enabled img', function(e) {
    var coords = getRelativePositionInImageEditor($(this), e);
    var textCount = $('#info_container').data('current-textarea-identifier');
    $('#info_container').data('current-textarea-identifier', textCount + 1);
    $('#image_editor_container').append(textAreaImageEditorContent(coords, textCount));
    $('#image_editor_text_' + textCount).draggable({
      containment: 'parent',
      handle: '._move',
      cursor: '-webkit-grabbing',
      stop: function() {
        coords = getDragPosition($(this));
        $(this).children('textarea').data('coords', coords[0] + ',' + coords[1]);
      }
    });
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
    
    
    

  
  
  
  
  
  
  
  
  // FIXME FIXME FIXME fino a qui
  
  $('body').on('click', '#image_editor_crop', function() {
    var thisForm = $('#crop_form');
    thisForm.attr('action', '/images/' + thisForm.data('param') + '/crop');
    thisForm.submit();
    $('.menuServiceImages').hide();
    $('.menuTextImages').show();
    $('._create_new_image, ._updatable_image').css('visibility', 'visible');
    $('._toggle_crop').removeClass('current');
  });
  
  $('body').on('click', '#image_editor_not_public ._save_edit_image', function() {
    var image_id = $(this).data('slide-id');
    saveImageChoice(image_id);
  });
  
  $('body').on('click', '#image_editor_public ._save_edit_image', function() {
    var image_id = $(this).data('slide-id');
    $('._save_edit_image').hide();
    $('#form_info_new_media_element_in_editor').show();
  });
  
  $('body').on('click', '#image_editor_public #form_info_new_media_element_in_editor ._commit, #image_editor_not_public #form_info_new_media_element_in_editor ._commit', function() {
    $('.form_error').removeClass('form_error');
    commitImageEditing('new');
  });
  
  $('body').on('click', '#image_editor_not_public #form_info_update_media_element_in_editor ._commit', function() {
    $('.form_error').removeClass('form_error');
    commitImageEditing('overwrite');
  });
  
  $('body').on('click', '#image_editor_public #form_info_new_media_element_in_editor ._cancel', function() {
    $('.form_error').removeClass('form_error');
    $('#form_info_new_media_element_in_editor').hide();
    $('._save_edit_image').show();
  });
  
  $('body').on('click', '#image_editor_not_public #form_info_new_media_element_in_editor._title_reset ._cancel', function() {
    $('._titled').show();
    $('._untitled').hide();
  });
  
  $('body').on('click', '#image_editor_not_public #form_info_update_media_element_in_editor ._cancel', function() {
    $('.form_error').removeClass('form_error');
    $('#form_info_update_media_element_in_editor').hide();
    $('._save_edit_image').show();
  });
  
});

function commitImageEditing(new_or_overwrite) {
  processTextAreaForm();
  var thisForm = $('#crop_form');
  thisForm.attr('action', '/images/' + thisForm.data('param') + '/commit/' + new_or_overwrite);
  thisForm.submit();
}

function saveImageChoice(image_id) {
  var title = $('.header h1 span');
  showConfirmPopUp(title.text(), "<h1>What's next?</h1><p>You can choose to update original image or create a new one</p>", "update", 'new', function() {
    $('#dialog-confirm').hide();
    $('._save_edit_image').hide();
    $('#form_info_update_media_element_in_editor').show();
    closePopUp('dialog-confirm');
  }, function() {
    $('#dialog-confirm').hide();
    $('._titled').hide();
    $('._untitled').show();
    $('._save_edit_image').hide();
    $('#form_info_new_media_element_in_editor').show();
    $('#form_info_new_media_element_in_editor').addClass('_title_reset');
    closePopUp('dialog-confirm');
  });
}

function resizedValue(width,height) {
  wrapper_ratio = 660/495;
  original_ratio = width/height;
  resized= ['w', 'h', 'zoom'];
  if(original_ratio >= wrapper_ratio) {
    //resized width is 660
    r_h = 660*height/width 
    r_zoom = width/660
    resized=[660,r_h,r_zoom]
  } else {
    //resized height 495
    r_w = 495*width/height
    r_zoom = height/495
    resized=[r_w,495,r_zoom]
  }
  return resized;
}

// Update form with textareas
function processTextAreaForm() {
  $('#_image_editor_container .image_editor_text textarea').each(function(index) {
    var tarea = $(this);
    addTextAreaHiddenFields(tarea.data('color'), tarea.data('size'), tarea.data('coords'), tarea.val(), index);
  });
}

function addTextAreaHiddenFields(color, size, coords, text, index) {
  hidden_input_coords = $('<input />',
  {
    'class': 'area_' + index,
    type: 'hidden',
    id: 'hidden_coords_' + index,
    name: 'coords_' + index,
    val: coords
  });
  hidden_input_text = $('<input />',
  {
    'class': 'area_' + index,
    type: 'hidden',
    id: 'hidden_text_' + index,
    name: 'text_' + index,
    val: text
  });
  hidden_input_color = $('<input />',
  {
    'class': 'area_' + index,
    type: 'hidden',
    id: 'hidden_color_' + index,
    name: 'color_' + index,
    val: color
  });
  hidden_input_font = $('<input />',
  {
    'class': 'area_' + index,
    type: 'hidden',
    id: 'hidden_font_' + index,
    name: 'font_' + index,
    val: size
  });
  $('#crop_form').prepend(hidden_input_coords).prepend(hidden_input_text).prepend(hidden_input_color).prepend(hidden_input_font);
}














// FIXME FIXME FIXME funzioni già riviste


function enlightTextarea(id) {
  $('#image_editor_textarea_' + id).css('background-color', 'rgba(230,230,230,0.5)');
  $('#image_editor_textarea_tools_' + id).css('visibility', 'visible');
}

function offlightTextareas() {
  $('.text_tools').css('visibility', 'hidden');
  $('._inner_textarea').css('background-color', 'rgba(255,255,255,0)');
}

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

function textAreaImageEditorContent(coords, textCount) {
  var textarea_container = $($('#image_editor_empty_text_area_container').html());
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

function getRelativePositionInImageEditor(obj, event) {
  var posX = obj.offset().left, posY = obj.offset().top;
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY) + 25); //padding + 25
  return coords;
}

function resetImageEditorOperationsChoice() {
  $('#image_editor_crop_buttons').hide();
  $('#image_editor_text_buttons').hide();
  $('#image_editor_empty_buttons').show();
  $('#image_editor_crop_action').removeClass('current');
  $('#image_editor_text_action').removeClass('current');
}

function resetImageEditorCrop() {
  $('#image_wrapper img').removeClass('forCrop');
  $('#cropped_image').imgAreaSelect({
    hide: true,
    disable: true
  });
  $('#crop_form input._coord').val('');
}

function resetImageEditorTexts() {
  $('#image_wrapper img').removeClass('forText');
  $('#image_editor_container').removeClass('_text_enabled');
  $('._image_editor_text').remove();
}
