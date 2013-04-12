/**
The functions in this module handle two different functionalities of <b>autocomplete</b> for tags: suggestions for a research (<b>search autocomplete</b>, and suggestions for tagging lessons and media elements (<b>tagging autocomplete</b>). Both modes use the same JQuery plugin called <i>JQueryAutocomplete</i> (the same used in {{#crossLink "AdminAutocomplete/initNotificationsAutocomplete:method"}}{{/crossLink}}).
<br/><br/>
The <b>search</b> autocomplete mode requires a simple initializer (method {{#crossLink "TagsInitializers/initSearchTagsAutocomplete:method"}}{{/crossLink}}), which is initialized in three different keyword inputs of the search engine (the general one, the one for elements and the one for lessons, see {{#crossLink "TagsDocumentReady/tagsDocumentReady:method"}}{{/crossLink}}).
@module tags
**/





/**
Handle adding tag not in the autocomplete data list
@method addTagWithoutSuggestion
@for TagsAccessories
@param input {String} input selector for tag, class or id
@param container_selector {String} added tags container selector, class or id
@param tags_value_selector {String} hidden input field for tags value selector
**/
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
        beforeSend: unbindLoader(),
        url: '/tags/' + my_val + '/check_presence',
        dataType: 'json',
        success: function(data) {
          if(data.ok) {
            $(container_selector).find('span.' + getUnivoqueClassForTag(my_val)).removeClass('new_tag');
          }
        }
      }).always(bindLoader);
    }
    disableTagsInputTooHigh(container_selector, input);
  }
  $('.ui-autocomplete').hide();
  $(input).val('');
}

/**
Add tag word to hidden field with tags values
@method addToTagsValue
@for TagsAccessories
@param word {String} tag name
@param value_selector {String} hidden input field for tags value selector
**/
function addToTagsValue(word, value_selector) {
  var old_value = $(value_selector).val();
  if(old_value.indexOf(',') == -1) {
    old_value = (',' + word + ',');
  } else {
    old_value += (word + ',');
  }
  $(value_selector).val(old_value);
}

/**
Checks if a tag word is present in the tags container.
@method checkNoTagDuplicates
@for TagsAccessories
@param word {String} tag name
@param container_selector {String} tags container selector
@return {Boolean}
**/
function checkNoTagDuplicates(word, container_selector) {
  var flag = true;
  $(container_selector + ' span').each(function() {
    if($(this).text() === word) {
      flag = false;
    }
  });
  return flag;
}

/**
Creates a new span element for a new tag.
@method createTagSpan
@for TagsAccessories
@param word {String} tag name
@param new_tag {Boolean} flag true if it's a new tag, false otherwise
@return {Object} span element
**/
function createTagSpan(word, new_tag) {
  var span = $('<span>').text(word);
  var a = $('<a>').addClass('remove').appendTo(span);
  if(new_tag) {
    span.addClass('new_tag ' + getUnivoqueClassForTag(word));
  }
  return span;
}

/**
Disable insert new tag when tags container is full.
@method disableTagsInputTooHigh
@for TagsAccessories
@param container_selector {String} tags container selector, class or id
@param input_selector {String} new tag input selector, class or id
**/
function disableTagsInputTooHigh(container_selector, input_selector) {
  if($(container_selector)[0].scrollHeight > $(container_selector).height()) {
    $(input_selector).hide();
  }
}

/**
Generates a name_aware class for a given tag
@method getUnivoqueClassForTag
@for TagsAccessories
@param word {String} tag name
@return {String} i.e. w_a_t_e_r_
**/
function getUnivoqueClassForTag(word) {
  var resp = '';
  for(var i = 0; i < word.length; i++) {
    resp += '_' + word.charCodeAt(i);
  }
  return resp
}

/**
Remove tag word to hidden field with tags values
@method removeFromTagsValue
@for TagsAccessories
@param word {String} tag name
@param value_selector {String} hidden input field for tags value selector
**/
function removeFromTagsValue(word, value_selector) {
  var old_value = $(value_selector).val();
  old_value = old_value.replace((',' + word + ','), ',');
  $(value_selector).val(old_value);
}





