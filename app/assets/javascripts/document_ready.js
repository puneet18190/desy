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
  
  $('._lesson_compact').click(function() {
    var my_id = this.id;
    var my_expanded = $('#' + my_id + ' ._lesson_expanded');
    if(my_expanded.css('display') == 'block') {
      my_expanded.css('display', 'none');
    } else {
      my_expanded.css('display', 'block');
    }
  });
  
  $("#dialog-normal").dialog({
    autoOpen: false,
  });
  
  $("#dialog-shade").dialog({
    autoOpen: false,
  });
  
  $("#dialog-timed").dialog({
    autoOpen: false,
  });
  
  $('._action_button').click(function() {
    var my_function = $(this).data('clickFunction');
    var my_param = $(this).data('clickParam');
    window[myFunction](myParam);
  });
  
});
