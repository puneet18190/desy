/**
bla bla bla
@module profile
**/





/**
bla bla bla
@method automaticLoginDocumentReady
@for ProfilePrelogin
**/
function automaticLoginDocumentReady() {
  if($('html').hasClass('prelogin-controller home-action')) {
    var parsedLocation = UrlParser.parse(window.location.href);
    if(_.contains(_.keys(parsedLocation.searchObj), 'login')) {
      $('._show_login_form_container').click();
    }
  }
}

/**
bla bla bla
@method preloginDocumentReady
@for ProfilePrelogin
**/
function preloginDocumentReady() {
  $('body').on('click', '._show_login_form_container', function() {
    var form = $('#login_form_container');
    if(!form.is(':visible')) {
      form.show('fade', {}, 500);
      $('#email').focus();
    } else {
      form.hide('fade', {}, 500);
    }
  });
  $('body').on('click', '#submit_login_form', function() {
    $('#new_users_session_form').submit();
  });
}





/**
bla bla bla
@method profileDocumentReady
@for ProfileUsers
**/
function profileDocumentReady() {
  $('body').on('keypress','#mailing_lists_accordion .group-title', function(event) {
    if (event.keyCode == 10 || event.keyCode == 13){
      event.preventDefault();
    }
  });
  $('body').on('keypress','#mailing_lists_accordion .group-title', function(event) {
     if(event.which === 32){
       event.stopPropagation();
     }
  });
  $('body').on('blur', '#mailing_lists_accordion .group-title', function() {
    var group = $(this);
    $.ajax({
      type: 'put',
      url: '/mailing_lists/' + group.data('param') + '/update/' + group.text()
    });
  });
  $('body').on('click', '#fake_save_mailing_list', function() {
    $('.group-title').effect('highlight', {color: '#41A62A'}, 1500);
  });
  $('body').on('focus', '._input_in_mailing_list', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
}