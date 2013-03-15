$(document).ready(function() {
  
  $('._select_locations_admin').on('change', function() {
    if(!$(this).data('is-last')) {
      if($(this).val() == '0') {
        $(this).parents('.control-group').nextAll().find('select').html('');
      } else {
        $.ajax({
          url: '/admin/locations/' + $(this).val() + '/find',
          type: 'get'
        });
      }
    }
  });
  
});
