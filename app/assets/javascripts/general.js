/**
* Generic shared javascript functions
* 
* @module General
*/

function expandedItemsDocumentReady() {
  
  $('body').on('click','._lesson_compact', function() {
    if(!$(this).parent().hasClass('_disabled')) {
      var my_id = $(this).parent().attr('id');
      var my_expanded = $('#' + my_id + ' ._lesson_expanded');
      if(my_expanded.is(':visible')) {
        my_expanded.find('._report_form_content').hide();
        my_expanded.find('._reportable_icon').removeClass('report_light _report_selected').addClass('report');
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
  
  $('body').on('click', '#display_expanded_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=expanded'
      });
    }
  });
  
  $('body').on('click', '#display_compact_media_elements', function() {
    if(!$(this).hasClass('current')) {
      $.ajax({
        type: 'get',
        url: '/media_elements?display=compact'
      });
    }
  });
  
  $('body').on('click', '._close_media_element_preview_popup', function() {
    var param = $(this).data('param');
    closePopUp('dialog-media-element-' + param);
  });
  
  $('body').on('click', '._change_info_container ._cancel, ._change_info_to_pick.change_info_light', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').show();
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').hide('fade', {}, 500, function() {
      var icon = $(this);
      if(!$(this).hasClass('_change_info_to_pick')) {
        icon = $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_to_pick');
      }
      icon.addClass('change_info');
      icon.removeClass('change_info_light');
      resetMediaElementChangeInfo($(this).data('param'));
    });
  });
  
  $('body').on('click', '._change_info_to_pick.change_info', function() {
    $('#dialog-media-element-' + $(this).data('param') + ' ._change_info_container').show('fade', {}, 500);
    $(this).removeClass('change_info');
    $(this).addClass('change_info_light');
    $('#dialog-media-element-' + $(this).data('param') + ' ._audio_preview_in_media_element_popup').hide();
  });
  
}

function filtersDocumentReady() {
  
  $('body').on('change', '#filter_lessons', function() {
    var filter = $('#filter_lessons option:selected').val();
    var redirect_url = '/lessons?filter=' + filter;
    $.get(redirect_url);
  });
  
  $('body').on('change', '#filter_media_elements', function() {
    var filter = $('#filter_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutFilter() + '&filter=' + filter;
    $.get(redirect_url);
  });
  
  $('body').on('change', '#for_page_media_elements', function() {
    var for_page = $('#for_page_media_elements option:selected').val();
    var redirect_url = getCompleteMediaElementsUrlWithoutForPage() + '&for_page=' + for_page;
    $.get(redirect_url);
  });
  
}

function formsDocumentReady() {
  
  $('body').on('mouseover', '._report_lesson_click', function() {
    var obj = $('#' + this.id + ' a._reportable_icon');
    if(!obj.hasClass('_report_selected')) {
      obj.removeClass('report');
      obj.addClass('report_light');
    }
  });
  
  $('body').on('mouseout', '._report_lesson_click', function() {
    var obj = $('#' + this.id + ' a._reportable_icon');
    if(!obj.hasClass('_report_selected')) {
      obj.removeClass('report_light');
      obj.addClass('report');
    }
  });
  
  $('body').on('click', '._report_lesson_click', function() {
    var param = $(this).data('param');
    var obj = $('#lesson_report_form_' + param);
    if(!obj.is(':visible')) {
      var button = $('#' + this.id + ' a._reportable_icon');
      button.addClass('_report_selected');
      button.removeClass('report');
      button.addClass('report_light');
      obj.show('fade', {}, 500, function() {
        obj.show();
      });
    } else {
      var button = $('#' + this.id + ' a._reportable_icon');
      button.removeClass('_report_selected');
      button.removeClass('report_light');
      button.addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.hide();
      });
    }
    return false;
  });
  
  $('body').on('click', '._report_media_element_click', function() {
    var param = $(this).data('param');
    var obj = $('#media_element_report_form_' + param);
    if(!obj.is(':visible')) {
      $(this).removeClass('report');
      $(this).addClass('report_light');
      obj.show('fade', {}, 500, function() {
        obj.show();
      });
    } else {
      $(this).removeClass('report_light');
      $(this).addClass('report');
      obj.hide('fade', {}, 500, function() {
        obj.hide();
      });
    }
    return false;
  });
  
  $('body').on('click', '._report_form_content', function(e) {
    e.preventDefault();
    return false;
  });
  
  $('body').on('click', '._report_form_content ._send', function(e) {
    $(this).closest('form').submit();
  });
  
}

