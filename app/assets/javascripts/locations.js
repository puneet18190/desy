/**
ba bla bla bla
@for LocationsDocumentReady
@method locationsDocumentReady
**/
function locationsDocumentReady() {
  
  $('._location_select_box').each(function() {
    $('#' + $(this).attr('id')).selectbox();
  });
  
  $('._location_select_box').on('change', function() {
    if(!$(this).data('is-last')) {
      if($(this).val() == '0') {
        $(this).parents('._location_selector').nextAll().find('select').html('');
      } else {
        $.ajax({
          url: '/locations/' + $(this).val() + '/find',
          type: 'get'
        });
      }
    }
  });
  
}
