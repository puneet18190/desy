$(document).ready(function() {
  
  $("html.lesson-editor-layout ul#slides").css("margin-top", ((($(window).height() - 590)/2)-40) + "px");
  
  $('._image_container_in_lesson_editor').each(function() {
    makeDraggable($(this).attr('id'));
  });
  
  initializeSortableNavs();
  $('#nav_list_menu').jScrollPane({
      autoReinitialise: true
    });
    
  $(".slide-content.cover .title").css("margin-left", "auto");
  
  initLessonEditorPositions();
  
  $('#lesson_subject').selectbox();
  
  $('body').on('mouseover', '#slide-numbers li:not(._add_new_slide_options_in_last_position)', function(e) {
    var tip = $(this);
    var this_tooltip = tip.children('.slide-tooltip');
    if(e.pageX < ($(window).width()/2)){
      this_tooltip.show();  
    }else{
      this_tooltip.addClass("slide-tooltip-to-left");
      tip.children('.slide-tooltip-to-left').show();
    }
    
  });
  
  $('body').on('mouseout', '#slide-numbers li:not(._add_new_slide_options_in_last_position)', function(e) {
    var this_tooltip =$(this).children('.slide-tooltip');
    this_tooltip.removeClass("slide-tooltip-to-left");
    this_tooltip.hide();
  });
  
  $('body').on('click', '._slide_nav:not(._lesson_editor_current_slide_nav)', function(e) {
    e.preventDefault();
    stopMediaInCurrentSlide();
    saveCurrentSlide();
    slideTo($(this).data('slide-id'));
  });
  
  $('body').on('click', '._not_current_slide', function(e) {
    e.preventDefault();
    saveCurrentSlide();
    stopMediaInCurrentSlide();
    slideTo($(this).parent().data('slide-id'));
  });
  
  $('body').on('click', '._hide_add_new_slide_options', function() {
    hideNewSlideChoice();
  });
  
  $('body').on('click', '._save_slide', function(e) {
    e.preventDefault();
    saveCurrentSlide();
  });
  
  $('body').on('click', '._add_new_slide_options', function() {
    saveCurrentSlide();
    showNewSlideOptions();
  });
  
  $('body').on('click', '._add_new_slide_options_in_last_position', function() {
    saveCurrentSlide();
    var last_slide_id = $(this).parent().prev().find('a').data('slide-id');
    slideTo('' + last_slide_id, showNewSlideOptions);
  });
  
  $('body').on('click', '._add_new_slide', function() {
    hideNewSlideChoice();
    var slide = $('li._lesson_editor_current_slide');
    slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
    var kind = $(this).data('kind');
    var lesson_id = $('#info_container').data('lesson-id');
    var slide_id = slide.data('slide-id');
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/slides/' + slide_id + '/kind/' + kind + '/create/'
    });
  });
  
  $('body').on('click', '._delete_slide', function() {
    stopMediaInCurrentSlide();
    var slide = $('li._lesson_editor_current_slide');
    slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
    $.ajax({
      type: 'post',
      url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + slide.data('slide-id') + '/delete'
    });
  });
  
  $('body').on('click', '._show_image_gallery_in_lesson_editor', function() {
    showGalleryInLessonEditor(this, 'image');
  });
  
  $('body').on('click', '._show_audio_gallery_in_lesson_editor', function() {
    showGalleryInLessonEditor(this, 'audio');
  });
  
  $('body').on('click', '._show_video_gallery_in_lesson_editor', function() {
    showGalleryInLessonEditor(this, 'video');
  });
  
  $('body').on('click', '._close_image_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('image');
  });
  
  $('body').on('click', '._close_video_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('video');
  });
  
  $('body').on('click', '._close_audio_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    removeGalleryInLessonEditor('audio');
  });
  
  $('body').on('click', '._add_image_to_slide', function(e) {
    e.preventDefault();
    var image_id = $(this).data('image-id');
    closePopUp('dialog-image-gallery-' + image_id);
    removeGalleryInLessonEditor('image');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' ._input_image_id').val(image_id);
    $('#' + place_id + ' ._input_align').val('0');
    var image_url = $(this).data('url');
    var image_width = $(this).data('width');
    var image_height = $(this).data('height');
    var full_place = $('#' + place_id + ' ._full_image_in_slide');
    if(full_place.css('display') == 'none') {
      full_place.show();
      $('#' + place_id + ' ._empty_image_in_slide').hide();
    }
    var old_mask = '_mask_x';
    var new_mask = '_mask_y';
    var old_orientation = 'width';
    var orientation = 'height';
    var orientation_val = resizeHeight(image_width, image_height, current_slide.data('kind'));
    var to_make_draggable = 'y';
    if(isHorizontalMask(image_width, image_height, current_slide.data('kind'))) {
      old_mask = '_mask_y';
      new_mask = '_mask_x';
      old_orientation = 'height';
      orientation = 'width';
      orientation_val = resizeWidth(image_width, image_height, current_slide.data('kind'));
      to_make_draggable = 'x';
    }
    full_place.addClass(new_mask).removeClass(old_mask);
    var img_tag = $('#' + place_id + ' ._full_image_in_slide img');
    img_tag.attr('src', image_url);
    img_tag.removeAttr(old_orientation);
    img_tag.attr(orientation, orientation_val);
    makeDraggable(place_id);
  });
  
  $('body').on('click', '._add_video_to_slide', function(e) {
    e.preventDefault();
    var video_id = $(this).data('video-id');
    closePopUp('dialog-video-gallery-' + video_id);
    removeGalleryInLessonEditor('video');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' ._input_video_id').val(video_id);
    var video_mp4 = $(this).data('mp4');
    var video_webm = $(this).data('webm');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' ._full_video_in_slide');
    if(full_place.css('display') == 'none') {
      full_place.show();
      $('#' + place_id + ' ._empty_video_in_slide').hide();
    }
    $('#' + place_id + ' ._full_video_in_slide source[type="video/mp4"]').attr('src', video_mp4);
    $('#' + place_id + ' ._full_video_in_slide source[type="video/webm"]').attr('src', video_webm);
    $('#' + place_id + ' video').load();
    var video_player = $('#' + place_id + ' ._empty_video_player');
    video_player.removeClass('_empty_video_player').addClass('_instance_of_player_' + video_id);
    initializeMedia((video_player.attr('id')), 'video', duration);
    $('#' + place_id + ' ._rolloverable').data('rolloverable', true);
  });
  
  $('body').on('click', '._add_audio_to_slide', function(e) {
    e.preventDefault();
    var audio_id = $(this).data('audio-id');
    closePopUp('dialog-audio-gallery-' + audio_id);
    removeGalleryInLessonEditor('audio');
    var current_slide = $('li._lesson_editor_current_slide');
    var position = $('#info_container').data('current-media-element-position');
    var place_id = 'media_element_' + position + '_in_slide_' + current_slide.data('slide-id');
    $('#' + place_id + ' ._input_audio_id').val(audio_id);
    var audio_mp3 = $(this).data('mp3');
    var audio_ogg = $(this).data('ogg');
    var duration = $(this).data('duration');
    var full_place = $('#' + place_id + ' ._full_audio_in_slide');
    if(full_place.css('display') == 'none') {
      full_place.show();
      $('#' + place_id + ' ._empty_audio_in_slide').hide();
    }
    $('#' + place_id + ' ._full_audio_in_slide source[type="audio/mp3"]').attr('src', audio_mp3);
    $('#' + place_id + ' ._full_audio_in_slide source[type="audio/ogg"]').attr('src', audio_ogg);
    $('#' + place_id + ' audio').load();
    var audio_player = $('#' + place_id + ' ._empty_audio_player');
    audio_player.removeClass('_empty_audio_player').addClass('_instance_of_player_' + audio_id);
    initializeMedia((audio_player.attr('id')), 'audio', duration);
  });
  
  $('body').on('mouseover', '._full_image_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' ._rolloverable');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').show();
    }
  });
  
  $('body').on('mouseout', '._full_image_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' ._rolloverable');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').hide();
    }
  });
  
  $('body').on('focus', '._lesson_editor_placeholder', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
  
});

