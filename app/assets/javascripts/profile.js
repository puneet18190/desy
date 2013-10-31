/**
This module contains the initialization methods for <b>profiling</b> and <b>registration</b> of new users.
@module profile
**/





/**
Initializes the action that shows automaticly the login form when somebody opens the maing page of the application without being logged.
@method automaticLoginDocumentReady
@for ProfilePrelogin
**/
function automaticLoginDocumentReady() {
  if( $html.hasClass('prelogin-controller home-action') ) {
    var parsedLocation = UrlParser.parse(window.location.href);
    if(_.contains(_.keys(parsedLocation.searchObj), 'login')) {
      $('._show_login_form_container').click();
    }
  }
}

/**
Initializes the handler of the login form.
@method preloginDocumentReady
@for ProfilePrelogin
**/
function preloginDocumentReady() {
  $body.on('click', '._show_login_form_container', function() {
    var form = $('#login_form_container');
    if(!form.is(':visible')) {
      form.show('fade', {}, 500);
      $('#email').focus();
    } else {
      form.hide('fade', {}, 500);
    }
  });
  $body.on('click', '#submit_login_form', function() {
    $('#new_users_session_form').submit();
  });
}

/**
Initializes the handler of the login form.
@method purchaseCodeRegistrationDocumentReady
@for ProfilePrelogin
**/
function purchaseCodeRegistrationDocumentReady() {
  $body.on('blur', '#registration_purchase_id', function() {
    $.ajax({
      type: 'get',
      url: 'sign_up/purchase_code'
    });
  });
}





/**
Initializes the javascript effects of the registration / modify profile form.
@method profileDocumentReady
@for ProfileUsers
**/
function profileDocumentReady() {
  $body.on('keypress','#mailing_lists_accordion .group-title', function(event) {
    if (event.keyCode == 10 || event.keyCode == 13){
      event.preventDefault();
    }
  });
  $body.on('keypress','#mailing_lists_accordion .group-title', function(event) {
     if(event.which === 32){
       event.stopPropagation();
     }
  });
  $body.on('blur', '#mailing_lists_accordion .group-title', function() {
    var group = $(this);
    $.ajax({
      type: 'put',
      url: '/mailing_lists/' + group.data('param') + '/update/' + group.text()
    });
  });
  $body.on('click', '#fake_save_mailing_list', function() {
    $('.group-title').effect('highlight', {color: '#41A62A'}, 1500);
  });
  $body.on('focus', '._input_in_mailing_list', function() {
    if($(this).data('placeholder')) {
      $(this).val('');
      $(this).data('placeholder', false);
    }
  });
  $body.on('click', '.profileLink', function() {
    window.location = '/profile';
  });
}
