// This is a manifest file that'll be compiled into admin.js, which will include all the files
// listed below.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.peity
//= require bootstrap
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-datepicker
//= require jquery-fileupload/basic

$(document).ready(function(){
  $('#dp1').datepicker();
  $('#dp2').datepicker();
  $('[rel=popover]').popover({ 
    html : true,
    trigger : 'hover'
  });
   
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
});
