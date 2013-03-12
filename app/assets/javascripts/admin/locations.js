$(document).ready(function() {
  
  $('._select_locations_admin').on('change', function() {
    if(!$(this).data('is-last') && $(this).val() != '0') {
      $.ajax({
        url: '/admin/locations/' + $(this).val() + '/find',
        type: 'post'
      });
    }
  });
  
});
