function addKeepSearching(form) {
  var f = $(form).parents('form');
  f.animate({
    height: '15'
  }, 500, function() {
    f.prepend($('#keep_searching_container').html());
    $('#keep-searching').siblings().hide();
  });
}

function removeKeepSearching(link) {
  var f = $(link).parent('form');
  f.animate({
    height: '210'
  }, 500, function() {
    $('#keep-searching').siblings().show();
    $("#keep-searching").remove();
  });
}
