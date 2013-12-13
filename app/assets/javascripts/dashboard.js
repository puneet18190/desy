function expandLessonsInDashboard() {
  var container = $('#dashboard_container');
  container.find('.title_lessons .expand_icon.off').hide();
  container.find('.title_lessons .expand_icon.on').show();
  $('#dashboard_container .space_lessons').animate({height: '660px'}, 500, function() {
    container.data('lessons-expanded', true);
    $('#dashboard_container .pagination_lessons').animate({height: '60px'}, 40);
    unbindLoader();
    $.ajax({
      type: 'get',
      url: '/dashboard/lessons?for_row=' + container.data('lessons-in-space') + '&expanded=true'
    }).always(bindLoader);
  });
}

function expandMediaElementsInDashboard() {
  var container = $('#dashboard_container');
  container.find('.title_media_elements .expand_icon.off').hide();
  container.find('.title_media_elements .expand_icon.on').show();
  // if lessons are expanded the height is 72 + 61 + 30 + 20 + 70 + 660 + 60 + 50 + 70 + 660 + 60 = 1813
  // otherwise the height is 72 + 61 + 30 + 20 + 70 + 315 + 50 + 70 + 660 + 60 = 1408
  var scroll_height = (container.data('lessons-expanded') ? 1813 : 1408) - $(window).height() + $('.global-footer').height();
  browserDependingScrollToTag().animate({scrollTop: (scroll_height + 'px')}, 500);
  $('#dashboard_container .space_media_elements').animate({height: '660px'}, 500, function() {
    container.data('media-elements-expanded', true);
    $('#dashboard_container .pagination_media_elements').animate({height: '60px'}, 40);
    unbindLoader();
    $.ajax({
      type: 'get',
      url: '/dashboard/media_elements?for_row=' + container.data('media-elements-in-space') + '&expanded=true'
    }).always(bindLoader);
  });
}

function compressLessonsInDashboard() {
  var container = $('#dashboard_container');
  container.find('.title_lessons .expand_icon.on').hide();
  container.find('.title_lessons .expand_icon.off').show();
  $('#dashboard_container .pagination_lessons').animate({height: '0px'}, 40, function() {
    $('#dashboard_container .space_lessons').animate({height: '315px'}, 500, function() {
      container.data('lessons-expanded', false);
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard/lessons?for_row=' + container.data('lessons-in-space')
      }).always(bindLoader);
      if(container.find('.space_lessons .page1 .lesson_in_dashboard').length <= container.data('lessons-in-space')) {
        $('#dashboard_container .title_lessons .expand_icon.off').removeClass('off').addClass('disabled');
      }
    });
  });
}

function compressMediaElementsInDashboard() {
  var container = $('#dashboard_container');
  container.find('.title_media_elements .expand_icon.on').hide();
  container.find('.title_media_elements .expand_icon.off').show();
  $('#dashboard_container .pagination_media_elements').animate({height: '0px'}, 40, function() {
    $('#dashboard_container .space_media_elements').animate({height: '315px'}, 500, function() {
      container.data('media-elements-expanded', false);
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard/media_elements?for_row=' + container.data('media-elements-in-space')
      }).always(bindLoader);
      if(container.find('.space_media_elements .page1 .boxViewExpandedMediaElement').length <= container.data('media-elements-in-space')) {
        $('#dashboard_container .title_media_elements .expand_icon.off').removeClass('off').addClass('disabled');
      }
    });
  });
}

function openDescriptionDashboardLayer(item) {
  var tot_time = 200;
  var h_i = item.height();
  var h_f = 263 - h_i;
  var k = h_f / (tot_time * tot_time);
  item.find('.description').show();
  item.data('moving', true);
  openDescriptionDashboardRecursionLayer(item, 0, h_i, h_f, tot_time);
}

function openDescriptionDashboardRecursionLayer(item, t, h_i, h_f, tot_time) {
  var height = h_i + ((t * h_f) / tot_time);
  item.css('height', (height + 'px'));
  if(t < tot_time) {
    if(item.data('moving')) {
      setTimeout(function() {
        openDescriptionDashboardRecursionLayer(item, (t + 5), h_i, h_f, tot_time);
      }, 5);
    } else {
      item.animate({height: '80px'}, t, function() {
        item.find('.description').hide();
      });
    }
  } else {
    item.data('moving', false);
  }
}

