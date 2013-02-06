function bindLoader() {
  var loader = $('#loading .containerLoading');
  loader.css('top', (($(window).height() / 2) - 100) + 'px');
  loader.css('left', (($(window).width() / 2) - 50) + 'px');
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
  $('#loading').bind({
    ajaxStart: function() {
      var this_loader = $(this).find('.containerLoading');
      this_loader.css('top', (($(window).height() / 2) - 100) + 'px');
      this_loader.css('left', (($(window).width() / 2) - 50) + 'px');
      $(this).show();
    },
    ajaxStop: function() {
      $(this).hide();
    }
  });
}

function unbindLoader() {
  $('#loading').unbind('ajaxStart ajaxStop');
}
