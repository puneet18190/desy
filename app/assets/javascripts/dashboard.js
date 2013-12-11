function dashboardResizeController() {
  var container = $('#dashboard_container');
  var width = container.width();
  var lessons = parseInt((width - 20) / 320);
  var media_elements = parseInt((width - 20) / 222);
  if(container.data('status') == 'lessons') {
    if(lessons != container.data('lessons')) {
      $.ajax({
        type: 'get',
        url: '/dashboard?lessons_for_page=' + lessons
      });
    } else {
      resizeLessonsOrMediaElementsInDashboard(container, '.space_lessons .lesson_in_dashboard', '.title_lessons .icon', lessons, 300);
    }
  } else if(container.data('status') == 'media_elements') {
    if(media_elements != container.data('media-elements')) {
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements
      });
    } else {
      resizeLessonsOrMediaElementsInDashboard(container, '.space_media_elements .boxViewExpandedMediaElement', '.title_media_elements .icon', media_elements, 202);
    }
  } else {
    var lessons_space = lessons * 320 - 20;
    media_elements = parseInt((lessons_space - 207) / 207) + 1;
    if(lessons != container.data('lessons') || media_elements != container.data('media-elements')) {
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements + '&lessons_for_page=' + lessons
      });
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
  var new_calc = lessons_margin + 230;
  container.find('.title_media_elements .icon').next().css('width', 'calc(100% - ' + new_calc + 'px)');
}

function resizeLessonsOrMediaElementsInDashboard(container, selector, icon_selector, num, item_width) {
  var margin = (container.width() - num * item_width) / (num + 1);
  container.find(selector).css('margin-left', margin + 'px');
  container.find(icon_selector).css('margin-left', margin + 'px');
  var new_calc = margin + 230;
  container.find(icon_selector).next().css('width', 'calc(100% - ' + new_calc + 'px)');
  return margin;
}

function dashboardDocumentReady() {
  dashboardResizeController();
  $(window).resize(function() {
    dashboardResizeController();
  });
}
