$(document).ready(function() {
  var img_container = $("#_image_container");
  
  $("._toggle_text").click(function(e){
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
  });
  
  $("._toggle_crop").click(function(e){
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
  
  $("#_editor_crop").click(function(){
    $("form#_crop_form").submit();
  });
  
  textCount = 0
  $("img").click(function(e){
    this_image = $(this);
    coords = getRelativePosition(this_image,e);
    textCount = $("#_image_container textarea").length;
    $("#_image_container.text_enabled").append(textAreaContent(coords,textCount));
    addTextAreaHiddenFields(coords, textCount);
    $('.image_editor_text').draggable({ 
      containment: "parent",
      handle: "._move",
      start: function() {
        $(this).find("._move").css("cursor","-webkit-grabbing");
      },
      stop: function(e) {
        $(this).find("._move").css("cursor","-webkit-grab");
        console.log(e.pageX+"/"+e.pageY);
      }
    });
    
    offlightTextarea();
    enlightTextarea($(".image_editor_text textarea:last"));
    
    $(".image_editor_text textarea").focus(function(){
      offlightTextarea();
      enlightTextarea($(this));
    });
  
    $("a._delete").click(function(){
      img_editor = $(this).parents(".image_editor_text")
      img_editor.remove();
      console.log(img_editor.attr("id"));
      $("#_crop_form input#hidden_"+img_editor.attr("id")).remove();
    });
    
    $(".text_tools div a").click(function(){
      //variable init
      var thisLink = $(this);
      var thisParent = $(this).parent("div");
      var thisTextTools = $(this).parents(".text_tools");
      var thisTextArea = thisTextTools.parent(".image_editor_text").find("textarea");
      var thisHiddenColor = $("form#_crop_form input#hidden_"+thisTextArea.attr("name").replace("text","color"));
      var thisHiddenFont = $("form#_crop_form input#hidden_"+thisTextArea.attr("name").replace("text","font"));
      
      //textarea updates
      thisParent.find("a").removeClass("current");
      thisLink.addClass("current");
      thisTextArea.removeAttr("class");
      
      thisTextTools.find("a.current").each(function(){
        if(thisParent.attr("class") == "font_sizes"){
          var font_val = $(this).attr("class").replace('background_','').replace('current','').replace(' ','');
          thisTextArea.addClass(font_val);
          thisTextArea.attr("data-size",font_val);
          thisHiddenFont.val(font_val);
        } else {
          var color_val = $(this).attr("class").replace('background_','').replace('current','').replace(' ','');
          thisTextArea.addClass(color_val)
          thisTextArea.attr("data-color",color_val);
          thisHiddenColor.val(color_val);
        }
      });
    });
    
  });
  
  $("#_editor_cancel").click(function(e){
    e.preventDefault;
    $("#cropped_image").imgAreaSelect({ 
      hide: true
    });
    //img_container.find("div.image_editor_text:last").remove();
  });
});



//TODO ADD COLOR AND FONT SIZE
function addTextAreaHiddenFields(coords, textCount){
  hidden_input_coords = "<input type='hidden' id='hidden_coords_"+textCount+"' name='coords_"+textCount+"' value='"+coords[2]+","+coords[3]+"' />"
  hidden_input_text = "<input type='hidden' id='hidden_text_"+textCount+"' name='text_"+textCount+"' value='' />"
  hidden_input_color = "<input type='hidden' id='hidden_color_"+textCount+"' name='color_"+textCount+"' value='' />"
  hidden_input_font = "<input type='hidden' id='hidden_font_"+textCount+"' name='font_"+textCount+"' value='' />"
  $("#_crop_form").prepend(hidden_input_coords).prepend(hidden_input_text).prepend(hidden_input_color).prepend(hidden_input_font);
}

//TODO ADD COLOR AND FONT SIZE
function textAreaContent(coords,textCount){
  var textarea = "<textarea id='area_"+textCount+"' name='text_"+textCount+"' style='resize:both;' data-coords='"+coords[2]+","+coords[3]+"' data-color='' data-size='' />";
  var colors = "<div class='text_colors'><a class='background_color_white'></a><a class='background_color_black'></a><a class='background_color_red'></a><a class='background_color_yellow'></a><a class='background_color_blue'></a><a class='background_color_green'></a></div>"
  var fontSize = "<div class='font_sizes'><a class='small_font'>A</a><a class='medium_font'>A</a><a class='big_font'>A</a></div>"
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
  console.log(name);
  textarea.keydown(function(){
    console.log("keydown");
    console.log(textarea.val());
    $("form#_crop_form input#hidden_"+ name).val(textarea.val());
  });
}

function updateRelativePosition(x_y,event){
  //obj is the image, event the click position
  var posX = obj.offset().left, posY = obj.offset().top;
  console.log("offset.left(posX): " +posX+ " offset.top(posY)"+posY);
  console.log("position.left: "+obj.position().left+"position.top: "+obj.position().top+ " event X,Y: " +event.pageX + "," +event.pageY);
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY)+20);
  console.log(coords[0]+","+coords[1]+","+coords[2]+","+coords[3]);
  return coords;
}

function getRelativePosition(obj,event){
  //obj is the image, event the click position
  var posX = obj.offset().left, posY = obj.offset().top;
  console.log("offset.left(posX): " +posX+ " offset.top(posY)"+posY);
  console.log("position.left: "+obj.position().left+"position.top: "+obj.position().top+ " event X,Y: " +event.pageX + "," +event.pageY);
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY)+20);
  console.log(coords[0]+","+coords[1]+","+coords[2]+","+coords[3]);
  return coords;
}