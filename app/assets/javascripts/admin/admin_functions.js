function openAndLoadNextTr(prevTr) {
  var next_tr = prevTr.next('tr.collapsed');
  var thumb = next_tr.find('.element-thumbnail');
  if((thumb.length > 0) && (thumb.html().length == 0)){
    var el_id = next_tr.find('.element-thumbnail').data('param');
    $.ajax({
      url: '/admin/media_elements/' + el_id + '/load',
      type: 'get'
    });
  }
  next_tr.slideToggle('slow');
}
