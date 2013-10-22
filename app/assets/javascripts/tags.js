/**
The functions in this module handle two different functionalities of <b>autocomplete</b> for tags: suggestions for a research (<b>search autocomplete</b>), and suggestions for tagging lessons and media elements (<b>tagging autocomplete</b>). Both modes use the same JQuery plugin called <i>JQueryAutocomplete</i> (the same used in {{#crossLink "AdminAutocomplete/initNotificationsAutocomplete:method"}}{{/crossLink}}).
<br/><br/>
The <b>search</b> autocomplete mode requires a simple initializer (method {{#crossLink "TagsInitializers/initSearchTagsAutocomplete:method"}}{{/crossLink}}), which is called for three different keyword inputs of the search engine (the general one, the one for elements and the one for lessons, see {{#crossLink "TagsDocumentReady/tagsDocumentReady:method"}}{{/crossLink}}).
<br/><br/>
The <b>tagging</b> autocomplete mode is slightly more complicated, because it must show to the user a friendly view of the tags he added (small boxes with an 'x' to remove it) and at the same time store a string value to be send to the rails backend. The implemented solution is a <b>container</b> div that contains a list of tag <b>boxes</b> (implemented with span, see {{#crossLink "TagsAccessories/createTagSpan:method"}}{{/crossLink}}) and an <b>tag input</b> where the user writes; when he inserts a new tag and presses <i>enter</i> or <i>comma</i>, the tag is added to the previous line in the container; if such a line is full, the tag input is moved to the next line; when the lines in the container are over, the tag input gets disabled (see {{#crossLink "TagsAccessories/disableTagsInputTooHigh:method"}}{{/crossLink}}). During this whole process, a <b>hidden input</b> gets updated with a string representing the current tags separated by comma ({{#crossLink "TagsAccessories/addToTagsValue:method"}}{{/crossLink}}, {{#crossLink "TagsAccessories/removeFromTagsValue:method"}}{{/crossLink}}).
<br/><br/>
The system also checks if the inserted tag is not repeated (using {{#crossLink "TagsAccessories/checkNoTagDuplicates:method"}}{{/crossLink}}), and assigns a different color for tags already in the database and for new ones ({{#crossLink "TagsAccessories/addTagWithoutSuggestion:method"}}{{/crossLink}}).
<br/><br/>
The <b>tagging autocomplete mode</b> is initialized for six standard forms (see initializers in the class {{#crossLink "TagsDocumentReady"}}{{/crossLink}}).
@module tags
**/





