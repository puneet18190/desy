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
//= require admin/admin_functions
//= require admin/locations

$(document).ready(function() {
  
  
  // LOADER
  
  bindLoader();
  
  
  // SEARCH
  
  if($('#search_date_range').find('option:selected').val() && ($('#search_date_range').find('option:selected').val().length > 0)) {
    $('.datepick').removeAttr('disabled');
  }
  
  $('#search_date_range').on('change', function() {
    var selected = $(this).find('option:selected').val();
    if(selected.length > 0) {
      $('.datepick').removeAttr('disabled');
    } else {
      $('.datepick').attr('disabled', 'disabled');
    }
  });
  
  $('body').on('change', '#filter-users select', function() {
    var selected = $(this).find('option:selected').first();
    var text = selected.text().replace(/\s+/g, ' ');
    var select_id = $(this).attr('id');
    if($('._filter_select.'+select_id).length > 0){
      if(selected.val().length > 0){
        if(selected.val() != 0){
          $('.'+select_id+' span').text(text);
        }else{
          $('#'+select_id).parents('.control-group').nextAll().find('select').each(function(){
            $('.'+$(this).attr('id')).remove();
          });
          $('.'+select_id).remove();
        }
      }else{
        $('.'+select_id).remove();
      }
    }else{
      $( "<div class='label _filter_select "+select_id+"'>" ).html( '<span>'+text+'</span>' ).prependTo( "#log" );
    }
    $('#filter-users').submit();
  });
  
  $('#all_users').change(function() {
      if(this.checked) {
        $('._filter_and_send').removeClass('disabled');
        $("input#contact-recipients").val('');
        $("input#contact-recipients").attr('disabled',true);
        $("#log").html('');
        $("._users_count_label").text($("._users_count_label").data('all-selected'));
        $("#filter-users select").each(function(){
          $this = $(this);
          $this.find('option:selected').removeAttr('selected');
          $this.attr('disabled',true);
        });
        $('#log').html('');
      } else {
        $('._filter_and_send').addClass('disabled');
        $('input#contact-recipients').attr('disabled', false);
        $('#filter-users select').attr('disabled', false);
        $("._users_count_label").text($("._users_count_label").data('zero-selected'));
      }
  });
  
  
  // SORTING
  
  $('body').on('click', 'table#lessons-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
    $("input#search_desc").val($this.data('desc'));
    $('#admin-search-lessons').submit();
  });
  
  $('body').on('click', 'table#elements-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
    $("input#search_desc").val($this.data('desc'));
    $('#admin-search-elements').submit();
  });
  
  $('body').on('click', 'table#users-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
    $("input#search_desc").val($this.data('desc'));
    $('#admin-search-elements').submit();
  });
  
  
  // USERS ACTIONS
  
  $('body').on('click', '._active_status', function(e) {
    e.preventDefault();
    var link = $(this);
    var status = true;
    if(link.hasClass('ban')) {
      status = false;
    }
    $.ajax({
      url: '/admin/users/' + link.data('param') + '/set_status?active=' + status,
      type: "put"
    });
  });
  
  
  // MEDIA ELEMENTS ACTIONS
  
  $('body').on('click', '._create_new_element', function() {
    $.ajax({
      type: 'post',
      data: $(this).parents('._quick_load_creation_form').serialize(),
      url: '/admin/media_elements/' + $(this).data('param') + '/create'
    });
  });
  
  $('body').on('click', '._delete_new_element', function() {
    $.ajax({
      type: 'delete',
      url: '/admin/media_elements/quick_upload/' + $(this).data('param') + '/delete'
    });
  });
  
  $('body').on('click','.action._publish_list_element i', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'PUT',
      url: '/admin/media_elements/' + $(this).parent('a').data('param') + '?is_public=true',
      timeout:5000,
      success: function(){
        var btn = $(e.target);
        btn.remove();
      }
    });
  });
  
  $('body').on('click', '._publish_private_admin_element', function() {
    $.ajax({
      type: 'put',
      data: $(this).parents('._quick_load_creation_form').serialize(),
      url: '/admin/media_elements/' + $(this).data('param') + '/update?is_public=true'
    });
  });
  
  $('body').on('click', '._update_private_admin_element', function() {
    $.ajax({
      type: 'put',
      data: $(this).parents('._quick_load_creation_form').serialize(),
      url: '/admin/media_elements/' + $(this).data('param') + '/update'
    });
  });
  
  initNotificationsAutocomplete();
  
  $('body').on('click', '#log .del', function(e) {
    e.preventDefault();
    var my_div = $(this).parent('div')
    var ids_val = $('#search_users_ids').val().split(',');
    ids_val.splice(ids_val.indexOf(my_div.attr('id')),1);
    $('#search_users_ids').val(ids_val);
    my_div.remove();
    $('#filter-users').submit();
  });  
  
  $('body').on('click','._filter_and_send',function(e){
    e.preventDefault();
    if(!$(this).hasClass('disabled')){
      $form = $(this).parents('form');
      $form.find('#send_message').val(true);
      $form.submit();
      $form.find('#send_message').val('');
    }
  });
  
  // SETTINGS ACTION
  
  $('body').on('click', 'ul.subjects li a i.icon-remove', function() {
    var _id = $(this).parents('li').data('param');
    $.ajax({
      type: 'delete',
      url: '/admin/settings/subjects/' + _id + '/delete'
    });
  });
  
  $('body').on('click', 'ul.school_levels li a i.icon-remove', function() {
    $.ajax({
      type: 'delete',
      url: '/admin/settings/school_levels/' + $(this).parents('li').data('param') + '/delete'
    });
  });
  
  
  // EFFECTS
  
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  var checkin = $('#dpd1').datepicker({
    onRender: function(date) {
      return date.valueOf() < now.valueOf() || (checkout && date.valueOf() < checkout.date.valueOf()) ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    if (ev.date.valueOf() > checkout.date.valueOf()) {
      $('#alert').show();
      $('#alert .start').show();
      $('#alert .end').hide();
    } else {
      $('#alert').hide();
    }
    checkin.hide();
    $('#dpd1')[0].blur();
    $('#dpd2')[0].blur();
  }).data('datepicker');
  var checkout = $('#dpd2').datepicker({
    onRender: function(date) {
      return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    if (ev.date.valueOf() < checkin.date.valueOf()) {
      $('#alert').show();
      $('#alert .end').show();
      $('#alert .start').hide();
    } else {
      $('#alert').hide();
    }
    checkout.hide();
    $('#dpd1')[0].blur();
    $('#dpd2')[0].blur();
  }).data('datepicker');
  
  $('.dropdown').click(function(e) {
    e.stopPropagation();
  });
  
  $('body').on('click', 'tr.collapse', function(e) {
    var t = $(e.target);
    if(!(t.hasClass('icon-eye-open') || t.hasClass('icon-remove') || t.hasClass('icon-globe') || t.hasClass('_user_link_in_admin'))) {
      openAndLoadNextTr($(this));
    }
  });
  
  $('body').on('click', '#expand-all', function(e) {
   e.preventDefault();
   $('tr.collapsed').slideDown('slow');
  });
  
  $('body').on('click', '#collapse-all', function(e) {
   e.preventDefault();
   $('tr.collapsed').slideUp('slow');
  });
  
  
  // BROWSER DETECTION: IE CHECK
  
  if(!$.browser.msie) {
    $('#new-elements').fileupload();
  } else {
    $('._new_element_form_submit').show();
  }
  
});
