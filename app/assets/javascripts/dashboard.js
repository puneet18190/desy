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
    }
  } else if(container.data('status') == 'media_elements') {
    if(media_elements != container.data('media-elements')) {
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements
      });
    }
  } else {
    var lessons_space = lessons * 320 - 20;
    media_elements = parseInt((lessons_space - 222) / 222) + 1;
    if(lessons != container.data('lessons') || media_elements != container.data('media-elements')) {
      $.ajax({
        type: 'get',
        url: '/dashboard?media_elements_for_page=' + media_elements + '&lessons_for_page=' + lessons
      });
    }
  }
}

function dashboardDocumentReady() {
  dashboardResizeController();
  $(window).resize(function() {
    dashboardResizeController();
  });
}
