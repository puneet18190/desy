$(document).ready(function() {
  $("._toggle_text").click(function(e){
    e.preventDefault;
    $(this).toggleClass("active");
    $("#cropped_image").imgAreaSelect.remove;
    $("._crop_enabled").removeClass("active");
    $("#image_container").addClass("text_enabled").removeClass("crop_enabled");
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
    $("#image_container").removeClass("text_enabled").addClass("crop_enabled");
  });
  
  textCount = 0
  $("img").click(function(e){
    coords = getRelativePosition($(this),e);
    textCount = $("#image_container textarea").length;
    console.log("Co: "+coords[0]+" - "+coords[1]);
    console.log("#: "+textCount);
    $("#image_container.text_enabled").prepend("<textarea name='text_"+textCount+"' style='resize:both;position:absolute; z-index:100; left:"+coords[0]+"px;top:"+coords[1]+"px'/>")
  });
});

function getRelativePosition(obj,event){
  var posX = obj.offset().left, posY = obj.offset().top;
  coords = []
  coords.push((event.pageX - posX));
  coords.push((event.pageY - posY));
  return coords;
}