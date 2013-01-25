$(document).ready(function() {
  
  // TODO COPIARLO PER ALTRI 5 CASI
  $('body').on('click', '#slides._new .remove', function() {
    $(this).parent().remove();
    if($('#slides._new ._tags_container span').length === 0) {
      $('#slides._new #tags').css("top", 0);
    }
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  $('body').on('click', '#slides._new ._tags_container', function() {
    $('#slides._new #tags').focus();
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  $('body').on('keydown', '#slides._new #tags', function(e) {
    if(e.which === 13 || e.which === 188 ) {
      e.preventDefault();
      if($.trim($(this).val()).length >= $('#popup_parameters_container').data('min-tag-length')) {
        createTagSpan($(this).val()).insertBefore(this);
      }
      $('.ui-autocomplete').hide();
      $(this).val('');
    }
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  $('body').on('blur', '#slides._new #tags', function(e) {
    if($.trim($(this).val()).length >= $('#popup_parameters_container').data('min-tag-length')) {
      createTagSpan($(this).val()).insertBefore(this);
    }
    $('.ui-autocomplete').hide();
    $(this).val('');
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  initTagsAutocomplete('#slides._new');
  
});

function checkTagDuplicates(word, scope) {
  
}

function createTagSpan(word) {
  var span = $('<span>').text(word);
  var a = $('<a>').addClass('remove').attr({
    href: 'javascript:',
    title: 'Remove ' + word
  }).appendTo(span);
  return span;
}

function initTagsAutocomplete(scope) {
  var input_selector = scope + ' #tags';
  var container_selector = scope + ' ._tags_container';
  $(input_selector).autocomplete({
    source: function(request, response) {
      $.getJSON( "/tags/get_list", {
        term: request.term
      }, response);
    },
    search: function() {
      console.log('search');
      if(this.value.length < $('#popup_parameters_container').data('min-length-search-tags')) {
        return false;
      }
    },
    select: function(e, ui) {
      console.log('select');
      createTagSpan(ui.item.value).insertBefore(input_selector);
      var this_container = $(container_selector)[0];
      this_container.scrollTop = this_container.scrollHeight;
      

      
      $(input_selector).val('').css('top', 2);
      

      
    },
    change: function() {
      console.log('change');
   //   $(input_selector).val('').css('top', 2);
    },
    close: function() {
      var current_tag = $(input_selector).val('');
      if(current_tag != $($('ui-autocomplete a')[0]).html()) {
        $(input_selector).val('').css('top', 2);
      }
      console.log('close');
    },
    focus: function() {
      console.log('focus');
    },
    open: function() {
      console.log('open');
    }
  });
}
