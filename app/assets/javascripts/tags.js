$(document).ready(function() {
  
  // FORM CHANGE INFO MEDIA ELEMENT
  
  $('body').on('click', '._change_info_container ._tags_container .remove', function() {
    var media_element_id = $(this).parent().parent().parent().parent().parent().data('param');
    removeFromTagsValue($(this).parent().text(), '#dialog-media-element-' + media_element_id + ' ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#load-media-element #tags').not(':visible')) {
      $('#load-media-element #tags').show();
      disableTagsInputTooHigh('#load-media-element ._tags_container', '#load-media-element #tags');
    }
  });
  
  $('body').on('focus', '._change_info_container ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '._change_info_container ._tags_container', function() {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    $('#dialog-media-element-' + media_element_id + ' #tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '._change_info_container #tags', function(e) {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#dialog-media-element-' + media_element_id + ' ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '._change_info_container #tags', function(e) {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    addTagWithoutSuggestion(this, '#dialog-media-element-' + media_element_id + ' ._tags_container', '#tags_value');
  });
  
  $('._change_info_container').each(function() {
    var media_element_id = $(this).data('param');
    initTagsAutocomplete('#dialog-media-element-' + media_element_id);
    (function() {
      disableTagsInputTooHigh('#dialog-media-element-' + media_element_id + ' ._tags_container', '#dialog-media-element-' + media_element_id + ' #tags');
    });
  });
  
  
  // FORM UPLOAD NEW MEDIA ELEMENT
  
  $('body').on('click', '#load-media-element ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#load-media-element ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#load-media-element #tags').not(':visible')) {
      $('#load-media-element #tags').show();
      disableTagsInputTooHigh('#load-media-element ._tags_container', '#load-media-element #tags');
    }
  });
  
  $('body').on('focus', '#load-media-element ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '#load-media-element ._tags_container', function() {
    $('#load-media-element #tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '#load-media-element #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#load-media-element ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#load-media-element #tags', function(e) {
    addTagWithoutSuggestion(this, '#load-media-element ._tags_container', '#tags_value');
  });
  
  initTagsAutocomplete('#load-media-element');
  
  
  // FORM OVERWRITE MEDIA ELEMENT
  
  $('body').on('click', '#form_info_update_media_element_in_editor ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#form_info_update_media_element_in_editor ._tags_container #update_tags_value');
    $(this).parent().remove();
    if($('#form_info_update_media_element_in_editor #update_tags').not(':visible')) {
      $('#form_info_update_media_element_in_editor #update_tags').show();
      disableTagsInputTooHigh('#form_info_update_media_element_in_editor ._tags_container', '#form_info_update_media_element_in_editor #update_tags');
    }
  });
  
  $('body').on('focus', '#form_info_update_media_element_in_editor ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '#form_info_update_media_element_in_editor ._tags_container', function() {
    $('#form_info_update_media_element_in_editor #update_tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '#form_info_update_media_element_in_editor #update_tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#form_info_update_media_element_in_editor ._tags_container', '#update_tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#form_info_update_media_element_in_editor #update_tags', function(e) {
    addTagWithoutSuggestion(this, '#form_info_update_media_element_in_editor ._tags_container', '#update_tags_value');
  });
  
  initTagsAutocomplete('#form_info_update_media_element_in_editor');
  
  (function() {
    disableTagsInputTooHigh('#form_info_update_media_element_in_editor ._tags_container', '#form_info_update_media_element_in_editor #update_tags');
  });
  
  
  // FORM SAVE AS NEW MEDIA ELEMENT
  
  $('body').on('click', '#form_info_new_media_element_in_editor ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#form_info_new_media_element_in_editor ._tags_container #new_tags_value');
    $(this).parent().remove();
    if($('#form_info_new_media_element_in_editor #new_tags').not(':visible')) {
      $('#form_info_new_media_element_in_editor #new_tags').show();
      disableTagsInputTooHigh('#form_info_new_media_element_in_editor ._tags_container', '#form_info_new_media_element_in_editor #new_tags');
    }
  });
  
  $('body').on('focus', '#form_info_new_media_element_in_editor ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '#form_info_new_media_element_in_editor ._tags_container', function() {
    $('#form_info_new_media_element_in_editor #new_tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '#form_info_new_media_element_in_editor #new_tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#form_info_new_media_element_in_editor ._tags_container', '#new_tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#form_info_new_media_element_in_editor #new_tags', function(e) {
    addTagWithoutSuggestion(this, '#form_info_new_media_element_in_editor ._tags_container', '#new_tags_value');
  });
  
  initTagsAutocomplete('#form_info_new_media_element_in_editor');
  
  
  // FORM NEW LESSON
  
  $('body').on('click', '#slides._new ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#slides._new ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#slides._new #tags').not(':visible')) {
      $('#slides._new #tags').show();
      disableTagsInputTooHigh('#slides._new ._tags_container', '#slides._new #tags');
    }
  });
  
  $('body').on('focus', '#slides._new ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '#slides._new ._tags_container', function() {
    $('#slides._new #tags').focus();
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('keydown', '#slides._new #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#slides._new ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#slides._new #tags', function(e) {
    addTagWithoutSuggestion(this, '#slides._new ._tags_container', '#tags_value');
  });
  
  initTagsAutocomplete('#slides._new');
  
  
  // FORM UPDATE LESSON
  
  $('body').on('click', '#slides._update ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#slides._update ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#slides._update #tags').not(':visible')) {
      $('#slides._update #tags').show();
      disableTagsInputTooHigh('#slides._update ._tags_container', '#slides._update #tags');
    }
  });
  
  $('body').on('focus', '#slides._update ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  
  $('body').on('click', '#slides._update ._tags_container', function() {
    $('#slides._update #tags').focus();
  });
  
  $('body').on('keydown', '#slides._update #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#slides._update ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  
  $('body').on('blur', '#slides._update #tags', function(e) {
    addTagWithoutSuggestion(this, '#slides._update ._tags_container', '#tags_value');
  });
  
  initTagsAutocomplete('#slides._update');
  
  (function() {
    disableTagsInputTooHigh('#slides._update ._tags_container', '#slides._update #tags');
  });
  
});