function dashboardResizeController() {
  var container = $('#dashboard_container');
  var width = container.width();
  var lessons_in_space = parseInt((width - 20) / 320);
  var media_elements_in_space = parseInt((width - 20) / 222);
  var lessons_margin = (width - lessons_in_space * 300) / (lessons_in_space + 1);
  var lessons_width = lessons_in_space * (300 + lessons_margin) - lessons_margin;
  media_elements_in_space = parseInt((lessons_width - 207) / 207) + 1;
  if(lessons_in_space != container.data('lessons-in-space') || media_elements_in_space != container.data('media-elements-in-space')) {
    container.data('lessons-in-space', lessons_in_space);
    container.data('media-elements-in-space', media_elements_in_space);
    var dashboard_url = '/dashboard?media_elements_for_row=' + media_elements_in_space;
    dashboard_url += '&lessons_for_row=' + lessons_in_space;
    if(container.data('lessons-expanded')) {
      dashboard_url += '&lessons_expanded=true';
    }
    if(container.data('media-elements-expanded')) {
      dashboard_url += '&media_elements_expanded=true';
    }
    unbindLoader();
    $.ajax({
      type: 'get',
      url: dashboard_url
    }).always(bindLoader);
  } else {
    resizeLessonsAndMediaElementsInDashboard(lessons_in_space, media_elements_in_space);
  }
}

function emptyAllPagesInDashboard(selector) {
  var container = $('#dashboard_container .space_' + selector);
  container.find('.page1').html('');
  container.find('.page2').html('');
  container.find('.page3').html('');
  container.find('.page4').html('');
  container.find('.page5').html('');
  container.find('.page6').html('');
}

function resizeLessonsAndMediaElementsInDashboard(lessons, media_elements) {
  var container = $('#dashboard_container');
  var lessons_margin = (container.width() - lessons * 300) / (lessons + 1);
  container.find('.space_lessons .lesson_in_dashboard').css('margin-left', lessons_margin + 'px');
  container.find('.title_lessons .icon').css('margin-left', lessons_margin + 'px');
  var new_calc = 2 * lessons_margin + 90;
  container.find('.title_lessons .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
  var first_media_element = container.find('.space_media_elements .boxViewExpandedMediaElement').first();
  first_media_element.css('margin-left', lessons_margin + 'px');
  var first_media_element_of_second_row = $(container.find('.space_media_elements .boxViewExpandedMediaElement')[media_elements]);
  first_media_element_of_second_row.css('margin-left', lessons_margin + 'px');
  var media_elements_margin = (container.width() - (2 * lessons_margin) - media_elements * 202) / (media_elements - 1);
  container.find('.space_media_elements .boxViewExpandedMediaElement').each(function() {
    if($(this).attr('id') != first_media_element.attr('id') && $(this).attr('id') != first_media_element_of_second_row.attr('id')) {
      $(this).css('margin-left', media_elements_margin + 'px');
    }
  });
  container.find('.title_media_elements .icon').css('margin-left', lessons_margin + 'px');
  var new_calc = 2 * lessons_margin + 90;
  container.find('.title_media_elements .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
}

function dashboardDocumentReady() {
  dashboardResizeController();
  $(window).resize(function() {
    dashboardResizeController();
  });
  $body.on('mouseenter', '.lesson_dashboard_hover_sensitive', function() {
    var item = $(this).find('.literature_container');
    item.data('delaying', true);
    setTimeout(function() {
      if(item.data('delaying')) {
        openDescriptionDashboardLayer(item);
      }
    }, 500);
  });
  $body.on('mouseleave', '.lesson_dashboard_hover_sensitive', function() {
    var item = $(this).find('.literature_container');
    item.data('delaying', false);
    if(item.data('moving')) {
      item.data('moving', false);
    } else {
      item.animate({height: '80px'}, 200, function() {
        item.find('.description').hide();
      });
    }
  });
  $body.on('click', '#dashboard_container .title_lessons .expand_icon.off', function() {
    expandLessonsInDashboard();
  });
  $body.on('click', '#dashboard_container .title_media_elements .expand_icon.off', function() {
    expandMediaElementsInDashboard();
  });
  $body.on('click', '#dashboard_container .title_lessons .expand_icon.on', function() {
    compressLessonsInDashboard();
  });
  $body.on('click', '#dashboard_container .title_media_elements .expand_icon.on', function() {
    compressMediaElementsInDashboard();
  });
}