function removeGalleryInLessonEditor(sti_type) {
  var gallery = $('#' + sti_type + '_gallery');
  var html_content = gallery[0].outerHTML;
  gallery.remove();
  $('#lesson_editor_' + sti_type + '_gallery_container').html(html_content);
  showEverythingOutCurrentSlide();
}

function showGalleryInLessonEditor(obj, sti_type) {
  $('#info_container').data('current-media-element-position', $(obj).data('position'));
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.prepend('<layer class="_not_current_slide_disabled"></layer>');
  hideEverythingOutCurrentSlide();
  var gallery_container = $('#lesson_editor_' + sti_type + '_gallery_container');
  if(gallery_container.data('loaded')) {
    var html_content = gallery_container.html();
    gallery_container.html('');
    current_slide.find('.slide-content').prepend(html_content);
    current_slide.find('layer').remove();
  } else {
    $.ajax({
      type: 'get',
      url: '/lessons/galleries/' + sti_type
    });
  }
}

function showEverythingOutCurrentSlide() {
  var current_slide = $('li._lesson_editor_current_slide');
  $('#slide-numbers').show();
  $('._not_current_slide_disabled').addClass('_not_current_slide').removeClass('_not_current_slide_disabled');
  current_slide.find('.buttons a').css('visibility', 'visible');
}

