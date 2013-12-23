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
Same structure of {{#crossLink "DashboardResizing/dashboardResizeController:method"}}{{/crossLink}}.
@method mediaElementsResizeController
@for GeneralCentering
**/
function mediaElementsResizeController() {
  var container = $('#my_media_elements');
  var info = $('#info_container');
  var width = container.width();
  var in_space = parseInt((width - 20) / 220);
  var margin = (width - in_space * 200) / (in_space + 1);
  var tot_width = in_space * (200 + margin) - margin;
  if(in_space <= 50 && in_space != info.data('in-space')) {
    info.data('in-space', in_space);
    resizeExpandedMediaElements(in_space);
    unbindLoader();
    $.ajax({
      type: 'get',
      url: '/media_elements?&for_row=' + in_space // TODO meddia manca currenturl
    }).always(bindLoader);
  } else {
    resizeExpandedMediaElements(in_space);
  }
}

/**
Same structure of {{#crossLink "DashboardResizing/resizeLessonsAndMediaElementsInDashboard:method"}}{{/crossLink}}.
@method resizeExpandedMediaElements
@for GeneralCentering
@param for_row {Number} how many media elements fit horizontally the screen
**/
function resizeExpandedMediaElements(for_row) {
  var container = $('#my_media_elements');
  var margin = (container.width() - for_row * 200) / (for_row + 1);
  var counter = 1;
  container.find('._media_element_item').each(function() {
    $(this).css('margin-left', (margin + 'px'));
    if(counter > for_row) {
      $(this).css('margin-top', '30px');
    } else {
      $(this).css('margin-top', '0');
    }
    counter += 1;
  }
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
Initializer for functionalities which are common to sections containing media elements.
@method commonMediaElementsDocumentReady
@for GeneralDocumentReady
**/
function commonMediaElementsDocumentReady() {
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
}

/**
Initializer for functionalities which are common to sections containing lessons.
@method commonLessonsDocumentReady
@for GeneralDocumentReady
**/
function commonLessonsDocumentReady() {
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
}

/**
Initializer for global functionalities, used throughout the application.
@method globalDocumentReady
@for GeneralDocumentReady
**/
function globalDocumentReady() {
  $body.on('click', '._close_on_click_out', function() {
    $('.ui-dialog-content:visible').each(function() {
      closePopUp($(this).attr('id'));
    });
  });
  $body.on('mouseenter', '.empty-situation-container a', function() {
    $(this).find('.plus').addClass('encendido');
  });
  $body.on('mouseleave', '.empty-situation-container a', function() {
    $(this).find('.plus').removeClass('encendido');
  });
  $('#user_school_level_id').selectbox(); // TODO ottimizz prima o poi toglierla da qui, quando faccio pulizia con il profilo
  if(my_login.length > 0 && $(e.target).parents('#login_form_container').length == 0 && !$(e.target).hasClass('_show_login_form_container')) {
    $('._show_login_form_container').click();
  } // TODO ottimizz prima o poi toglierla da qui, quando faccio pulizia con il profilo
  $body.on('keyup blur', 'input[maxlength], textarea[maxlength]', function () {
    var myself = $(this);
    var len = myself.val().length;
    var maxlength = myself.attr('maxlength')
    if (maxlength && len > maxlength) {
      myself.val(myself.val().slice(0, maxlength));
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
Functionalities necessary only for the section 'my documents'.
@method sectionDocumentsDocumentReady
@for GeneralDocumentReady
**/
function sectionDocumentsDocumentReady() {
  $('#order_documents option[selected]').first().attr('selected', 'selected');
  $('#order_documents').selectbox();
}

/**
Functionalities necessary only for the section 'my lessons'.
@method sectionLessonsDocumentReady
@for GeneralDocumentReady
**/
function sectionLessonsDocumentReady() {
  $('#filter_lessons option[selected]').first().attr('selected', 'selected');
  $body.on('change', '#filter_lessons', function() {
    var filter = $('#filter_lessons option:selected').val();
    var redirect_url = '/lessons?filter=' + filter;
    $.get(redirect_url);
  });
  $('#filter_lessons').selectbox();
}

/**
Functionalities necessary only for the section 'my media elements'.
@method sectionMediaElementsDocumentReady
@for GeneralDocumentReady
**/
function sectionMediaElementsDocumentReady() {
  $('#filter_media_elements option[selected]').first().attr('selected', 'selected');
  $body.on('change', '#filter_media_elements', function() {
    var filter = $('#filter_media_elements option:selected').val();
    var display = 'compact';
    if($('#display_expanded_media_elements').hasClass('current')) {
      display = 'expanded';
    }
    var redirect_url = '/media_elements?display=' + display + '&filter=' + filter;
    $.get(redirect_url);
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
  $('#filter_media_elements').selectbox();
}

/**
Functionalities necessary only for the sections containing notifications.
@method sectionNotificationsDocumentReady
@for GeneralDocumentReady
**/
function sectionNotificationsDocumentReady() {
  $('#notifications_list').jScrollPane({
    autoReinitialise: true
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
  });
}

/**
Functionalities necessary only for the section 'search'.
@method sectionSearchDocumentReady
@for GeneralDocumentReady
**/
function sectionSearchDocumentReady() {
  $('._which_item_to_search_switch[checked]').first().attr('checked', 'checked');
  $('._order_lessons_radio_input[checked]').first().attr('checked', 'checked');
  $('._order_media_elements_radio_input[checked]').first().attr('checked', 'checked');
  $('#which_item_to_search option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons option[selected]').first().attr('selected', 'selected');
  $('#filter_search_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons_subject option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons_school_level option[selected]').first().attr('selected', 'selected');
  $('#which_item_to_search').selectbox();
  $('#filter_search_lessons').selectbox();
  $('#filter_search_media_elements').selectbox();
  $('#filter_search_lessons_subject').selectbox();
  $('#filter_search_lessons_school_level').selectbox();
}





/**
Initializes global variables used throughout the javascripts.
@method initializeGlobalVariables
@for GeneralMiscellanea
**/
function initializeGlobalVariables() {
  window.$html = $('html');
  window.$loaderVisible = true;
  window.$loading = $('#loading');
  window.$body = $('body');
  window.$captions = $('#popup_captions_container');
  window.$parameters = $('#popup_parameters_container');
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
