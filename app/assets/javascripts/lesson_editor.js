$(document).ready(function() {
  
  $("html.lesson-editor-layout ul#slides").css("margin-top", ($(window).height() - 590)/2 + "px");
  $('#info_container').data('current-media-element-position', 1); // FIXME DUBBIO?????
  
  initializeLessonEditor();
  
  $('#lesson_subject').selectbox();
  
  $('body').on('mouseover', '#slide-numbers li:not(._add_new_slide_options_in_last_position)', function(e) {
    tip = $(this);
    x = e.pageX - tip.offset().left;
    y = e.pageY - tip.offset().top;
    tip.children('.slide-tooltip').show();
  });
  
  $('body').on('mouseout', '#slide-numbers li:not(._add_new_slide_options_in_last_position)', function(e) {
    $(this).children('.slide-tooltip').hide();
  });
  
  $('body').on('click', '._slide_nav:not(._lesson_editor_current_slide_nav), ._not_current_slide', function(e) {
    e.preventDefault();
    saveCurrentSlide();
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
    var kind = $(this).data('kind');
    var lesson_id = $('#info_container').data('lesson-id');
    var slide_id = $('li._lesson_editor_current_slide').data('slide-id');
    console.log("kind: "+kind);
    console.log("lesson_id: "+lesson_id);
    console.log("slide_id: "+slide_id);
    $.ajax({
      type: 'post',
      url: '/lessons/' + lesson_id + '/slides/' + slide_id + '/kind/' + kind + '/create/'
    });
  });
  
  $('body').on('click', '._show_image_gallery_in_lesson_editor', function() {
    $('#info_container').data('current-media-element-position', $(this).data('position'));
    if($('#image_gallery').length == 0) {
      $.ajax({
        type: 'get',
        url: '/lessons/galleries/image'
      });
    } else {
      $('#image_gallery').show();
    }
  });
  
  $('body').on('click', '._show_audio_gallery_in_lesson_editor', function() {
    $('#info_container').data('current-media-element-position', $(this).data('position'));
    $.ajax({
      type: 'get',
      url: '/lessons/galleries/audio'
    });
  });
  
  $('body').on('click', '._show_video_gallery_in_lesson_editor', function() {
    $('#info_container').data('current-media-element-position', $(this).data('position'));
    if($('#video_gallery').length == 0) {
      $.ajax({
        type: 'get',
        url: '/lessons/galleries/video'
      });
    } else {
      $('#video_gallery').show();
    }
  });
  
  $('body').on('click', '._close_image_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    $('#image_gallery').hide();
    enableSlidesInLessonEditor();
  });
  
  $('body').on('click', '._close_video_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    $('#video_gallery').hide();
    enableSlidesInLessonEditor();
  });
  
  $('body').on('click', '._close_audio_gallery_in_lesson_editor', function(e) {
    e.preventDefault();
    $('#audio_gallery').hide();
    enableSlidesInLessonEditor();
  });
  
  $('body').on('click', '._add_image_to_slide', function(e) {
    e.preventDefault();
    var slide_id = $('li._lesson_editor_current_slide').data('slide-id');
    var kind = $('#info_container').data('kind');
    var position = $('#info_container').data('current-media-element-position');
    var image_id = $(this).data('image-id');
    $('#slide_in_lesson_editor_' + slide_id).children().show();
    var place_id = 'media_element_' + position + '_in_slide_' + slide_id;
    $('#' + place_id + ' ._input_image_id').val(image_id);
    $('#' + place_id + ' ._input_align').val('0');
    closePopUp('dialog-image-gallery-' + image_id);
    $('#image_gallery').hide();
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
    var orientation_val = resizeHeight(image_width, image_height, kind);
    var to_make_draggable = 'y';
    if(isHorizontalMask(image_width, image_height, kind)) {
      old_mask = '_mask_y';
      new_mask = '_mask_x';
      old_orientation = 'height';
      orientation = 'width';
      orientation_val = resizeWidth(image_width, image_height, kind);
      to_make_draggable = 'x';
    }
    full_place.addClass(new_mask).removeClass(old_mask);
    var img_tag = $('#' + place_id + ' ._full_image_in_slide img');
    img_tag.attr('src', image_url);
    img_tag.removeAttr(old_orientation);
    img_tag.attr(orientation, orientation_val);
    $("#slide-numbers").show();
    $('#slide_in_lesson_editor_' + slide_id).siblings(".buttons").show();
    $('#' + place_id + ' span').show();
    makeDraggable(place_id);
  });
  
  $('body').on('click', '._add_video_to_slide', function(e) {
    e.preventDefault();
    var slide_id = $('li._lesson_editor_current_slide').data('slide-id');
    var kind = $('#info_container').data('kind');
    var position = $('#info_container').data('current-media-element-position');
    var video_id = $(this).data('video-id');
    var video_mp4 = $(this).data('mp4');
    var video_webm = $(this).data('webm');
    $('#slide_in_lesson_editor_' + slide_id).children().show();
    var place_id = 'media_element_' + position + '_in_slide_' + slide_id;
    $('#' + place_id + ' ._input_video_id').val(video_id);
    closePopUp('dialog-video-gallery-' + video_id);
    $("#video_gallery").hide();
    var full_place = $('#' + place_id + ' ._full_video_in_slide');
    if(full_place.css('display') == 'none') {
      full_place.show();
      $('#' + place_id + ' ._empty_video_in_slide').hide();
    }
    $('#' + place_id + ' ._full_video_in_slide source[type="video/mp4"]').attr('src', video_mp4);
    $('#' + place_id + ' ._full_video_in_slide source[type="video/webm"]').attr('src', video_webm);
    $('#' + place_id + ' video').load();
    $("#slide-numbers").show();
    $('#slide_in_lesson_editor_' + slide_id).siblings(".buttons").show();
  });
  
  $('body').on('mouseover', '._full_image_in_slide, ._full_audio_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' a');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').show();
    }
  });
  
  $('body').on('mouseout', '._full_image_in_slide, ._full_audio_in_slide, ._full_video_in_slide', function() {
    var obj = $('#' + $(this).parent().attr('id') + ' a');
    var slide_id = obj.data('slide-id');
    var position = obj.data('position');
    if(obj.data('rolloverable')) {
      $('#media_element_' + position + '_in_slide_' + slide_id + ' ._lesson_editor_rollover_content').hide();
    }
  });
  
});

