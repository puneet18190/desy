function switchToSuggestedMediaElements() {
  $('#lessons_in_dashboard').css('display', 'none');
  $('#media_elements_in_dashboard').css('display', 'block');
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_media_elements_1').css('display', 'block');
  $('#switch_to_media_elements').addClass('current');
  $('#switch_to_lessons').removeClass('current');
}

function switchToSuggestedLessons() {
  $('#media_elements_in_dashboard').css('display', 'none');
  $('#lessons_in_dashboard').css('display', 'block');
  $('.suggested_lessons_page').css('display', 'none');
  $('.suggested_media_elements_page').css('display', 'none');
  $('#suggested_lessons_1').css('display', 'block');
  $('#switch_to_lessons').addClass('current');
  $('#switch_to_media_elements').removeClass('current');
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

function reloadLessonsDashboardPagination(pos, pages_amount) {
  $('#dashboard_lessons_pagination').html(getHtmlPagination(pos, pages_amount));
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

function changePageDashboardLessons(old_pos, pos, pages_amount) {
  $('#suggested_lessons_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).css('display', 'none');
    $('#suggested_lessons_' + (pos)).css('display', 'block');
    reloadLessonsDashboardPagination(pos, pages_amount);
  });
}