/**
bla bla bla
@method tagsDocumentReady
@for TagsDocumentReady
**/
function tagsDocumentReady() {
  initSearchTagsAutocomplete('#general_tag_reader_for_search');
  initSearchTagsAutocomplete('#lessons_tag_reader_for_search');
  initSearchTagsAutocomplete('#media_elements_tag_reader_for_search');
  tagsDocumentReadyChangeMediaElementInfo();
  tagsDocumentReadyMediaElementLoader();
  tagsDocumentReadyOvervriteMediaElement();
  tagsDocumentReadyNewMediaElement();
  tagsDocumentReadyNewLesson();
  tagsDocumentReadyUpdateLesson();
}

/**
bla bla bla
@method tagsDocumentReadyChangeMediaElementInfo
@for TagsDocumentReady
**/
function tagsDocumentReadyChangeMediaElementInfo() {
  $('body').on('click', '._change_info_container ._tags_container .remove', function() {
    var media_element_id = $(this).parent().parent().parent().parent().parent().data('param');
    removeFromTagsValue($(this).parent().text(), '#dialog-media-element-' + media_element_id + ' ._tags_container ._tags_value');
    $(this).parent().remove();
    if($('#dialog-media-element-' + media_element_id + ' #tags').not(':visible')) {
      $('#dialog-media-element-' + media_element_id + ' #tags').show();
      disableTagsInputTooHigh('#dialog-media-element-' + media_element_id + ' ._tags_container', '#dialog-media-element-' + media_element_id + ' #tags');
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
      addTagWithoutSuggestion(this, '#dialog-media-element-' + media_element_id + ' ._tags_container', '._tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $('body').on('blur', '._change_info_container #tags', function(e) {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    addTagWithoutSuggestion(this, '#dialog-media-element-' + media_element_id + ' ._tags_container', '._tags_value');
  });
  $('._change_info_container').each(function() {
    var media_element_id = $(this).data('param');
    initTagsAutocomplete('#dialog-media-element-' + media_element_id);
    (function() {
      disableTagsInputTooHigh('#dialog-media-element-' + media_element_id + ' ._tags_container', '#dialog-media-element-' + media_element_id + ' #tags');
    });
  });
}

/**
bla bla bla
@method tagsDocumentReadyMediaElementLoader
@for TagsDocumentReady
**/
function tagsDocumentReadyMediaElementLoader() {
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
}

/**
bla bla bla
@method tagsDocumentReadyNewLesson
@for TagsDocumentReady
**/
function tagsDocumentReadyNewLesson() {
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
}

/**
bla bla bla
@method tagsDocumentReadyNewMediaElement
@for TagsDocumentReady
**/
function tagsDocumentReadyNewMediaElement() {
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
}

/**
bla bla bla
@method tagsDocumentReadyOvervriteMediaElement
@for TagsDocumentReady
**/
function tagsDocumentReadyOvervriteMediaElement() {
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
}

/**
bla bla bla
@method tagsDocumentReadyUpdateLesson
@for TagsDocumentReady
**/
function tagsDocumentReadyUpdateLesson() {
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
}





/**
Initialize jQueryUI _autocomplete_ for tags in search input Uses: [unbindLoader](../classes/unbindLoader.html#method_unbindLoader) and [bindLoader](../classes/bindLoader.html#method_bindLoader)
@method initSearchTagsAutocomplete
@for TagsInitializers
@param input {String} search by tag input selector, class or id
**/
function initSearchTagsAutocomplete(input) {
  var cache = {};
  $(input).autocomplete({
    minLength: 2,
    source: function(request, response) {
      var term = request.term;
      if(term in cache) {
        response(cache[term]);
        return;
      }
      $.ajax({
        dataType: 'json',
        beforeSend: unbindLoader(),
        url: '/tags/get_list',
        data: request,
        success: function(data, status, xhr) {
          cache[term] = data;
          response(data);
        }
      }).always(bindLoader);
    }
  });
}

/**
Initialize jQueryUI _autocomplete_ for tags in lessons and elements form
@method initTagsAutocomplete
@for TagsInitializers
@param scope {String} tags container scope, class or id
**/
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
      $.ajax({
        dataType: 'json',
        beforeSend: unbindLoader(),
        url: '/tags/get_list',
        data: {term: request.term},
        success: response
      }).always(bindLoader);
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