function hideEverythingOutCurrentSlide() {
  var current_slide = $('li._lesson_editor_current_slide');
  $('#slide-numbers').hide();
  $('._not_current_slide').removeClass('_not_current_slide').addClass('_not_current_slide_disabled');
  current_slide.find('.buttons a:not(._hide_add_slide)').css('visibility', 'hidden');
}

function showNewSlideOptions() {
  stopMediaInCurrentSlide();
  var current_slide_content = $('li._lesson_editor_current_slide .slide-content');
  current_slide_content.removeClass('cover title video1 video2 audio image1 image2 image3 image4 text');
  var html_to_be_replaced = $('#new_slide_option_list').html();
  current_slide_content.prepend(html_to_be_replaced);
  current_slide_content.siblings('.buttons').find('._add_new_slide_options').removeAttr('class').addClass('minusButtonOrange _hide_add_slide _hide_add_new_slide_options');
  hideEverythingOutCurrentSlide();
}

function hideNewSlideChoice() {
  var current_slide = $('li._lesson_editor_current_slide');
  current_slide.find('div.slide-content').addClass(current_slide.data('kind'));
  current_slide.find('.box.new_slide').remove();
  current_slide.find('._hide_add_new_slide_options').removeAttr('class').addClass('addButtonOrange _add_new_slide_options');
  showEverythingOutCurrentSlide();
}

function stopMediaInCurrentSlide() {
  // TODO RIPRISTINARLO  stopMedia('li._lesson_editor_current_slide audio');
  // TODO RIPRISTINARLO  stopMedia('li._lesson_editor_current_slide video');
}

function initializeSortableNavs() {
  $("#heading, #heading .scroll-pane").css("width", (parseInt($(window).outerWidth())-50) + "px");
  slides_numbers = $('#slide-numbers');
  slides_amount = slides_numbers.find("li").length
  slides_numbers.css('width', ''+(parseInt(slides_amount + 1) * 32) + 'px');
  slides_numbers.sortable({
    items: '._slide_nav_sortable',
    axis: 'x',
    stop: function(event, ui) {
      var previous = ui.item.prev();
      var new_position = 0;
      var old_position = parseInt(ui.item.find('a._slide_nav').html());
      if(parseInt(previous.find('a._slide_nav').html()) == 1) {
        new_position = 2;
      } else {
        var previous_item_position = parseInt(previous.find('a._slide_nav').html());
        if(old_position > previous_item_position) {
          new_position = previous_item_position + 1;
        } else {
          new_position = previous_item_position;
        }
      }
      if(old_position != new_position) {
        stopMediaInCurrentSlide();
        saveCurrentSlide();
        $.ajax({
          type: 'post',
          url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + ui.item.find('a._slide_nav').data('slide-id') + '/move/' + new_position
        });
      }
    }
  });
}

