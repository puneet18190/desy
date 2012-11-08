function switchToSuggestedMediaElements() {
  $('#lessons_in_dashboard').hide('fade', {}, 500, function() {
    $(this).css('display', 'none');
    $('#media_elements_in_dashboard').css('display', 'block');
    $('#switch_to_media_elements').addClass('current');
    $('#switch_to_lessons').removeClass('current');
    var pagination_div = $('#dashboard_pagination');
    var media_elements_page = pagination_div.data('media-elements-page');
    var media_elements_tot = pagination_div.data('media-elements-tot');
    reloadMediaElementsDashboardPagination(media_elements_page, media_elements_tot);
  });
}

function switchToSuggestedLessons() {
  $('#media_elements_in_dashboard').hide('fade', {}, 500, function() {
    $(this).css('display', 'none');
    $('#lessons_in_dashboard').css('display', 'block');
    $('#switch_to_lessons').addClass('current');
    $('#switch_to_media_elements').removeClass('current');
    var pagination_div = $('#dashboard_pagination');
    var lessons_page = pagination_div.data('lessons-page');
    var lessons_tot = pagination_div.data('lessons-tot');
    reloadLessonsDashboardPagination(lessons_page, lessons_tot);
  });
}

function getHtmlPagination(pos, pages_amount) {
  var substitute = "<span class=\"dots_pagination\"><span role=\"pages\"><a data-page=\"";
  if(pos <= 1) {
    substitute += ((pos - 1) + "\" role=\"disabled\"></a>");
  } else {
    substitute += ((pos - 1) + "\"></a>");
  }
  substitute += ("<a data-page=\"" + pos + "\" role=\"current\"></a>");
  if(pos >= pages_amount) {
    substitute += "<a data-page=\"" + (pos + 1) + "\" role=\"disabled\"></a>"
  } else {
    substitute += "<a data-page=\"" + (pos + 1) + "\"></a>"
  }
  substitute += "</span></span>";
  return substitute;
}

function reloadMediaElementsDashboardPagination(pos, pages_amount) {
  if(pages_amount == 0) {
    $('#dashboard_pagination').html('');
    $('#dashboard_pagination').data('media-elements-tot', 0);
    $('#dashboard_pagination').data('media-elements-page', 0);
    return;
  }
  $('#dashboard_pagination').html(getHtmlPagination(pos, pages_amount));
  $('#dashboard_pagination').data('media-elements-tot', pages_amount);
  $('#dashboard_pagination').data('media-elements-page', pos);
  $(document).ready(function() {
    var prevPage = function(prevPage) {
      changePageDashboardMediaElements(pos, (pos - 1), pages_amount);
      return true;
    }
    var nextPage = function(nextPage) {
      changePageDashboardMediaElements(pos, (pos + 1), pages_amount);
      return true;
    }
    new DotsPagination($('[role=pages]'), pages_amount, prevPage, nextPage);
  });
}

function reloadLessonsDashboardPagination(pos, pages_amount) {
  if(pages_amount == 0) {
    $('#dashboard_pagination').html('');
    $('#dashboard_pagination').data('lessons-tot', 0);
    $('#dashboard_pagination').data('lessons-page', 0);
    return;
  }
  $('#dashboard_pagination').html(getHtmlPagination(pos, pages_amount));
  $('#dashboard_pagination').data('lessons-tot', pages_amount);
  $('#dashboard_pagination').data('lessons-page', pos);
  $(document).ready(function() {
    var prevPage = function(prevPage) {
      changePageDashboardLessons(pos, (pos - 1), pages_amount);
      return true;
    }
    var nextPage = function(nextPage) {
      changePageDashboardLessons(pos, (pos + 1), pages_amount);
      return true;
    }
    new DotsPagination($('[role=pages]'), pages_amount, prevPage, nextPage);
  });
}

function changePageDashboardMediaElements(old_pos, pos, pages_amount) {
  $('#suggested_media_elements_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).css('display', 'none');
    $('#suggested_media_elements_' + (pos)).css('display', 'block');
    reloadMediaElementsDashboardPagination(pos, pages_amount);
  });
}

function changePageDashboardLessons(old_pos, pos, pages_amount) {
  $('#suggested_lessons_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).css('display', 'none');
    $('#suggested_lessons_' + (pos)).css('display', 'block');
    reloadLessonsDashboardPagination(pos, pages_amount);
  });
}
