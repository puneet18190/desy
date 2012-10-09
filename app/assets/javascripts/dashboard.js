function switchToSuggested(type, pos) { // TODO quando sarà pronta la paginazione dinamica, questa funzione non accetterà parametro
  var other_type = 'lesson';
  if(type == 'lessons') {
    other_type = 'media_elements';
  }
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_' + type + '_' + pos).css('display', 'block');
  $('#switch_to_' + type + 's').addClass('current');
  $('#switch_to_' + other_type + 's').removeClass('current');
}