function makeDraggable(place_id) {
  var full_place = $('#' + place_id + ' ._full_image_in_slide');
  var axe = 'x';
  if(full_place.hasClass('_mask_y')) {
    axe = 'y';
  }
  var image = $('#' + place_id + '  ._full_image_in_slide img');
  var side = "";
  var maskedImgWidth;
  var maskedImgHeight;
  var dist;
  if(axe == "x") {
    maskedImgWidth = image.attr('width');
    dist = maskedImgWidth - full_place.width();
    side = "left";
  } else {
    maskedImgHeight = image.attr('height');
    side = "top";
    dist = maskedImgHeight - full_place.height();
  }
  $('#' + place_id + ' ._full_image_in_slide ._rolloverable').draggable({
    axis: axe,
    distance: 10,
    start: function() {
      $('#' + place_id + ' ._rolloverable').data('rolloverable', false);
      $('#' + place_id + ' span').hide();
    },
    stop: function() {
      $('#' + place_id + ' ._rolloverable').data('rolloverable', true);
      $('#' + place_id + ' span').show();
      var thisDrag = $(this);
      var offset = thisDrag.css(side);
      if(parseInt(offset) > 0) {
        offset = 0;
        if(side=="left") {
          thisDrag.animate({
            left: "0"
          }, 100);
        } else {
          thisDrag.animate({
            top: "0"
          }, 100);
        }
      } else {
        if(parseInt(offset) < -(parseInt(dist))) {
          offset = -parseInt(dist);
          if(side=="left") {
            thisDrag.animate({
              left: "-" + dist + "px"
            }, 100);
          } else {
            thisDrag.animate({
              top: "-" + dist + "px"
            }, 100);
          }
        }
      }
      $('#' + place_id + ' ._input_align').val(parseInt(offset));
    }
  });
}

function saveCurrentSlide() {
  tinyMCE.triggerSave();
  var temporary = new Array();
  var temp_counter = 0;
  $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      temporary[temp_counter] = $(this).val();
      temp_counter++;
      $(this).val('');
    }
  });
  $('._lesson_editor_current_slide form').submit();
  temp_counter = 0;
  $('._lesson_editor_current_slide ._lesson_editor_placeholder').each(function() {
    if($(this).data('placeholder')) {
      $(this).val(temporary[temp_counter]);
      temp_counter++;
    }
  });
}

function slideTo(slide_id, callback) {
  var slide = $('#slide_in_lesson_editor_' + slide_id);
  if(!slide.hasClass('_lesson_editor_current_slide')) {
    var position = slide.data('position');
    if (position == 1) {
      marginReset = 0;
    } else {
      marginReset = (-((position - 1) * 1010)) + "px";
    }
    $("ul#slides").animate({
      marginLeft: marginReset
    }, 1500, function() {
      if(typeof(callback) != 'undefined') {
        callback();
      }
    });
    $("ul#slides li").animate({
      opacity: 0.4,
    }, 150, function() {
      $(this).find('.buttons').fadeOut();
      if($(this).find('layer').length == 0) {
        $(this).prepend('<layer class="_not_current_slide"></layer>');
      } else {
        if($(this).find('layer._not_current_slide_disabled').length > 0) {
          $(this).find('layer._not_current_slide_disabled').removeClass('_not_current_slide_disabled').addClass('_not_current_slide');
        }
      }
      $('a._lesson_editor_current_slide_nav').removeClass('_lesson_editor_current_slide_nav active');
      $('#slide_in_nav_lesson_editor_' + slide_id).addClass('_lesson_editor_current_slide_nav active');
    });
    $('ul#slides li:eq(' + (position - 1) + ')').animate({
      opacity: 1,
    }, 500, function() {
      $(this).find(".buttons").fadeIn();
      $(this).find('layer').remove();
      $('li._lesson_editor_current_slide').removeClass('_lesson_editor_current_slide active');
      $('#slide_in_lesson_editor_' + slide_id).addClass('_lesson_editor_current_slide active');
    });
  } else {
    if(typeof(callback) != 'undefined') {
      callback();
    }
  }
}

function initLessonEditorPositions() {
  WW = parseInt($(window).outerWidth());
  WH = parseInt($(window).outerHeight());
  $("#main").css("width", WW);
  $("ul#slides").css("width",($("ul#slides li").length * 960) + (2 * WW) );
  $("ul#slides").css("top", ((WH / 2) - 295) + "px");
  $("ul#slides.new").css("top", ((WH / 2) - 335) + "px")
  $("#footer").css("top", (WH - 40) + "px").css("width", (WW - 24) + "px")
  if(WW > 1000) {
    $("ul#slides li:first").css("margin-left", ((WW - 900) / 2) + "px")
    $("ul#slides.new li:first").css("margin-left", ((WW - 900) / 2) + "px");
  }
}