/**
Adds a tag without using the suggestion (the case with the suggestion is handled by {{#crossLink "TagsInitializers/initTagsAutocomplete:method"}}{{/crossLink}}). In the particular case in which the user adds the tag <b>before</b> the autocomplete has shown the list of matches, this method calls a route from the backend that checks if the tag was present in the database: if yes, the tag gets colored differently.
@method addTagWithoutSuggestion
@for TagsAccessories
@param input {String} HTML selector for the tag input
@param container_selector {String} HTML selector for the container
@param tags_value_selector {String} HTML selector for the hidden input
**/
function addTagWithoutSuggestion(input, container_selector, tags_value_selector) {
  var my_val = $.trim($(input).val()).toLowerCase();
  if(my_val.length >= $parameters.data('min-tag-length') && checkNoTagDuplicates(my_val, container_selector)) {
    if($('.ui-autocomplete a').first().text() == my_val) {
      addToTagsValue(my_val, (container_selector + ' ' + tags_value_selector));
      createTagSpan(my_val, false).insertBefore(input);
    } else {
      addToTagsValue(my_val, (container_selector + ' ' + tags_value_selector));
      createTagSpan(my_val, true).insertBefore(input);
      unbindLoader();
      $.ajax({
        type: 'get',
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
Adds a tag to the <b>hidden input</b>.
@method addToTagsValue
@for TagsAccessories
@param word {String} tag to be inserted
@param value_selector {String} HTML selector for the hidden input
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
Checks if a tag is already present in the hidden input.
@method checkNoTagDuplicates
@for TagsAccessories
@param word {String} tag to be checked
@param container_selector {String} HTML selector for the container
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
Creates a new span box for a tag.
@method createTagSpan
@for TagsAccessories
@param word {String} tag to be created
@param new_tag {Boolean} true if it must be colored as a tag not present in the database yet
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
Disables the tag input if the container is full.
@method disableTagsInputTooHigh
@for TagsAccessories
@param container_selector {String} HTML selector for the container
@param input_selector {String} HTML selector for the tag input
**/
function disableTagsInputTooHigh(container_selector, input_selector) {
  if($(container_selector)[0].scrollHeight > $(container_selector).height()) {
    $(input_selector).hide();
  }
}

/**
Generates a unique class for a given tag (containing underscores, and taking into consideration special characters).
@method getUnivoqueClassForTag
@for TagsAccessories
@param word {String} tag
@return {String} unique class for that tag
**/
function getUnivoqueClassForTag(word) {
  var resp = '';
  for(var i = 0; i < word.length; i++) {
    resp += '_' + word.charCodeAt(i);
  }
  return resp
}

/**
Removes a tag from the <b>hidden input</b>.
@method removeFromTagsValue
@for TagsAccessories
@param word {String} tag to be removed
@param value_selector {String} HTML selector for the hidden input
**/
function removeFromTagsValue(word, value_selector) {
  var old_value = $(value_selector).val();
  old_value = old_value.replace((',' + word + ','), ',');
  $(value_selector).val(old_value);
}





/**
Global initializer for all instances of search autocomplete and tagging autocomplete.
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
Initializer for tagging autocomplete in the form to <b>change the general information of a media element</b> (see {{#crossLink "DialogsWithForm/showMediaElementInfoPopUp:method"}}{{/crossLink}}).
@method tagsDocumentReadyChangeMediaElementInfo
@for TagsDocumentReady
**/
function tagsDocumentReadyChangeMediaElementInfo() {
  $body.on('click', '._change_info_container ._tags_container .remove', function() {
    var media_element_id = $(this).parent().parent().parent().parent().parent().data('param');
    removeFromTagsValue($(this).parent().text(), '#dialog-media-element-' + media_element_id + ' ._tags_container ._tags_value');
    $(this).parent().remove();
    if($('#dialog-media-element-' + media_element_id + ' #tags').not(':visible')) {
      $('#dialog-media-element-' + media_element_id + ' #tags').show();
      disableTagsInputTooHigh('#dialog-media-element-' + media_element_id + ' ._tags_container', '#dialog-media-element-' + media_element_id + ' #tags');
    }
  });
  $body.on('focus', '._change_info_container ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '._change_info_container ._tags_container', function() {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    $('#dialog-media-element-' + media_element_id + ' #tags').focus();
    $(this).find('._placeholder').hide();
  });
  $body.on('keydown', '._change_info_container #tags', function(e) {
    var media_element_id = $(this).parent().parent().parent().parent().data('param');
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#dialog-media-element-' + media_element_id + ' ._tags_container', '._tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '._change_info_container #tags', function(e) {
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
Initializer for tagging autocomplete in the form to <b>upload a new media element</b> (see {{#crossLink "DialogsWithForm/showLoadMediaElementPopUp:method"}}{{/crossLink}} and the module {{#crossLinkModule "media-element-loader"}}{{/crossLinkModule}}).
@method tagsDocumentReadyMediaElementLoader
@for TagsDocumentReady
**/
function tagsDocumentReadyMediaElementLoader() {
  $body.on('click', '#load-media-element ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#load-media-element ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#load-media-element #tags').not(':visible')) {
      $('#load-media-element #tags').show();
      disableTagsInputTooHigh('#load-media-element ._tags_container', '#load-media-element #tags');
    }
  });
  $body.on('focus', '#load-media-element ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '#load-media-element ._tags_container', function() {
    $('#load-media-element #tags').focus();
    $(this).find('._placeholder').hide();
  });
  $body.on('keydown', '#load-media-element #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#load-media-element ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '#load-media-element #tags', function(e) {
    addTagWithoutSuggestion(this, '#load-media-element ._tags_container', '#tags_value');
  });
  initTagsAutocomplete('#load-media-element');
}

/**
Initializer for tagging autocomplete in the form to <b>create a new lesson</b>.
@method tagsDocumentReadyNewLesson
@for TagsDocumentReady
**/
function tagsDocumentReadyNewLesson() {
  $body.on('click', '#slides._new ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#slides._new ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#slides._new #tags').not(':visible')) {
      $('#slides._new #tags').show();
      disableTagsInputTooHigh('#slides._new ._tags_container', '#slides._new #tags');
    }
  });
  $body.on('focus', '#slides._new ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '#slides._new ._tags_container', function() {
    $('#slides._new #tags').focus();
    $(this).find('._placeholder').hide();
  });
  $body.on('keydown', '#slides._new #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#slides._new ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '#slides._new #tags', function(e) {
    addTagWithoutSuggestion(this, '#slides._new ._tags_container', '#tags_value');
  });
  initTagsAutocomplete('#slides._new');
}

