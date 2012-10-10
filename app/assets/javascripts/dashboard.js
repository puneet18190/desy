function switchToSuggested(type, old_pos, pos) { // TODO quando sarà pronta la paginazione dinamica, questa funzione andrà rifatta!
  $('#suggested_' + type + 's_' + old_pos).css('display', 'none');
  $('#suggested_' + type + 's_' + pos).css('display', 'block');
}

function switchToSuggestedMediaElements() {
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_media_elements_0').css('display', 'block');
  $('#switch_to_media_elements').addClass('current');
  $('#switch_to_lessons').removeClass('current');
}

function switchToSuggestedLessons() {
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_lessons_0').css('display', 'block');
  $('#switch_to_lessons').addClass('current');
  $('#switch_to_media_elements').removeClass('current');
}
