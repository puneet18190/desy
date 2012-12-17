$(document).ready(function() {
  var img_container = $("#_image_editor_container");
  
  $("body").on("click","._toggle_text",function(e){
    e.preventDefault;
    $(this).addClass("current");
    $("._toggle_crop").removeClass("current");
    $(".menuServiceImages").hide();
    $(".menuTextImages").show();
    img_container.addClass("text_enabled").removeClass("crop_enabled");
    $("#cropped_image").imgAreaSelect({ 
      hide: true,
      disable: true
    });
    resetSelect();
  });
  
  $("body").on("click","._toggle_crop",function(e){
    e.preventDefault;
    $(this).addClass("current");
    $("._toggle_text").removeClass("current");
    $(".menuServiceImages").show();
    $(".menuTextImages").hide();
    img_container.removeClass("text_enabled").addClass("crop_enabled");
    offlightTextarea();
    $("#cropped_image").imgAreaSelect({ 
      enable: true,
      handles: true,
      onSelectEnd: function (img, selection) {
        $('input[name="x1"]').val(selection.x1);
        $('input[name="y1"]').val(selection.y1);
        $('input[name="x2"]').val(selection.x2);
        $('input[name="y2"]').val(selection.y2);
      }
    });
  });
  
  $("body").on("click","#_editor_crop",function(){
   //updateCrop(); #TODO implement client_side fake crop
   var thisForm = $("form#_crop_form");
   thisForm.attr("action","/images/"+thisForm.data("param")+"/crop");
   thisForm.submit();
  });
  
  $("body").on("click","#_image_editor_container img",function(e){
    this_image = $(this);
    coords = getRelativePosition(this_image,e);
    textCount = $("#_image_editor_container textarea").length;
    $("#_image_editor_container.text_enabled").append(textAreaContent(coords,textCount));
    
    $('.image_editor_text').draggable({ 
      containment: "parent",
      handle: "._move",
      start: function() {
        $(this).find("._move").css("cursor","-webkit-grabbing");
      },
      stop: function(event) {
        $(this).find("._move").css("cursor","-webkit-grab");
        coords = getDragPosition($(this));
        console.log("getCords: "+coords);
        $(this).children("textarea").data("coords",coords[0]+","+coords[1]);
        console.log("dataCords: "+$(this).children("textarea").data("coords"));
      }
    });
    
    offlightTextarea();
    enlightTextarea($(".image_editor_text textarea:last"));
    
    $(".image_editor_text textarea").focus(function(){
      offlightTextarea();
      enlightTextarea($(this));
    });
  
    $("a._delete").click(function(){
      img_editor = $(this).parents(".image_editor_text");
      img_editor.remove();
      console.log(img_editor.attr("id"));
      $("#_crop_form input."+img_editor.attr("id").replace("text","area")).each(function(){
        $(this).remove();
      });
    });
    
    $(".text_tools div a").click(function(){
      //variable init
      var thisLink = $(this);
      var thisParent = $(this).parent("div");
      var thisTextTools = $(this).parents(".text_tools");
      var thisTextArea = thisTextTools.parent(".image_editor_text").find("textarea");
      
      //textarea updates
      thisParent.find("a").removeClass("current");
      thisLink.addClass("current");
      thisTextArea.removeAttr("class");
      
      if(thisParent.attr("class") == "font_sizes"){
        
        var font_val = $(this).attr("class").replace(" current","");
        var font_size = $(this).data("param");
        var color_class = thisTextTools.find(".text_colors a.current").attr("class");

        thisTextArea.addClass(font_val);
        thisTextArea.addClass(color_class.replace('background_','').replace('current','').replace(' ',''));        
        thisTextArea.attr("data-size",font_size);
        
      } else {
        
        var color_val = $(this).attr("class").replace('background_','').replace('current','').replace(' ','');
        var font_class = thisTextTools.find(".font_sizes a.current").attr("class");

        thisTextArea.addClass(color_val);
        thisTextArea.addClass(font_class.replace('current',''));        
        thisTextArea.attr("data-color",color_val);
      }

    });
    
  });
  
  $("body").on("click","#_editor_cancel",function(e){
    e.preventDefault;
    $("#cropped_image").imgAreaSelect({ 
      hide: true
    });
    resetSelect();
  });
  
  $("body").on("click","#image_editor_not_public ._save_edit_image", function(){
    var image_id = $(this).data("slide-id");
    saveImageChoice(image_id);
  });
  
  $("body").on("click","#image_editor_public ._save_edit_image", function(){
    var image_id = $(this).data("slide-id");
    $('#form_info_new_media_element_in_editor').show();
  });
  
  $('body').on('click','#form_info_new_media_element_in_editor ._commit', function(){
    commitImageEditing("new");
  });
  
  $('body').on('click','#form_info_update_media_element_in_editor ._commit', function(){
    commitImageEditing("overwrite");
  });
  
  $('body').on('click','#form_info_new_media_element_in_editor ._cancel', function(){
    $('#form_info_new_media_element_in_editor').hide();
    $('._save_edit_image').show();
  });
  
  $('body').on('click','#form_info_new_media_element_in_editor._title_reset ._cancel', function(){
    $('._titled').show();
    $('._untitled').hide();
  });
  
  $('body').on('click','#form_info_update_media_element_in_editor ._cancel', function(){
    $('#form_info_update_media_element_in_editor').hide();
    $('._save_edit_image').show();
  });
  
});

