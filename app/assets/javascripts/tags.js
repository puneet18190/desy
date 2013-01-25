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
  
});

function extractLastTag(term) {
  return term.split(/,\s*/).pop();
}

function initTagsAutocomplete(scope) {
  var input_selector = scope + ' #tags';
  var container_selector = scope + ' ._tags_container';
  $(input_selector).autocomplete({
    source: function(request, response) {
      $.getJSON( "/tags/get_list", {
        term: extractLastTag(request.term)
      }, response);
    },
    search: function() {
      var term = extractLastTag(this.value);
      if(term.length < $('#popup_parameters_container').data('min-length-search-tags')) {
        return false;
      }
    },
    select: function(e, ui) {
      var tag = ui.item.value;
      var span = $('<span>').text(tag);
      var a = $('<a>').addClass('remove').attr({
        href: 'javascript:',
        title: 'Remove ' + tag
      }).appendTo(span);
      span.insertBefore(input_selector);
      var this_container = $(container_selector)[0];
      this_container.scrollTop = this_container.scrollHeight;
      $(input_selector).val('').css('top', 2);
    },
    change: function() {
      console.log('change tag??');
      $(input_selector).val('').css('top', 2);
    }
  });
}
