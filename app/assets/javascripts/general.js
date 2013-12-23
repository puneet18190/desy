/**
Generic javascript functions user throughout the application.
@module general
**/





/**
Calculates in which page the user is going to be redirected when he is watching a paginated list of items, and he resizes the screen. Used for example in the dashboard, and in the section of media elements.
@method calculateTheNewVisiblePage
@for GeneralCentering
@param for_page {Number} items for page before resizing
@param page {Number} page the user was visualizing before resizing
@param new_for_page {Number} items for page after resizing
**/
function calculateTheNewVisiblePage(for_page, page, new_for_page) {
  if(page == 1) {
    return 1;
  }
  var selected_item = for_page * (page - 1) + 1;
  return parseInt(selected_item / new_for_page) + 1;
}

/**
Centers a div into the current window.
@method centerThis
@for GeneralCentering
@param div {String} HTML selector to be centered
**/
function centerThis(div) {
  var winH = $(window).height();
  var winW = $(window).width();
  var centerDiv = $(div);
  centerDiv.css('top', winH/2 - centerDiv.height()/2);
  centerDiv.css('left', winW/2 - centerDiv.width()/2);
}

/**
Centers a div into a given container.
@method centerThisInContainer
@for GeneralCentering
@param div {String} HTML selector to be centered
@param container {String} HTML selector that represents the container in which the div must be centered
**/
function centerThisInContainer(div, container) {
  var contH = $(container).height();
  var contW = $(container).width();
  var centerDiv = $(div);
  centerDiv.css('top', (contH/2 - centerDiv.height()/2) + $(container).position().top);
  centerDiv.css('left', (contW/2 - centerDiv.width()/2) + $(container).position().left);
}





/**
This function guesses the browser and writes it in a class of the tag 'html'.
@method browsersDocumentReady
@for GeneralDocumentReady
**/
function browsersDocumentReady() {
  var name = $.grep(_.keys($.browser), function(el, i) {
    return el !== 'version';
  })[0];
  if(name) {
    $html.addClass(name);
  }
}

/**
This function sets the default values of SelectBoxe all around the application. This function is necessary because otherwise the original value wouldn't be set, since we use a JQuery plugin to design selects.
@method defaultValueJavaScriptAnimationsDocumentReady
@for GeneralDocumentReady
**/
function defaultValueJavaScriptAnimationsDocumentReady() {
  $('._which_item_to_search_switch[checked]').first().attr('checked', 'checked');
  $('#for_page_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_lessons option[selected]').first().attr('selected', 'selected');
  $('#order_documents option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons option[selected]').first().attr('selected', 'selected');
  $('#filter_search_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons_subject option[selected]').first().attr('selected', 'selected');
  $('._order_lessons_radio_input[checked]').first().attr('checked', 'checked');
  $('._order_media_elements_radio_input[checked]').first().attr('checked', 'checked');
}

/**
Initialization for all the functionalities of expanded lessons and media element popup (see also {{#crossLink "DialogsWithForm/showMediaElementInfoPopUp:method"}}{{/crossLink}}).
@method expandedItemsDocumentReady
@for GeneralDocumentReady
**/
function expandedItemsDocumentReady() {
  $body.on('click','._lesson_compact', function() {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_id = $(this).parent().attr('id');
      var my_expanded = $('#' + my_id + ' ._lesson_expanded');
      if(my_expanded.is(':visible')) {
        my_expanded.find('.tooltipForm:visible').parent().find('._reportable_lesson_icon').click();
        my_expanded.hide('blind', {}, 500, function() {
          my_expanded.hide();
        });
      } else {
        my_expanded.show('blind', {}, 500, function() {
          my_expanded.show();
        });
      }
    }
  });
  $body.on('click', '#display_expanded_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=expanded'
      });
    }
  });
  $body.on('click', '#display_compact_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=compact'
      });
    }
  });
  $body.on('click', '._close_media_element_preview_popup', function() {
    var param = $(this).data('param');
    closePopUp('dialog-media-element-' + param);
  });
  $body.on('click', '._change_info_container ._cancel, ._change_info_to_pick.change_info_light', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').show();
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').hide('fade', {}, 500, function() {
      var icon = $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_to_pick');
      icon.addClass('change_info');
      icon.removeClass('change_info_light');
      resetMediaElementChangeInfo($(this).data('param'));
    });
  });
  $body.on('click', '._change_info_to_pick.change_info', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').show('fade', {}, 500);
    $(this).removeClass('change_info');
    $(this).addClass('change_info_light');
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').hide();
  });
  $body.on('click', '._close_on_click_out', function() {
    $('.ui-dialog-content:visible').each(function() {
      closePopUp($(this).attr('id'));
    });
  });
}

