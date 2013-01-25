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
      var my_val = $.trim($(this).val());
      if(my_val.length >= $('#popup_parameters_container').data('min-tag-length') && checkNoTagDuplicates(my_val, '#slides._new ._tags_container')) {
        createTagSpan(my_val).insertBefore(this);
      }
      $('.ui-autocomplete').hide();
      $(this).val('');
    }
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  $('body').on('blur', '#slides._new #tags', function(e) {
    var my_val = $.trim($(this).val());
    if(my_val.length >= $('#popup_parameters_container').data('min-tag-length') && checkNoTagDuplicates(my_val, '#slides._new ._tags_container')) {
      createTagSpan(my_val).insertBefore(this);
    }
    $('.ui-autocomplete').hide();
    $(this).val('');
  });
  
  // TODO COPIARLO PER ALTRI 5 CASI
  initTagsAutocomplete('#slides._new');
  
});

function checkNoTagDuplicates(word, container_selector) {
  var flag = true;
  $(container_selector + ' span').each(function() {
    if($(this).text() === word) {
      flag = false;
    }
  });
  return flag;
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
      if(this.value.length < $('#popup_parameters_container').data('min-length-search-tags')) {
        return false;
      }
    },
    select: function(e, ui) {
      if(checkNoTagDuplicates(ui.item.value, container_selector)) {
        $('#info_container').data('tag-just-selected', true);
        createTagSpan(ui.item.value).insertBefore(input_selector);
      }
      var this_container = $(container_selector)[0];
      this_container.scrollTop = this_container.scrollHeight;
    },
    close: function() {
      if($('#info_container').data('tag-just-selected')) {
        $(input_selector).val('').css('top', 2);
        $('#info_container').data('tag-just-selected', false);
      }
    }
  });
}
