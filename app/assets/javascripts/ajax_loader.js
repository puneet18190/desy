function bindLoader() {
  showLoader();
  var oldLoad = window.onload;
  var newLoad = function() {
    hideLoader();
  };
  if(oldLoad) {
    newLoad = function() {
      hideLoader();
      oldLoad.call(this);
    };
  }
  window.onload = newLoad;
  $('#loading').bind({
    ajaxStart: function() {
      showLoader();
    },
    ajaxStop: function() {
      hideLoader();
    }
  });
}

function unbindLoader() {
  $('#loading').unbind('ajaxStart ajaxStop');
}

function showLoader() {
  var loader = $('#loading .containerLoading');
  loader.css('top', (($(window).height() / 2) - 100) + 'px');
  loader.css('left', (($(window).width() / 2) - 50) + 'px');
  $('#loading').show();
}

function hideLoader() {
  $('#loading').hide();
}
