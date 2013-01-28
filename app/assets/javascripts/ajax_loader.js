function bindLoader(){
  $('#loading .containerLoading').css("top", (($(window).height()/2)-100)+"px");
  $('#loading .containerLoading').css("left", (($(window).width()/2)-50)+"px");
  $('#loading').show();
  var oldLoad = window.onload;
  var newLoad = function() {
    $('#loading').hide();
  };
  if(oldLoad) {
    newLoad = function() {
      $('#loading').hide();
      oldLoad.call(this);
    };
  }
  window.onload = newLoad;

  $("#loading").bind({
    ajaxStart: function() {
      $(this).find('.containerLoading').css("top", (($(window).height()/2)-100)+"px");
      $(this).find('.containerLoading').css("left", (($(window).width()/2)-50)+"px");
      $(this).show();
    },
    ajaxStop: function() {
      $(this).hide();
    }
  });
}

function unbindLoader(){
  $("#loading").unbind("ajaxStart ajaxStop");
}