/**
Initializer for tagging autocomplete in the form to <b>save as new an element in the {{#crossLinkModule "media-element-editor"}}{{/crossLinkModule}}</b> (see the method {{#crossLink "MediaElementEditorForms/resetMediaElementEditorForms:method"}}{{/crossLink}}).
@method tagsDocumentReadyNewMediaElement
@for TagsDocumentReady
**/
function tagsDocumentReadyNewMediaElement() {
  $body.on('click', '#form_info_new_media_element_in_editor ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#form_info_new_media_element_in_editor ._tags_container #new_tags_value');
    $(this).parent().remove();
    if($('#form_info_new_media_element_in_editor #new_tags').not(':visible')) {
      $('#form_info_new_media_element_in_editor #new_tags').show();
      disableTagsInputTooHigh('#form_info_new_media_element_in_editor ._tags_container', '#form_info_new_media_element_in_editor #new_tags');
    }
  });
  $body.on('focus', '#form_info_new_media_element_in_editor ._tags_container', function() {
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags #check_ad_hoc').removeAttr('disabled').removeClass('disabled').removeAttr('checked');
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '#form_info_new_media_element_in_editor ._tags_container', function() {
    $('#form_info_new_media_element_in_editor #only_to_conserve_tags #check_ad_hoc').removeAttr('disabled').removeClass('disabled').removeAttr('checked');
    $('#form_info_new_media_element_in_editor #new_tags').focus();
    $(this).find('._placeholder').hide();
  });
  $body.on('keydown', '#form_info_new_media_element_in_editor #new_tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#form_info_new_media_element_in_editor ._tags_container', '#new_tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '#form_info_new_media_element_in_editor #new_tags', function(e) {
    addTagWithoutSuggestion(this, '#form_info_new_media_element_in_editor ._tags_container', '#new_tags_value');
  });
  initTagsAutocomplete('#form_info_new_media_element_in_editor');
}

/**
Initializer for tagging autocomplete in the form to <b>overwrite an element in the {{#crossLinkModule "media-element-editor"}}{{/crossLinkModule}}</b> (see the method {{#crossLink "MediaElementEditorForms/resetMediaElementEditorForms:method"}}{{/crossLink}}).
@method tagsDocumentReadyOvervriteMediaElement
@for TagsDocumentReady
**/
function tagsDocumentReadyOvervriteMediaElement() {
  $body.on('click', '#form_info_update_media_element_in_editor ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#form_info_update_media_element_in_editor ._tags_container #update_tags_value');
    $(this).parent().remove();
    if($('#form_info_update_media_element_in_editor #update_tags').not(':visible')) {
      $('#form_info_update_media_element_in_editor #update_tags').show();
      disableTagsInputTooHigh('#form_info_update_media_element_in_editor ._tags_container', '#form_info_update_media_element_in_editor #update_tags');
    }
  });
  $body.on('focus', '#form_info_update_media_element_in_editor ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '#form_info_update_media_element_in_editor ._tags_container', function() {
    $('#form_info_update_media_element_in_editor #update_tags').focus();
    $(this).find('._placeholder').hide();
  });
  $body.on('keydown', '#form_info_update_media_element_in_editor #update_tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#form_info_update_media_element_in_editor ._tags_container', '#update_tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '#form_info_update_media_element_in_editor #update_tags', function(e) {
    addTagWithoutSuggestion(this, '#form_info_update_media_element_in_editor ._tags_container', '#update_tags_value');
  });
  initTagsAutocomplete('#form_info_update_media_element_in_editor');
  (function() {
    disableTagsInputTooHigh('#form_info_update_media_element_in_editor ._tags_container', '#form_info_update_media_element_in_editor #update_tags');
  });
}

/**
Initializer for tagging autocomplete in the form to <b>update the general information of a lesson</b>.
@method tagsDocumentReadyUpdateLesson
@for TagsDocumentReady
**/
function tagsDocumentReadyUpdateLesson() {
  $body.on('click', '#slides._update ._tags_container .remove', function() {
    removeFromTagsValue($(this).parent().text(), '#slides._update ._tags_container #tags_value');
    $(this).parent().remove();
    if($('#slides._update #tags').not(':visible')) {
      $('#slides._update #tags').show();
      disableTagsInputTooHigh('#slides._update ._tags_container', '#slides._update #tags');
    }
  });
  $body.on('focus', '#slides._update ._tags_container', function() {
    $(this).find('._placeholder').hide();
  });
  $body.on('click', '#slides._update ._tags_container', function() {
    $('#slides._update #tags').focus();
  });
  $body.on('keydown', '#slides._update #tags', function(e) {
    if(e.which === 13 || e.which === 188) {
      e.preventDefault();
      addTagWithoutSuggestion(this, '#slides._update ._tags_container', '#tags_value');
    } else if(e.which == 8 && $(this).val() == '') {
      $(this).prev().find('.remove').trigger('click');
    }
  });
  $body.on('blur', '#slides._update #tags', function(e) {
    addTagWithoutSuggestion(this, '#slides._update ._tags_container', '#tags_value');
  });
  initTagsAutocomplete('#slides._update');
  (function() {
    disableTagsInputTooHigh('#slides._update ._tags_container', '#slides._update #tags');
  });
}





/**
Initializer for search autocompĺete.
@method initSearchTagsAutocomplete
@for TagsInitializers
@param input {String} HTML selector for the input
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
      unbindLoader();
      $.ajax({
        dataType: 'json',
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
Initializer for tagging autocompĺete.
@method initTagsAutocomplete
@for TagsInitializers
@param scope {String} HTML scope for the tag container
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
      unbindLoader();
      $.ajax({
        dataType: 'json',
        url: '/tags/get_list',
        data: {term: request.term},
        success: response
      }).always(bindLoader);
    },
    search: function() {
      if(this.value.length < $parameters.data('min-length-search-tags')) {
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
