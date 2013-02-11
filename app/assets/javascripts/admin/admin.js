// This is a manifest file that'll be compiled into admin.js, which will include all the files
// listed below.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
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
  
  // EFFECTS
  
  //$('#dp1').datepicker();
  //$('#dp2').datepicker();
   
  $('.dropdown').click(function(e){
    e.stopPropagation();
  });
   
  $('body').on('click','tr.collapse',function(e){
   e.preventDefault();
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
