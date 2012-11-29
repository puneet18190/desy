$(document).ready(function() {
  var img_container = $("#_image_container");
  
  $("._toggle_text").click(function(e){
    console.log("toggled text");
    e.preventDefault;
    $(this).addClass("current");
    $("._toggle_crop").removeClass("current");
    img_container.addClass("text_enabled").removeClass("crop_enabled");
    $("#cropped_image").imgAreaSelect({ 
      hide: true,
      disable: true
    });
  });
  
  $("._toggle_crop").click(function(e){
    console.log("toggled crop");
    e.preventDefault;
    $(this).addClass("current");
    $("._toggle_text").removeClass("current");
    img_container.removeClass("text_enabled").addClass("crop_enabled");

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
  
  $("#editor_crop").click(function(){
    $("form#_crop_form").submit();
  });
  
  textCount = 0
  activateImageTextareas();
  
  $("#editor_undo").click(function(e){
    e.preventDefault;
    img_container.find("div.image_editor_text:last").remove();
  });
});

function activateImageTextareas(){
  $("img").click(function(e){
    coords = getRelativePosition($(this),e);
    textCount = $("#_image_container textarea").length;
    $("#_image_container.text_enabled").append(textAreaContent(coords,textCount));
    addTextAreaHiddenFields(coords, textCount);
    $('.image_editor_text').draggable({ 
      containment: "parent",
      handle: "._move"
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

  });
  
}

//TODO ADD COLOR AND FONT SIZE
function addTextAreaHiddenFields(coords, textCount){
  hidden_input = "<input type='hidden' id='hidden_text_"+textCount+"' name='text_"+textCount+","+coords[2]+","+coords[3]+"' value='' />"
  $("#_crop_form").prepend(hidden_input);
}

//TODO ADD COLOR AND FONT SIZE
function textAreaContent(coords,textCount){
  var textarea = "<textarea name='text_"+textCount+"' style='resize:both;' data-coords='"+coords[2]+","+coords[3]+"' data-font='' data-size='' />";
  
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
  }).html("<a class='_delete'>X</a><a class='_move'><-></a><br />").append(textarea);
  
  return div;
}

function offlightTextarea(){
  $("._move").css("display","none");
  $("._delete").css("display","none");
  $(".image_editor_text textarea").css("background-color","rgba(255,255,255,0)");
}

function enlightTextarea(obj){
  var tarea = obj;
  var mo = tarea.siblings("._move");
  var de = tarea.siblings("._delete");
  
  mo.css("display","block");
  de.css("display","block");
  tarea.css("background-color","rgba(230,230,230,0.5)");
}

function getRelativePosition(obj,event){
  var posX = obj.offset().left, posY = obj.offset().top;
  coords = []
  coords.push(event.pageX);
  coords.push(event.pageY);
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY)+20);
  return coords;
}