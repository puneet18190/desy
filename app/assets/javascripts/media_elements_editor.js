$(document).ready(function() {
  var img_container = $("#_image_container");
  $("._toggle_text").click(function(e){
    e.preventDefault;
    $(this).toggleClass("active");
    $("#cropped_image").imgAreaSelect.remove;
    $("._crop_enabled").removeClass("active");
    img_container.addClass("text_enabled").removeClass("crop_enabled");
  });
  
  $("._toggle_crop").click(function(e){
    e.preventDefault;
    $(this).toggleClass("active");
    $("#cropped_image").imgAreaSelect({ 
      handles: true,
      onSelectEnd: function (img, selection) {
        $('input[name="x1"]').val(selection.x1);
        $('input[name="y1"]').val(selection.y1);
        $('input[name="x2"]').val(selection.x2);
        $('input[name="y2"]').val(selection.y2);
      }
    });
    $("._text_enabled").removeClass("active");
    img_container.removeClass("text_enabled").addClass("crop_enabled");
  });
  
  textCount = 0
  $("img").click(function(e){
    coords = getRelativePosition($(this),e);
    textCount = $("#_image_container textarea").length;
    $("#_image_container.text_enabled").append("<div class='image_editor_text' style='position:absolute; z-index:100; left:"+coords[0]+"px;top:"+coords[1]+"px'><a class='_delete'>X<a><a class='_move'><-></a><br /><textarea name='text_"+textCount+"' style='resize:both;' /></div>")
    $('.image_editor_text').draggable({ 
      containment: "parent",
      handle: "._move"
    });
    
    offlightTextarea();
    enlightTextarea($(".image_editor_text textarea:last"));
    
    $(".image_editor_text textarea").focus(function(){
      enlightTextarea($(this));
    });
  
    $("a._delete").click(function(){
      $(this).parents(".image_editor_text").remove();
    });

  });

  
  $("#editor_undo").click(function(e){
    e.preventDefault;
    img_container.find("div.image_editor_text:last").remove();
  });
});

function offlightTextarea(){
  $("._move").css("display","none");
  $("._delete").css("display","none");
  $(".image_editor_text textarea").css("background-color","transparent");
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
  coords.push((event.pageY - posY));
  return coords;
}