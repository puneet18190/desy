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
  var lessons = parseInt((width - 20) / 320);
  var media_elements = parseInt((width - 20) / 222);
  if(container.data('status') == 'lessons') {
    if(lessons != container.data('lessons')) {
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?lessons_for_page=' + lessons
      }).always(bindLoader);
    } else {
      resizeLessonsOrMediaElementsInDashboard(container, '.space_lessons .lesson_in_dashboard', '.title_lessons .icon', lessons, 300);
    }
  } else if(container.data('status') == 'media_elements') {
    if(media_elements != container.data('media-elements')) {
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements
      }).always(bindLoader);
    } else {
      resizeLessonsOrMediaElementsInDashboard(container, '.space_media_elements .boxViewExpandedMediaElement', '.title_media_elements .icon', media_elements, 202);
    }
  } else {
    var lessons_margin = (width - lessons * 300) / (lessons + 1);
    var lessons_space = lessons * (300 + lessons_margin) - lessons_margin;
    media_elements = parseInt((lessons_space - 207) / 207) + 1;
    if(lessons != container.data('lessons') || media_elements != container.data('media-elements')) {
      unbindLoader();
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements + '&lessons_for_page=' + lessons
      }).always(bindLoader);
    } else {
      resizeBothLessonsAndMediaElementsInDashboard(container, lessons, media_elements);
    }
  }
}

function resizeBothLessonsAndMediaElementsInDashboard(container, lessons, media_elements) {
  var lessons_margin = resizeLessonsOrMediaElementsInDashboard(container, '.space_lessons .lesson_in_dashboard', '.title_lessons .icon', lessons, 300);
  var first_media_element = container.find('.space_media_elements .boxViewExpandedMediaElement').first();
  first_media_element.css('margin-left', lessons_margin + 'px');
  var media_elements_margin = (container.width() - (2 * lessons_margin) - media_elements * 202) / (media_elements - 1);
  container.find('.space_media_elements .boxViewExpandedMediaElement').each(function() {
    if($(this).attr('id') != first_media_element.attr('id')) {
      $(this).css('margin-left', media_elements_margin + 'px');
    }
  });
  container.find('.title_media_elements .icon').css('margin-left', lessons_margin + 'px');
  var new_calc = lessons_margin + 210;
  container.find('.title_media_elements .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
}

function resizeLessonsOrMediaElementsInDashboard(container, selector, icon_selector, num, item_width) {
  var margin = (container.width() - num * item_width) / (num + 1);
  container.find(selector).css('margin-left', margin + 'px');
  container.find(icon_selector).css('margin-left', margin + 'px');
  var new_calc = margin + 210;
  container.find(icon_selector).next().css('width', 'calc(100% - ' + new_calc + 'px)');
  return margin;
}

function dashboardDocumentReady() {
  dashboardResizeController();
  $(window).resize(function() {
    dashboardResizeController();
  });
  $body.on('mouseenter', '.lesson_dashboard_hover_sensitive', function() {
    openDescriptionDashboardLayer($(this).find('.literature_container'));
  });
  $body.on('mouseleave', '.lesson_dashboard_hover_sensitive', function() {
    var item = $(this).find('.literature_container');
    if(item.data('moving')) {
      item.data('moving', false);
    } else {
      item.animate({height: '80px'}, 200, function() {
        item.find('.description').hide();
      });
    }
  });
}
