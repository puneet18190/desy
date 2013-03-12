$(document).ready(function() {
  
  $('#user_location_id').selectbox();
  
  $('#town_id').selectbox();
  
  $('#province_id').selectbox();
  
  $('#province_id, #town_id').on('change', function() {
    var $this = $(this);
    if($this.val().length > 0) {
      $.ajax({
        url: '/location/' + $(this).val() + '/find',
        type: 'post'
      });
    } else {
      if($this.attr('id') === 'town_id') {
        $('#user_location_id').selectbox('detach');
        $('#user_location_id').html('');
        $('#user_location_id').selectbox();
      }
      if($this.attr('id') === 'province_id') {
        $('#user_location_id').selectbox('detach');
        $('#town_id').selectbox('detach');
        $('#user_location_id').html('');
        $('#town_id').html('');
        $('#user_location_id').selectbox();
        $('#town_id').selectbox();
      }
    }
  });
  
});