function javaScriptAnimationsDocumentReady() {
  $('#notifications_list').jScrollPane({
    autoReinitialise: true
  });
  $('#select_lesson_list').selectbox();
  $('#which_item_to_search').selectbox();
  $('#filter_lessons').selectbox();
  $('#filter_search_lessons').selectbox();
  $('#filter_search_lessons_subject').selectbox();
  $('#profile_school_level').selectbox();
  $('#profile_region').selectbox();
  $('#for_page_media_elements').selectbox();
  $('#filter_media_elements').selectbox();
  $('#filter_search_media_elements').selectbox();
  $('#user_school_level_id').selectbox();
  $('body').on('keyup blur', 'input[maxlength], textarea[maxlength]', function () {
    var myself = $(this);
    var len = myself.val().length;
    var maxlength = myself.attr('maxlength')
    if (maxlength && len > maxlength) {
      myself.val(myself.val().slice(0, maxlength));
    }
  });
}

function defaultValueJavaScriptAnimationsDocumentReady() {
  $('._which_item_to_search_switch[checked]').first().attr('checked', 'checked');
  $('#for_page_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_lessons option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons option[selected]').first().attr('selected', 'selected');
  $('#filter_search_media_elements option[selected]').first().attr('selected', 'selected');
  $('#filter_search_lessons_subject option[selected]').first().attr('selected', 'selected');
  $('._order_lessons_radio_input[checked]').first().attr('checked', 'checked');
  $('._order_media_elements_radio_input[checked]').first().attr('checked', 'checked');
}

function generalWindowResizeDocumentReady() {
  $(window).resize(function() {
    if($('#my_media_elements').length > 0 || $('#media_elements_in_dashboard').length > 0){
      recenterMyMediaElements();
    }
  });
  var hac = $('.home-action .container');
  var widc = $('.what_is_desy-action .container');
  if($(window).height()>hac.height()){
    hac.css('margin-top',($(window).height() - hac.height())/2 + 'px');
  }
  if($(window).height()>widc.height()){
    widc.css('margin-top',($(window).height() - widc.height())/2 + 'px');
  }
}

function getMediaElementsFormat() {
  var param = 'display=compact';
  if($('#display_expanded_media_elements').hasClass('current')) {
    param = 'display=expanded';
  }
  return param
}

function getCompleteMediaElementsUrlWithoutFilter() {
  var param_format = getMediaElementsFormat();
  var param_for_page = 'for_page=' + $('#for_page_media_elements option:selected').val();
  return '/media_elements?' + param_format + '&' + param_for_page;
}

function getCompleteMediaElementsUrlWithoutForPage() {
  var param_format = getMediaElementsFormat();
  var param_filter = 'filter=' + $('#filter_media_elements option:selected').val();
  return '/media_elements?' + param_format + '&' + param_filter;
}

/**
* Add new parameters to an url
* 
* @method updateURLParameter
* @for updateURLParameter
* @param url {String} starting url
* @param param {String} new param
* @param paramVal {String} new param value
* @return {String} updated url
*/
function updateURLParameter(url, param, paramVal) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i<tempArray.length; i++){
      if(tempArray[i].split('=')[0] != param){
        newAdditionalURL += temp + tempArray[i];
        temp = '&';
      }
    }
  }
  var rows_txt = temp + '' + param + '=' + paramVal;
  return baseURL + '?' + newAdditionalURL + rows_txt;
}

/**
* Remove a param from url
* 
* @method removeURLParameter
* @for removeURLParameter
* @param url {String} starting url
* @param param {String} param to remove
* @return {String} update url
*/
function removeURLParameter(url, param) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i<tempArray.length; i++){
      if(tempArray[i].split('=')[0] != param){
        newAdditionalURL += temp + tempArray[i];
        temp = '&';
      }
    }
  }
  return baseURL + '?' + newAdditionalURL;
}

/**
* Center a div into a given container
* 
* @method centerThisInContainer
* @for centerThisInContainer
* @param div {String} div selector to center, class or id
* @param container {String} container selector to center div into, class or id
* @example
      centerThisInContainer('._saved','#image_wrapper');
*/
function centerThisInContainer(div,container) {
  var contH = $(container).height();
  var contW = $(container).width();
  var centerDiv = $(div);
  centerDiv.css('top', (contH/2-centerDiv.height()/2)+$(container).position().top);
  centerDiv.css('left', (contW/2-centerDiv.width()/2)+$(container).position().left);
}

/**
* Center a div into current window
* 
* @method centerThis
* @for centerThis
* @param div {String} div selector to center, class or id
* @example
      centerThis("._slide_error");
*/
function centerThis(div) {
  var winH = $(window).height();
  var winW = $(window).width();
  var centerDiv = $(div);
  centerDiv.css('top', winH/2-centerDiv.height()/2);
  centerDiv.css('left', winW/2-centerDiv.width()/2);
}
