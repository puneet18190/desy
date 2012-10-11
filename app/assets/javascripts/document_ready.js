$(document).ready(function() {
  
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
  
  $('#filter_lessons').change(function() {
    var filter = $('#filter_lessons option:selected').val();
    window.location.href = '/lessons?filter=' + filter
  });
  
});