function showNewSlideOptions() {
  $('#slide-numbers').hide();
  var slideN = $('li._lesson_editor_current_slide .slide-content');
  slideN.removeClass('cover title video1 video2 audio image1 image2 image3 image4 text');
  var html_to_be_replaced = $('#new_slide_option_list').html();
  slideN.prepend(html_to_be_replaced);
  var activeButton = slideN.siblings('.buttons');
  activeButton.find('._add_new_slide_options').removeAttr('class').addClass('minusButtonOrange _hide_add_slide _hide_add_new_slide_options');
  activeButton.find('a:not(._hide_add_slide)').css('visibility', 'hidden');
  $('._not_current_slide').removeClass('_not_current_slide').addClass('_not_current_slide_disabled');
}

function hideNewSlideChoice() {
  $('#slide-numbers').show();
  var activeSlide = $('li._lesson_editor_current_slide');
  activeSlide.find('div.slide-content').addClass(activeSlide.data('kind'));
  activeSlide.find('.box.new_slide').remove();
  activeSlide.find('._hide_add_new_slide_options').removeAttr('class').addClass('addButtonOrange _add_new_slide_options');
  activeSlide.find('.buttons a').css('visibility', 'visible');
  $('._not_current_slide_disabled').addClass('_not_current_slide').removeClass('_not_current_slide_disabled');
}

function initializeLessonEditor() {
  initTinymce();
  $('._image_container_in_lesson_editor').each(function() {
    makeDraggable($(this).attr('id'));
  });
  initializeSortableNavs();
  $(".slide-content.cover .title").css("margin-left", "auto");
  initLessonEditorPositions();
}

function initializeSortableNavs() {
  $('#slide-numbers').sortable({
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
        saveCurrentSlide();
        $.ajax({
          type: 'post',
          url: '/lessons/' + $('#info_container').data('lesson-id') + '/slides/' + ui.item.find('a._slide_nav').data('slide-id') + '/move/' + new_position
        });
      }
    }
  });
}

function enableSlidesInLessonEditor() {
  var slide_id = $('li._lesson_editor_current_slide').data('slide-id');
  var current_slide = $('#slide_in_lesson_editor_' + slide_id);
  current_slide.siblings(".buttons").show();
  $("#slide-numbers").show();
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
  $('#' + place_id + ' ._full_image_in_slide a').draggable({
    axis: axe,
    distance: 10,
    start: function() {
      $('#' + place_id + ' a').data('rolloverable', false);
      $('#' + place_id + ' span').hide();
    },
    stop: function() {
      $('#' + place_id + ' a').data('rolloverable', true);
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
  $('._lesson_editor_current_slide form').submit();
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

function initTinymce() {
  tinyMCE.init({
    mode : "textareas",
    theme : "advanced",
    editor_selector : "tinymce",
    skin : "desy",
    content_css : "/assets/tiny_mce_desy.css",
    plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
    theme_advanced_buttons1 : "fontsizeselect,forecolor,justifyleft,justifycenter,justifyright,justifyfull,bold,italic,underline,numlist,bullist,link,unlink",
    theme_advanced_toolbar_location : "external",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : false,
    theme_advanced_resizing : true,
    theme_advanced_font_sizes : "1em=.size1,2em=.size2,3em=.size3,4em=.size4,5em=.size5,6em=.size6,7em=.size7",
    setup : function(ed) {
      ed.onKeyUp.add(function(ed, e) {
        tinyMceCallbacks(ed);
      });
   }
  });
  
  $('body:not(textarea.tinymce)').click(function(e){
    //console.log($(e.target).parentsUntil(".mceExternalToolbar"));
    //$(e.target).parentsUntil(".mceExternalToolbar").fadeOut();
    $('.mceExternalToolbar').hide();
  });
  
  $('textarea.tinymce').click(function(){
    $('.mceExternalToolbar').show();
  });
  
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

function slideError(){
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

function isHorizontalMask(image_width,image_height,kind){
  var ratio = image_width/image_height;
  var slideRatio = 0;
  switch(kind)
  {
    case "cover": slideRatio = 1.6;
    break;
    case "image1": slideRatio = 1.05;
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


function resizeWidth(width,height,kind){
  switch(kind)
  {
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
  switch(kind)
  {
     case "cover": slideWidth = 900;
     break;
     case "image1": slideWidth = 440;
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
