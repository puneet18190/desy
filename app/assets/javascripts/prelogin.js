function switchToOtherPreloginSection(content, link) {
  $('#' + content).show('fade', {}, 500, function() {
    $('._prelogin_link').removeClass('current');
    $('._prelogin_content').css('display', 'none');
    $(this).css('display', 'block');
    $('#' + link).addClass('current');
  });
}

function switchToOtherPreloginLogo(logo) {
  $('#' + logo).show('fade', {}, 500, function() {
    $('._prelogin_logo').css('display', 'none');
    $(this).css('display', 'block');
  });
}