function addTagWithoutSuggestion(input, container_selector, tags_value_selector) {
  var my_val = $.trim($(input).val()).toLowerCase();
  if(my_val.length >= $('#popup_parameters_container').data('min-tag-length') && checkNoTagDuplicates(my_val, container_selector)) {
    if($('.ui-autocomplete a').first().text() == my_val) {
      addToTagsValue(my_val, (container_selector + ' ' + tags_value_selector));
      createTagSpan(my_val, false).insertBefore(input);
    } else {
      addToTagsValue(my_val, (container_selector + ' ' + tags_value_selector));
      createTagSpan(my_val, true).insertBefore(input);
      $.ajax({
        type: 'get',
        url: '/tags/' + my_val + '/check_presence',
        dataType: 'json',
        success: function(data) {
          if(data.ok) {
            $(container_selector).find('span.' + getUnivoqueClassForTag(my_val)).removeClass('new_tag');
          }
        }
      });
    }
    disableTagsInputTooHigh(container_selector, input);
  }
  $('.ui-autocomplete').hide();
  $(input).val('');
}

function addToTagsValue(word, value_selector) {
  var old_value = $(value_selector).val();
  old_value += (', ' + word);
  $(value_selector).val(old_value);
}

function removeFromTagsValue(word, value_selector) {
  var old_value = $(value_selector).val();
  old_value = old_value.replace(word, '');
  $(value_selector).val(old_value);
}

function getUnivoqueClassForTag(word) {
  var resp = '';
  for(var i = 0; i < word.length; i++) {
    resp += '_' + word.charCodeAt(i);
  }
  return resp
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
  var a = $('<a>').addClass('remove').appendTo(span);
  if(new_tag) {
    span.addClass('new_tag ' + getUnivoqueClassForTag(word));
  }
  return span;
}

function disableTagsInputTooHigh(container_selector, input_selector) {
  if($(container_selector)[0].scrollHeight > $(container_selector).height()) {
    $(input_selector).hide();
  }
}

function initTagsAutocomplete(scope) {
  var input_selector = scope + ' #tags';
  if(scope == '#form_info_new_media_element_in_editor') {
    input_selector = scope + ' #new_tags';
  }
  if(scope == '#form_info_update_media_element_in_editor') {
    input_selector = scope + ' #update_tags';
  }
  var container_selector = scope + ' ._tags_container';
  var tags_value_selector = '#tags_value';
  if(scope == '#form_info_new_media_element_in_editor') {
    tags_value_selector = '#new_tags_value';
  }
  if(scope == '#form_info_update_media_element_in_editor') {
    tags_value_selector = '#update_tags_value';
  }
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
        addToTagsValue(ui.item.value, container_selector + ' ' + tags_value_selector);
        createTagSpan(ui.item.value, false).insertBefore(input_selector);
        disableTagsInputTooHigh(container_selector, input_selector);
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