/**
Similar to {{#crossLink "GeneralDocumentReady/defaultValueJavaScriptAnimationsDocumentReady:method"}}{{/crossLink}}, this function initializes the initial value of the raio buttons styled using a javascript plugin.
@method filtersDocumentReady
@for GeneralDocumentReady
**/
function filtersDocumentReady() {
  $body.on('change', '#filter_lessons', function() {
    var filter = $('#filter_lessons option:selected').val();
    var redirect_url = '/lessons?filter=' + filter;
    $.get(redirect_url);
  });
  $body.on('change', '#filter_media_elements', function() {
    var filter = $('#filter_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutFilter() + '&filter=' + filter;
    $.get(redirect_url);
  });
  $body.on('change', '#for_page_media_elements', function() {
    var for_page = $('#for_page_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutForPage() + '&for_page=' + for_page;
    $.get(redirect_url);
  });
}

/**
Initializer for all javascript and JQuery plugins.
@method javaScriptAnimationsDocumentReady
@for GeneralDocumentReady
**/
function javaScriptAnimationsDocumentReady() {
  $body.on('mouseenter', '.empty-situation-container a', function() {
    $(this).find('.plus').addClass('encendido');
  });
  $body.on('mouseleave', '.empty-situation-container a', function() {
    $(this).find('.plus').removeClass('encendido');
  });
  $('#notifications_list').jScrollPane({
    autoReinitialise: true
  });
  $('#which_item_to_search').selectbox();
  $('#filter_lessons').selectbox();
  $('#order_documents').selectbox();
  $('#filter_search_lessons').selectbox();
  $('#filter_search_lessons_subject').selectbox();
  $('#filter_search_lessons_school_level').selectbox();
  $('#for_page_media_elements').selectbox();
  $('#filter_media_elements').selectbox();
  $('#filter_search_media_elements').selectbox();
  $('#user_school_level_id').selectbox();
  $body.on('keyup blur', 'input[maxlength], textarea[maxlength]', function () {
    var myself = $(this);
    var len = myself.val().length;
    var maxlength = myself.attr('maxlength')
    if (maxlength && len > maxlength) {
      myself.val(myself.val().slice(0, maxlength));
    }
  });
  $(document).bind('click', function (e) {
    var click_id = $(e.target).attr('id');
    var my_report = $('.tooltipForm:visible');
    var my_login = $('#login_form_container:visible');
    if($('#tooltip_content').length > 0) {
      if($('#tooltip_content').is(':visible')) {
        if(click_id != 'tooltip_content' && click_id != 'expanded_notification' && click_id != 'notifications_button' && $(e.target).parents('#tooltip_content').length == 0 && $(e.target).parents('#expanded_notification').length == 0) {
          $('#notifications_button').trigger('click');
        }
      }
    }
    if($('#tooltip_help').length > 0) {
      if($('#tooltip_help').is(':visible')) {
        if(click_id != 'tooltip_help' && click_id != 'help' && $(e.target).parents('#tooltip_help').length == 0) {
          $('#help').trigger('click');
        }
      }
    }
    if(my_report.length > 0 && $(e.target).parents('#' + my_report.attr('id')).length == 0) {
      my_report.parent().find('.report_light, ._reportable_lesson_icon').click();
    }
    if(my_login.length > 0 && $(e.target).parents('#login_form_container').length == 0 && !$(e.target).hasClass('_show_login_form_container')) {
      $('._show_login_form_container').click();
    }
  });
}

/**
Initializer for locations automatic filling.
@method locationsDocumentReady
@for GeneralDocumentReady
**/
function locationsDocumentReady() {
  $('._location_select_box').each(function() {
    $('#' + $(this).attr('id')).selectbox();
  });
  $body.on('change', '._location_select_box', function() {
    if(!$(this).data('is-last')) {
      if($(this).val() == '0') {
        $(this).parents('._location_selector').nextAll().find('select').html('');
      } else {
        $.ajax({
          url: '/locations/' + $(this).val() + '/find',
          type: 'get'
        });
      }
    }
  });
}

/**
Initializes reports forms for both lessons and media elements.
@method reportsDocumentReady
@for GeneralDocumentReady
**/
function reportsDocumentReady() {
  $body.on('mouseenter', '._reportable_lesson_icon', function() {
    $(this).find('.icon-content').removeClass('report').addClass('report_light');
  });
  $body.on('mouseleave', '._reportable_lesson_icon', function() {
    $(this).find('.icon-content').addClass('report').removeClass('report_light');
  });
  $body.on('click', '._reportable_lesson_icon', function() {
    var obj = $(this).next();
    if(!obj.is(':visible')) {
      $(this).find('.icon-content').removeClass('report').addClass('report_light report_selected');
      obj.show('fade', {}, 500);
    } else {
      $(this).find('.icon-content').addClass('report').removeClass('report_light report_selected');
      obj.hide();
    }
    return false;
  });
  $body.on('click', '._report_media_element_click', function() {
    var obj = $(this).next();
    if(!obj.is(':visible')) {
      $(this).removeClass('report');
      $(this).addClass('report_light');
      obj.show('fade', {}, 500);
    } else {
      $(this).removeClass('report_light');
      $(this).addClass('report');
      obj.hide();
    }
    return false;
  });
  $body.on('click', '._report_form_content', function(e) {
    e.preventDefault();
    return false;
  });
  $body.on('click', '._report_form_content ._send', function(e) {
    $(this).closest('form').submit();
  });
}





/**
Gets the requested format to visualize media elements.
@method getMediaElementsFormat
@for GeneralMiscellanea
**/
function getMediaElementsFormat() {
  var param = 'display=compact';
  if($('#display_expanded_media_elements').hasClass('current')) {
    param = 'display=expanded';
  }
  return param
}

/**
Shows a red error icon when somethings goes wrong. Widely used in {{#crossLinkModule "lesson-editor"}}{{/crossLinkModule}} and in {{#crossLinkModule "image-editor"}}{{/crossLinkModule}}.
@method redError
@for GeneralMiscellanea
**/
function redError() {
  $body.prepend('<span class="_slide_error"></span>');
  centerThis('._slide_error');
  $('._slide_error').fadeTo('fast', 0).fadeTo('fast', 0.7).fadeTo('fast', 0.3).fadeOut();
}

/**
Function to convert seconds into a time string of the kind <i>02:35</i>; used in {{#crossLinkModule "video-editor"}}{{/crossLinkModule}} and in {{#crossLinkModule "audio-editor"}}{{/crossLinkModule}}.
@method secondsToDateString
@for GeneralMiscellanea
@param seconds {Number} the seconds to be converted
**/
function secondsToDateString(seconds) {
  var mm = parseInt(seconds / 60);
  var ss = seconds % 60;
  var hh = parseInt(mm / 60);
  mm = mm % 60;
  var resp = '';
  if(hh > 0) {
    resp = hh + ':';
  }
  if(mm > 9) {
    resp = mm + ':';
  } else {
    resp = '0' + mm + ':';
  }
  if(ss > 9) {
    resp = resp + ss;
  } else {
    resp = resp + '0' + ss;
  }
  return resp;
}

/**
Browser support checking, supported browsers version. It is empty. The not supported browsers version is implemented in {{#crossLink "BrowserSupportMain/browserSupportMain:method"}}{{/crossLink}}
@method browserSupport
@for GeneralMiscellanea
**/
function browserSupport() {
}

/**
This function returns an url for media elements without the parameter 'for_page'. The original url is extracted by the method {{#crossLink "GeneralMiscellanea/getMediaElementsFormat:method"}}{{/crossLink}}.
@method getCompleteMediaElementsUrlWithoutForPage
@for GeneralUrls
@return {String} the current url without the parameter 'for_page'
**/
function getCompleteMediaElementsUrlWithoutForPage() {
  var param_format = getMediaElementsFormat();
  var param_filter = 'filter=' + $('#filter_media_elements option:selected').val();
  return '/media_elements?' + param_format + '&' + param_filter;
}

/**
This function returns an url for media elements without the parameter 'filter'. The original url is extracted by the method {{#crossLink "GeneralMiscellanea/getMediaElementsFormat:method"}}{{/crossLink}}.
@method getCompleteMediaElementsUrlWithoutFilter
@for GeneralUrls
@return {String} the current url without the parameter 'filter'
**/
function getCompleteMediaElementsUrlWithoutFilter() {
  var param_format = getMediaElementsFormat();
  var param_for_page = 'for_page=' + $('#for_page_media_elements option:selected').val();
  return '/media_elements?' + param_format + '&' + param_for_page;
}

/**
This function returns an url for documents without the parameter 'order'. The original url is extracted by the method {{#crossLink "GeneralMiscellanea/getMediaElementsFormat:method"}}{{/crossLink}}.
@method getCompleteDocumentsUrlWithoutOrder
@for GeneralUrls
@return {String} the current url without the parameter 'order'
**/
function getCompleteDocumentsUrlWithoutOrder() {
  var param_word = 'word=' + $('#search_documents ._word_input').val() + '&word_placeholder=' + $('#search_documents_placeholder').val();
  return '/documents?' + param_word;
}

/**
Removes a parameter from an url.
@method removeURLParameter
@for GeneralUrls
@param url {String} initial url
@param param {String} param to remove
@return {String} updated url
**/
function removeURLParameter(url, param) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i < tempArray.length; i++) {
      if(tempArray[i].split('=')[0] != param) {
        newAdditionalURL += (temp + tempArray[i]);
        temp = '&';
      }
    }
  }
  return (baseURL + '?' + newAdditionalURL);
}

/**
Adds or update new parameters to an url.
@method updateURLParameter
@for GeneralUrls
@param url {String} initial url
@param param {String} parameter
@param paramVal {String} new value for the parameter
@return {String} updated url
**/
function updateURLParameter(url, param, paramVal) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i < tempArray.length; i++) {
      if(tempArray[i].split('=')[0] != param) {
        newAdditionalURL += (temp + tempArray[i]);
        temp = '&';
      }
    }
  }
  var rows_txt = temp + '' + param + '=' + paramVal;
  return (baseURL + '?' + newAdditionalURL + rows_txt);
}