function commitImageEditing(new_or_overwrite){
  processTextAreaForm();
  var thisForm = $("form#_crop_form");
  thisForm.attr("action","/images/"+thisForm.data("param")+"/commit/"+new_or_overwrite);
  thisForm.submit();
}

function saveImageChoice(image_id) {
  var title = $('.header h1 span');
  showConfirmPopUp(title.text(), "Update or create new image", "update", "new", function() {
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
    $('#form_info_new_media_element_in_editor').addClass("_title_reset");
    closePopUp('dialog-confirm');
  });
}

function resizedValue(width,height){
  wrapper_ratio = 660/495;
  original_ratio = width/height;
  resized= ["w","h","zoom"];
  if(original_ratio >= wrapper_ratio){
    //resized width is 660
    r_h = 660*height/width 
    r_zoom = width/660
    resized=[660,r_h,r_zoom]
  }else{
    //resized height 495
    r_w = 495*width/height
    r_zoom = height/495
    resized=[r_w,495,r_zoom]
  }
  return resized;
}

// Update form with textareas
function processTextAreaForm(){
  $("#_image_editor_container .image_editor_text textarea").each(function(index){
    var tarea = $(this);
    addTextAreaHiddenFields(tarea.data("color"), tarea.data("size"), tarea.data("coords"), tarea.val(), index);
  });
}


//TODO ADD COLOR AND FONT SIZE
function addTextAreaHiddenFields(color, size, coords, text, index){
  hidden_input_coords = "<input type='hidden' class='area_"+index+"' id='hidden_coords_"+index+"' name='coords_"+index+"' value='"+coords+"' />"
  hidden_input_text = "<input type='hidden' class='area_"+index+"' id='hidden_text_"+index+"' name='text_"+index+"' value='"+text+"' />"
  hidden_input_color = "<input type='hidden' class='area_"+index+"' id='hidden_color_"+index+"' name='color_"+index+"' value='"+color+"' />"
  hidden_input_font = "<input type='hidden' class='area_"+index+"' id='hidden_font_"+index+"' name='font_"+index+"' value='"+size+"' />"
  $("#_crop_form").prepend(hidden_input_coords).prepend(hidden_input_text).prepend(hidden_input_color).prepend(hidden_input_font);
}

//TODO ADD COLOR AND FONT SIZE
function textAreaContent(coords,textCount){
  var textarea = "<textarea id='area_"+textCount+"' data-coords='"+coords[2]+","+coords[3]+"' data-color='color_black' data-size='20' name='text_"+textCount+"' class='color_black small_font' />";
  var colors = "<div class='text_colors'><a class='background_color_white'></a><a class='background_color_black current'></a><a class='background_color_red'></a><a class='background_color_orange'></a><a class='background_color_light_blue'></a><a class='background_color_green'></a></div>"
  var fontSize = "<div class='font_sizes'><a class='small_font current' data-param='20'>A</a><a class='medium_font' data-param='31'>A</a><a class='big_font' data-param='40'>A</a></div>"
  div = $("<div />",
  {
    class: "image_editor_text",
    id: "text_"+textCount,
    css: {
        position : "absolute",
        "z-index" : "100",
        left : coords[0],
        top : coords[1]
    }
  }).html("<div class='text_tools' id='area_tools_"+textCount+"'><a class='_delete closeButton closeButtonSmall'></a>"+colors+fontSize+"<a class='_move'></a></div>").append(textarea);
  
  return div;
}