function tinyMceCallbacks(inst){
  if (inst.getBody().scrollHeight > 422) {
    $(inst.getBody()).parentsUntil("table.mceLayout").css("border","1px solid red");
  } else {
    $(inst.getBody()).parentsUntil("table.mceLayout").css("border","1px solid white");
  }
}

function reInitializeSlidePositionsInLessonEditor() {
  $("ul#slides").css("width",($("ul#slides li").length * 960) + (2 * parseInt($(window).outerWidth())) );
  $('ul#slides li').each(function(index){
    $(this).data('position', (index + 1));
  });
}

function initTinymce(tiny_id) {
  tinyMCE.init({
    mode: 'exact',
    elements: tiny_id,
    theme: "advanced",
    editor_selector: "tinymce",
    skin: "desy",
    content_css: "/assets/tiny_mce_desy.css",
    plugins: "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
    theme_advanced_buttons1: "fontsizeselect,forecolor,justifyleft,justifycenter,justifyright,justifyfull,bold,italic,underline,numlist,bullist,link,unlink",
    theme_advanced_toolbar_location: "external",
    theme_advanced_toolbar_align: "left",
    theme_advanced_statusbar_location: false,
    theme_advanced_resizing: true,
    theme_advanced_font_sizes: "1em=.size1,2em=.size2,3em=.size3,4em=.size4,5em=.size5,6em=.size6,7em=.size7",
    setup: function(ed) {
      ed.onKeyUp.add(function(ed, e) {
        tinyMceCallbacks(ed);
      });
      ed.onClick.add(function(ed, e) {
        var textarea = $('#' + tiny_id);
        if(textarea.data('placeholder')) {
          ed.setContent('');
          textarea.data('placeholder', false);
        }
      });
    }
  });
  //TODO Make this work without closing on toolbar click
  //$('body').on("click",".slides.active .slide-content", function(e){
  //  $('.mceExternalToolbar').hide();
  //});
  //$('body').on("click",'textarea.tinymce',function(){
  //  $('.mceExternalToolbar').show();
  //});
}

function imgRealSize(img) {
  var $img = $(img);
  if ($img.prop('naturalWidth') == undefined) {
    var $tmpImg = $('<img/>').attr('src', $img.attr('src'));
    $img.prop('naturalWidth', $tmpImg[0].width);
    $img.prop('naturalHeight', $tmpImg[0].height);
  }
  return { 'width': $img.prop('naturalWidth'), 'height': $img.prop('naturalHeight') }
}

function slideError() {
  $("body").prepend("<span class='_slide_error'></span>");
  centerThis("._slide_error");
  $("._slide_error").fadeTo('fast', 0).fadeTo('fast', 0.7).fadeTo('fast', 0.3).fadeOut();
}

function centerThis(div) {
  var winH = $(window).height();
  var winW = $(window).width();
  var centerDiv = $(div);
  centerDiv.css('top', winH/2-centerDiv.height()/2);
  centerDiv.css('left', winW/2-centerDiv.width()/2);
}

function isHorizontalMask(image_width, image_height, kind){
  var ratio = image_width/image_height;
  var slideRatio = 0;
  switch(kind) {
    case "cover": slideRatio = 1.6;
    break;
    case "image1": slideRatio = 1;
    break;
    case "image2": slideRatio = 0.75;
    break;
    case "image3": slideRatio = 1.55;
    break;
    case "image4": slideRatio = 1.55;
    break;
    default: slideRatio = 1.5;
  }
  return (ratio >= slideRatio);
}

function resizeWidth(width, height, kind){
  switch(kind) {
   case "cover": slideHeight = 560;
   break;
   case "image1": slideHeight = 420;
   break;
   case "image2": slideHeight = 550;
   break;
   case "image3": slideHeight = 550;
   break;
   case "image4": slideHeight = 265;
   break;
   default: slideHeight = 590;
  }
  return (width*slideHeight)/height;
}
  
function resizeHeight(width,height,kind){
  switch(kind) {
   case "cover": slideWidth = 900;
   break;
   case "image1": slideWidth = 420;
   break;
   case "image2": slideWidth = 420;
   break;
   case "image3": slideWidth = 860;
   break;
   case "image4": slideWidth = 420;
   break;
   default: slideWidth = 900;
  }
  return (height*slideWidth)/width;
}
