function switchToSuggestedMediaElements() {
  $('#lessons_in_dashboard').css('display', 'none');
  $('#media_elements_in_dashboard').css('display', 'block');
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_media_elements_1').css('display', 'block');
  $('#switch_to_media_elements').addClass('current');
  $('#switch_to_lessons').removeClass('current');
}

function switchToSuggestedLessons() {
  $('#media_elements_in_dashboard').css('display', 'none');
  $('#lessons_in_dashboard').css('display', 'block');
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_lessons_1').css('display', 'block');
  $('#switch_to_lessons').addClass('current');
  $('#switch_to_media_elements').removeClass('current');
}
