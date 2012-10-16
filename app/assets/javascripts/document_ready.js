$(document).ready(function() {
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  $('#filter_lessons').change(function() {
    var filter = $('#filter_lessons option:selected').val();
    window.location.href = '/lessons?filter=' + filter;
  });
  
  $('body').on('click','._lesson_compact',function() {
    var my_id = this.id;
    var my_expanded = $('#' + my_id + ' ._lesson_expanded');
    if(my_expanded.css('display') == 'block') {
      my_expanded.css('display', 'none');
    } else {
      my_expanded.css('display', 'block');
    }
  });
  
  $("#dialog-error").dialog({
    autoOpen: false,
  });
  
  $("#dialog-shade").dialog({
    autoOpen: false,
  });
  
  $("#dialog-timed").dialog({
    autoOpen: false,
  });
  
  $('body').on('click', '._action_button.publish, ._action_button.unpublish', function(e) {
    e.preventDefault();
    var my_function = $(this).data('clickfunction');
    var my_param = $(this).data('clickparam');
    window[my_function](my_param);
    return false;
  });
  
  $('.scroll-pane').jScrollPane({
    autoReinitialise: true
  });
  
  $("#sceltaElementi").selectbox();
  
  $("#filter_lessons").selectbox();
  
	$("#format_media_elements").selectbox();
	
	$("#filter_media_elements").selectbox();
  initializeNotifications();
  
});
