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

$(document).ready(function() {
  
  
  // LOADER
  
  bindLoader();
  
  
  // SEARCH
  
  $('#province_list, #town_list').on('change', function() {
    var $this = $(this);
    if($this.val().length > 0) {
      $.ajax({
        url: '/admin/location/' + $(this).val() + '/find',
        type: 'post'
      });
    } else {
      if($this.attr('id') === 'town_list') {
        $('#school_list').html('');
      }
      if($this.attr('id') === 'province_list') {
        $('#school_list').html('');
        $('#town_list').html('');
      }
    }
  });
  
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
    $('#filter-users').submit();
  });
  
  $('#notifications-form #all_users').change(function() {
      if(this.checked) {
        $('input#contact-recipients').val('');
        $('input#contact-recipients').attr('disabled', true);
        $('#filter-users select').attr('disabled', true);
        $('.alert').hide();
      } else {
        $('input#contact-recipients').attr('disabled', false);
        $('#filter-users select').attr('disabled', false);
        if($('.alert').length > 0 && $('.alert').html() === '') {
          $('.alert').show();
        }
      }
  });
  
  
  // SORTING
  
  $('body').on('click', 'table#lessons-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
    $('#admin-search-lessons').submit();
  });
  
  $('body').on('click', 'table#elements-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
    $('#admin-search-elements').submit();
  });
  
  $('body').on('click', 'table#users-list thead tr th a', function(e) {
    e.preventDefault();
    $this = $(this)
    var order_by = $this.data('ordering');
    $("input#search_ordering").val(order_by);
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
  
  
  // ELEMENTS ACTIONS
  
  $('body').on('click', '._create_new_element', function() {
    $.ajax({
      type: 'post',
      data: $(this).parents('._quick_load_creation_form').serialize(),
      url: '/admin/elements/quick_upload/' + $(this).data('param') + '/create'
    });
  });
  
  $('body').on('click', '._delete_new_element', function() {
    $.ajax({
      type: 'delete',
      url: '/admin/elements/quick_upload/' + $(this).data('param') + '/delete'
    });
  });
  
  $('body').on('click','.action._publish_list_element i', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'PUT',
      url: '/admin/elements/'+$(this).parent('a').data('param')+'?is_public=true',
      timeout:5000,
      success: function(){
        var btn = $(e.target);
        btn.remove();
      }
    });
  });
  
  $('body').on('click','._delete_list_element ', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'delete',
      url: '/admin/elements/' + $(this).data('param'),
      timeout:5000,
      success: function() {
        var el = $(e.target).parents('.collapse');
        el.next('collapsed').fadeOut();
        el.fadeOut();
      }
    });
  });
  
  $(function() {
    function split(val) {
      return val.split(/,\s*/);
    }
    function extractLast(term) {
      return split(term).pop();
    }
    $('#contact-recipients').bind('keydown', function(event) {
      if(event.keyCode === $.ui.keyCode.TAB && $(this).data('autocomplete').menu.active) {
        event.preventDefault();
      }
    }).autocomplete({
      source: function(request, response) {
        $.getJSON('/admin/users/get_full_names', {
          term: extractLast(request.term)
        }, response);
      },
      search: function() {
        var term = extractLast(this.value);
        if(term.length < 2) {
          return false;
        }
      },
      focus: function() {
        return false;
      },
      select: function(event, ui) {
        var terms = split(this.value);
        terms.pop();
        terms.push(ui.item.value);
        terms.push('');
        this.value = terms.join(', ');
        var $ids_input = $('input#notification_ids');
        $ids_input.val($ids_input.val() + ',' + ui.item.id);
        return false;
      },
      messages: {
        results: function() {}
      }
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
    if(!(t.hasClass('icon-eye-open') || t.hasClass('icon-remove') || t.hasClass('icon-globe'))) {
      e.preventDefault();
    }
    openAndLoadNextTr($(this));
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
