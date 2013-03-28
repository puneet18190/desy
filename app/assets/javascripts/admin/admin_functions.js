/**
* Administration graphic events and flagging options.
* 
* @module Administration
*/

/**
* Open a collapsed table row with extra content,
* tipically clicking on previous collapsable table row.
* 
* @method openAndLoadNextTr
* @for openAndLoadNextTr
* @param prevTr {Object}
*/
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

/**
* Initializer for jQueryUI autocomplete on users serch into Admin Notifications.
* 
* @method initNotificationsAutocomplete
* @for initNotificationsAutocomplete
*/
function initNotificationsAutocomplete(){
  $(function() {
    function log( message, _id ) {
      if($('#'+_id).length === 0){
        $( "<div class='label label-info' id="+_id+">" ).text( message ).prependTo( "#log" ).append("<a href='#' class='del'>x</a>");
        $( "#log" ).scrollTop( 0 );
        if($('#search_users_ids').val().length > 0){
          $('#search_users_ids').val($( '#search_users_ids').val()+','+_id);
        }else{
          $('#search_users_ids').val(_id);
        }
        $('#filter-users').submit();
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