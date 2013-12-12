function expandLessonsInDashboard() {
  var container = $('#dashboard_container');
  var space_lessons = $('#dashboard_container .space_lessons');
  var space_media_elements = $('#dashboard_container .space_media_elements');
  var pagination_lessons = $('#dashboard_container .pagination_lessons');
  container.find('.title_lessons .expand_icon.off').hide();
  container.find('.title_lessons .expand_icon.on').show();
  space_lessons.css('z-index', 2);
  pagination_lessons.css('z-index', 2);
  space_media_elements.css('z-index', 1);
  container.find('.title_media_elements').css('z-index', 1);
  space_lessons.animate({height: '660px'}, 500, function() {
    container.data('status', 'lessons');
    container.data('lessons-in-space', 0);
    container.data('media-elements-in-space', 0);
    space_media_elements.html('');
    dashboardResizeController();
    pagination_lessons.animate({height: '60px'}, 40);
  });
}

function expandMediaElementsInDashboard() {
  var container = $('#dashboard_container');
  var space_media_elements = $('#dashboard_container .space_media_elements');
  var space_lessons = $('#dashboard_container .space_lessons');
  var pagination_media_elements = $('#dashboard_container .pagination_media_elements');
  container.find('.title_media_elements .expand_icon.off').hide();
  container.find('.title_media_elements .expand_icon.on').show();
  space_media_elements.css('z-index', 2);
  pagination_media_elements.css('z-index', 2);
  space_lessons.css('z-index', 1);
  container.find('.title_lessons').css('z-index', 1);
  space_media_elements.animate({height: '660px'}, 500, function() {
    container.data('status', 'media_elements');
    container.data('media-elements-in-space', 0);
    container.data('lessons-in-space', 0);
    space_lessons.html('');
    dashboardResizeController();
    pagination_media_elements.animate({height: '60px'}, 40);
  });
}

function compressLessonsInDashboard() {
  $('#dashboard_container .title_lessons .expand_icon.on').hide();
  $('#dashboard_container .title_lessons .expand_icon.off').show();
  console.log('comprimiamo le lezioni');
}

function compressMediaElementsInDashboard() {
  $('#dashboard_container .title_media_elements .expand_icon.on').hide();
  $('#dashboard_container .title_media_elements .expand_icon.off').show();
  console.log('comprimiamo gli elementi');
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
  if(container.data('status') == 'lessons') {
    if(lessons_in_space != container.data('lessons-in-space')) {
      container.data('lessons-in-space', lessons_in_space);
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?lessons_for_raw=' + lessons_in_space
      }).always(bindLoader);
    } else {
      resizeLessonsInDashboard(lessons_in_space);
    }
  } else if(container.data('status') == 'media_elements') {
    if(media_elements_in_space != container.data('media-elements-in-space')) {
      container.data('media-elements-in-space', media_elements_in_space);
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_raw=' + media_elements_in_space
      }).always(bindLoader);
    } else {
      resizeMediaElementsInDashboard(media_elements_in_space);
    }
  } else {
    var lessons_margin = (width - lessons_in_space * 300) / (lessons_in_space + 1);
    var lessons_width = lessons_in_space * (300 + lessons_margin) - lessons_margin;
    media_elements_in_space = parseInt((lessons_width - 207) / 207) + 1;
    if(lessons_in_space != container.data('lessons-in-space') || media_elements_in_space != container.data('media-elements-in-space')) {
      container.data('lessons-in-space', lessons_in_space);
      container.data('media-elements-in-space', media_elements_in_space);
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_raw=' + media_elements_in_space + '&lessons_for_raw=' + lessons_in_space
      }).always(bindLoader);
    } else {
      resizeBothLessonsAndMediaElementsInDashboard(lessons_in_space, media_elements_in_space);
    }
  }
}

function resizeBothLessonsAndMediaElementsInDashboard(lessons, media_elements) {
  var container = $('#dashboard_container');
  var lessons_margin = resizeLessonsInDashboard(lessons);
  var first_media_element = container.find('.space_media_elements .boxViewExpandedMediaElement').first();
  first_media_element.css('margin-left', lessons_margin + 'px');
  var media_elements_margin = (container.width() - (2 * lessons_margin) - media_elements * 202) / (media_elements - 1);
  container.find('.space_media_elements .boxViewExpandedMediaElement').each(function() {
    if($(this).attr('id') != first_media_element.attr('id')) {
      $(this).css('margin-left', media_elements_margin + 'px');
    }
  });
  container.find('.title_media_elements .icon').css('margin-left', lessons_margin + 'px');
  var new_calc = 2 * lessons_margin + 90;
  container.find('.title_media_elements .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
}

function resizeLessonsInDashboard(num) {
  var container = $('#dashboard_container');
  var margin = (container.width() - num * 300) / (num + 1);
  container.find('.space_lessons .lesson_in_dashboard').css('margin-left', margin + 'px');
  container.find('.title_lessons .icon').css('margin-left', margin + 'px');
  var new_calc = 2 * margin + 90;
  container.find('.title_lessons .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
  return margin;
}

function resizeMediaElementsInDashboard(num) {
  var container = $('#dashboard_container');
  var margin = (container.width() - num * 202) / (num + 1);
  container.find('.space_media_elements .boxViewExpandedMediaElement').css('margin-left', margin + 'px');
  container.find('.title_media_elements .icon').css('margin-left', margin + 'px');
  var new_calc = 2 * margin + 90;
  container.find('.title_media_elements .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
  return margin;
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
