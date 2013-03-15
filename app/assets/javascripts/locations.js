$(document).ready(function() {
  
  $('._location_select_box').each(function() {
    $('#' + $(this).attr('id')).selectbox();
  });
  
  $('._select_locations_admin').on('change', function() {
    if(!$(this).data('is-last')) {
      if($(this).val() == '0') {
        $(this).parents('.control-group').nextAll().find('select').html('');
      } else {
        $.ajax({
          url: '/locations/' + $(this).val() + '/find',
          type: 'post'
        });
      }
    }
  });
  
});
