// TODO COPIARLO PER ALTRI 5 CASI
$(document).ready(function() {
  
  $('body').on('click', '#slides._new .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#slides._new ._tags_container');
    $(this).parent().remove();
    if($('#slides._new ._tags_container span').length === 0) {
      $('#slides._new #tags').css("top", 0);
    }
  });
  
  $('body').on('click', '#slides._new ._tags_container', function() {
    $('#slides._new #tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '#slides._new #tags', function(e) {
    if(e.which === 13 || e.which === 188 ) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#slides._new ._tags_container');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#slides._new #tags', function(e) {
     addTagWithoutSuggestion(this, '#slides._new ._tags_container');
  });
  
  initTagsAutocomplete('#slides._new');
  
});

function addTagWithoutSuggestion(input, container_selector) {
  var my_val = $.trim($(input).val());
  if(my_val.length >= $('#popup_parameters_container').data('min-tag-length') && checkNoTagDuplicates(my_val, container_selector)) {
    if($('.ui-autocomplete a').first().text() == my_val) {
      addToTagsValue(my_val, container_selector);
      createTagSpan(my_val, false).insertBefore(input);
    } else {
      addToTagsValue(my_val, container_selector);
      createTagSpan(my_val, true).insertBefore(input);
      $.ajax({
        type: 'get',
        url: '/tags/' + my_val + '/check_presence',
        dataType: 'json',
        success: function(data) {
          if(data.ok) {
            $(container_selector).find('span._' + my_val).removeClass('new_tag');
          }
        }
      });
    }
  }
  $('.ui-autocomplete').hide();
  $(input).val('');
}

function addToTagsValue(word, container_selector) {
  var old_value = $(container_selector + ' #tags_value').val();
  old_value += (', ' + word);
  $(container_selector + ' #tags_value').val(old_value);
}

function removeFromTagsValue(word, container_selector) {
  var old_value = $(container_selector + ' #tags_value').val();
  old_value = old_value.replace(word, '');
  $(container_selector + ' #tags_value').val(old_value);
}

function checkNoTagDuplicates(word, container_selector) {
  var flag = true;
  $(container_selector + ' span').each(function() {
    if($(this).text() === word) {
      flag = false;
    }
  });
  return flag;
}

function createTagSpan(word, new_tag) {
  var span = $('<span>').text(word);
  var a = $('<a>').addClass('remove').attr({
    href: 'javascript:',
    title: 'Remove ' + word
  }).appendTo(span);
  if(new_tag) {
    span.addClass('new_tag _' + word);
  }
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
        addToTagsValue(ui.item.value, container_selector);
        createTagSpan(ui.item.value, false).insertBefore(input_selector);
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