function offlightTextarea(){
  $(".text_tools").css('visibility','hidden');
  $(".image_editor_text textarea").css("background-color","rgba(255,255,255,0)");
}

function enlightTextarea(obj){
  var tarea = obj;
  var tools = tarea.siblings(".text_tools");

  tools.css('visibility','visible');
  tarea.css("background-color","rgba(230,230,230,0.5)");

  updateValueOnKey(tarea);
}

function updateValueOnKey(textarea){
  var name = textarea.attr("name");
  textarea.keyup(function(){
    $("form#_crop_form input#hidden_"+ name).val(textarea.val());
  });
}

function getRelativePosition(obj,event){
  //obj is the image, event the click position
  var posX = obj.offset().left, posY = obj.offset().top;
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY)+25); //padding + 25
  console.log(coords[0]+","+coords[1]+","+coords[2]+","+coords[3]);
  return coords;
}

function getDragPosition(obj){
  //obj is the textarea box
  var imgOff = $("#image_wrapper").children("img").offset();
  var imgOffX = imgOff.left;
  var imgOffY = imgOff.top;
  var offX = obj.children("textarea").offset().left, offY = (obj.children("textarea").offset().top);

  coords = []
  coords.push(offX-imgOffX);
  coords.push(offY-imgOffY); //textarea top padding

  return coords;
}

function resetSelect(){
  $('input[name="x1"]').val("");
  $('input[name="y1"]').val("");
  $('input[name="x2"]').val("");
  $('input[name="y2"]').val("");
}


//// TODO: Use client side crop ////
function updateCrop() {
  //var wrapper = $("#image_wrapper");
  //var image = $("#_image_editor_container img");
  //var x1 = $('input[name="x1"]').val();
  //var y1 = $('input[name="y1"]').val();
  //var x2 = $('input[name="x2"]').val();
  //var y2 = $('input[name="y2"]').val();
  //var selWidth = x2-x1;
  //var selHeight = y2-y1;
  //var selRatio = selWidth/selHeight;
  //
  //var origin_w = image.attr("data-width");
  //var origin_h = image.attr("data-height");
  //var resValue = resizedValue(origin_w,origin_h);
  //var resWidth = resValue[0];
  //var resHeight = resValue[1];
  //var resZoom = resValue[2]; //initial zoom resize
  //var resRatio = resWidth/resHeight;
  //  
  //var totalZoom = resZoom;
  //var leftOffset = 0;
  //var topOffset = 0;
  //
  ////define zoom ratio based on longest side
  //if(selRatio > 1,33){
  //  zoomVal = resWidth/selWidth;
  //}else{
  //  zoomVal = resHeight/selHeight;
  //}
  //
  //totalZoom = totalZoom*zoomVal;
  //var leftOffset = resWidth-x1;
  //var topOffset = resWidth-y1;
  //
  //console.log("resZoom: "+resZoom+" totalZ: "+totalZoom+"actual zoom: "+zoomVal);
  //console.log("x1: "+ x1+" resW: "+resWidth+" leftOff: "+leftOffset);
  //console.log("y1: "+ y1+" resH: "+resHeight+"topOff: "+topOffset);
  //
  //image.css({"zoom":resZoom,"margin-left":"-"+(x1)+"px","margin-top":"-"+(y1)+"px"});
  //wrapper.css({"width":selWidth*zoomVal+"px","height":selHeight*zoomVal+"px"})
  //
  //$("#cropped_image").imgAreaSelect({ 
  //  hide: true
  //});
  //
  //image.css({
  //  transform: scale(mult),
  //  -ms-transform: scale(mult), /* IE 9 */
  //  -webkit-transform: scale(mult), /* Safari and Chrome */
  //  -o-transform: scale(mult), /* Opera */
  //  -moz-transform: scale(mult) /* Firefox */
  //});
  
  //var scaleX = 100 / (selection.width || 1);
  //var scaleY = 100 / (selection.height || 1);
  //
  //$('img').css({
  //    width: Math.round(scaleX * 400) + 'px',
  //    height: Math.round(scaleY * 300) + 'px',
  //    marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
  //    marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
  //});
}
