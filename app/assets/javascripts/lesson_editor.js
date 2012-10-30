$(document).ready(function() {
  WW = parseInt($(window).outerWidth());
  WH = parseInt($(window).outerHeight());
  $("#main").css("width", WW);
  $("ul#slides").css("width",$("ul#slides li").length * 1000);
  $("#footer").css("top",(WH-40)+"px").css("width",(WW-24)+"px")
  if(WW > 1000){
    $("ul#slides li:first").css("margin-left", ((WW-900) / 2) + "px")
  }

  $('#slide-numbers li').hover(function(e) {
     tip = $(this); 
     // Calculate the position of the image tooltip
     x = e.pageX - tip.offset().left;
     y = e.pageY - tip.offset().top;
     
     tip.children('.tooltip').animate({"opacity": "show"}, "fast");
     
     }, function() {
       // Reset the z-index and hide the image tooltip 
         $(this).children('.tooltip').animate({"opacity": "hide"}, "fast");
     });
  
  $('#slide-numbers li a').click(function(){
    page = $(this).text();
    if (parseInt(page) == 1){
      console.log("page1");
      marginReset = 0
    }else{
      console.log("pageNot1");
      marginReset = parseInt(-((page-1)*950))+"px"
    }
    $("ul#slides").animate({
        marginLeft: marginReset
      }, 1500 );
    $("ul#slides li").animate({
        opacity: 0.4,
      }, 150 );
    $("ul#slides li:nth-child("+page+")").animate({
        opacity: 1,
      }, 500 );
    //$("ul#slides").css("margin-left", parseInt(-((page-1)*900))+"px");
    $("#slide-numbers li a.active").removeClass("active");
    $(this).addClass("active");
  });
});