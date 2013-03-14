function openAndLoadNextTr(prevTr) {
  var next_tr = prevTr.next('tr.collapsed');
  var thumb = next_tr.find('.element-thumbnail');
  if((thumb.length > 0) && !thumb.data('loaded')) {
    var el_id = next_tr.find('.element-thumbnail').data('param');
    $.ajax({
      url: '/admin/media_elements/' + el_id + '/load',
      type: 'get'
    });
  }
  next_tr.slideToggle('slow');
}

function initNotificationsAutocomplete(){
  $(function() {
    function log( message, _id ) {
      if($('#'+_id).length === 0){
        $( "<div class='label label-info' id="+_id+">" ).text( message ).prependTo( "#log" ).append("<a href='#' class='del'>x</a>");
        $( "#log" ).scrollTop( 0 );
        var dup = $("#contact-recipients").clone();
        $("#contact-recipients").remove();
        $(dup).appendTo('.recipients_input');
        $(dup).val('');
        initNotificationsAutocomplete();
        $("#contact-recipients").focus();
      }
    }
 
    $( "#contact-recipients" ).autocomplete({
      source: "/admin/users/get_full_names",
      minLength: 2,
      select: function( event, ui ) {
        log( ui.item ?
          ui.item.value :
          "No match" , ui.item.id );
      }
    });
  });
}