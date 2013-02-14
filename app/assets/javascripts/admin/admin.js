// This is a manifest file that'll be compiled into admin.js, which will include all the files
// listed below.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.9.0.custom
//= require jquery.peity
//= require bootstrap
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-datepicker
//= require jquery-fileupload/basic
//= require ajax_loader

$(document).ready(function(){
  
  // LOADER
  bindLoader();
  
  // FUNCTIONS
  $('body').on('click','._update_new_element ', function(e){
    $.ajax({
      type: 'PUT',
      url: '/admin/elements/'+$(this).data('param'),
      timeout:5000,
      data: $(this).parent('form').serialize(),
      success: function(){
        $(e.target).parents('.element-update-form').fadeOut('fast').fadeIn('fast');
      }
  	});
  });
  
  $('body').on('click','._publish_private_element', function(e){
    $('<input />',{
      type: 'hidden',
      name: 'is_public' 
    }).insertBefore($(this));
    
    $.ajax({
      type: 'PUT',
      url: '/admin/elements/'+$(this).data('param'),
      timeout:5000,
      data: $(this).parent('form').serialize(),
      success: function(){
        var btn = $(e.target);
        btn.siblings('._update_new_element').remove();
        btn.siblings('input').prop('disabled', true);
        btn.siblings('textarea').prop('disabled', true);
        btn.remove();
      }
  	});
  });
  
  $('body').on('click','.action._publish_list_element i', function(e){
    e.preventDefault();
    $.ajax({
      type: 'PUT',
      url: '/admin/elements/'+$(this).data('param')+'?is_public=true',
      timeout:5000,
      success: function(){
        var btn = $(e.target);
        btn.remove();
      }
  	});
  });
  
  $('body').on('click','._delete_new_element ', function(e){
    $.ajax({
      type: 'DELETE',
      url: '/admin/elements/'+$(this).data('param'),
      timeout:5000,
      success: function(){
        $(e.target).parents('.element-update-form').fadeOut();
      }
  	});
    
  });
  
  $('body').on('click','._delete_list_element ', function(e){
    e.preventDefault();
    $.ajax({
      type: 'DELETE',
      url: '/admin/elements/'+$(this).data('param'),
      timeout:5000,
      success: function(){
        var el = $(e.target).parents('.collapse')
        el.next('collapsed').fadeOut();
        el.fadeOut();
      }
  	});
    
  });
  
  $(function() {
      function split( val ) {
        return val.split( /,\s*/ );
      }
      function extractLast( term ) {
        return split( term ).pop();
      }
 
      $('#contact-recipients')
        // don't navigate away from the field on tab when selecting an item
        .bind( "keydown", function( event ) {
          if ( event.keyCode === $.ui.keyCode.TAB &&
              $( this ).data( "autocomplete" ).menu.active ) {
            event.preventDefault();
          }
        })
        .autocomplete({
          create: function(){
            $('.ui-helper-hidden-accessible').wrap('<div class="autocomplete-suggest alert alert-info hide pull-right" />');
          },
          source: function( request, response ) {
            $.getJSON( "/admin/users/get_emails", {
              term: extractLast( request.term )
            }, response );
          },
          search: function() {
            // custom minLength
            var term = extractLast( this.value );
            if ( term.length < 2 ) {
              return false;
            }
            $('.alert-info').show();
          },
          focus: function() {
            // prevent value inserted on focus
            return false;
          },
          select: function( event, ui ) {
            var terms = split( this.value );
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push( ui.item.value );
            // add placeholder to get the comma-and-space at the end
            terms.push( "" );
            this.value = terms.join( ", " );
            return false;
          },
          messages: {
            results: function() {

            }
          }
        });
    });
  
  // EFFECTS
  
  $('#dp1').datepicker();
  $('#dp2').datepicker();
   
  $('.dropdown').click(function(e){
    e.stopPropagation();
  });
   
  $('body').on('click','tr.collapse',function(e){
    var t = $(e.target);
    if(!(t.hasClass('icon-eye-open') || t.hasClass('icon-remove') || t.hasClass('icon-globe'))){
      e.preventDefault();
    }
   $(this).next('tr.collapsed').slideToggle('slow');
  });
   
  $('body').on('click','#expand-all',function(e){
   e.preventDefault();
   $('tr.collapsed').slideDown('slow');
  });
   
  $('body').on('click','#collapse-all',function(e){
   e.preventDefault();
   $('tr.collapsed').slideUp('slow');
  });
  
  // BROWSER DETECTION: IE CHECK
  if(!$.browser.msie){
    $('#new-elements').fileupload();
  }else{
    $('._new_element_form_submit').show();
  }
  
});