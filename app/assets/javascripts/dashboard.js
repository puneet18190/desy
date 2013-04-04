/**
Dashboard is the welcome page of DESY where you find shared lessons and elements. This handles elements interaction events.
@module dashboard
**/

function dashboardDocumentReady() {
  $('body').on('mouseover', '._empty_media_elements', function() {
    $(this).find('._empty_media_elements_hover').addClass('current');
  });
  $('body').on('mouseout', '._empty_media_elements', function() {
    $(this).find('._empty_media_elements_hover').removeClass('current');
  });
  $('body').on('mouseover', '._empty_lessons', function() {
    $(this).find('._empty_lessons_hover').addClass('current');
  });
  $('body').on('mouseout', '._empty_lessons', function() {
    $(this).find('._empty_lessons_hover').removeClass('current');
  });
  $('body').on('click', '._empty_lessons', function() {
    window.location = '/lessons/new';
  });
  $('#switch_to_lessons').click(function() {
    switchToSuggestedLessons();
  });
  $('#switch_to_media_elements').click(function() {
    switchToSuggestedMediaElements();
  });
}

/**
* Reload Dashboard content on page change, using bottom pagination.
* 
* @method reloadDashboardPages
* @for reloadDashboardPages
*/
function reloadDashboardPages(lessons_page, media_elements_page) {
  $('#suggested_media_elements_1').hide();
  $('#suggested_media_elements_' + media_elements_page).show();
  $('#suggested_lessons_1').hide();
  $('#suggested_lessons_' + lessons_page).show();
}

/**
* Switch to suggested elements page in dashboard.
* 
* Uses: [reloadMediaElementsDashboardPagination](../classes/reloadMediaElementsDashboardPagination.html#method_reloadMediaElementsDashboardPagination)
*
* @method switchToSuggestedMediaElements
* @for switchToSuggestedMediaElements
*/
function switchToSuggestedMediaElements() {
  $('#lessons_in_dashboard').hide('fade', {}, 500, function() {
    $(this).hide();
    $('#media_elements_in_dashboard').show();
    $('#switch_to_media_elements').addClass('current');
    $('#switch_to_lessons').removeClass('current');
    var pagination_div = $('#dashboard_pagination');
    var media_elements_page = pagination_div.data('media-elements-page');
    var media_elements_tot = pagination_div.data('media-elements-tot');
    reloadMediaElementsDashboardPagination(media_elements_page, media_elements_tot);
  });
}

/**
* Switch to suggested lessons page in dashboard.
* 
* Uses: [reloadMediaLessonsDashboardPagination](../classes/reloadMediaLessonsDashboardPagination.html#method_reloadMediaLessonsDashboardPagination)
*
* @method switchToSuggestedLessons
* @for switchToSuggestedLessons
*/
function switchToSuggestedLessons() {
  $('#media_elements_in_dashboard').hide('fade', {}, 500, function() {
    $(this).hide();
    $('#lessons_in_dashboard').show();
    $('#switch_to_lessons').addClass('current');
    $('#switch_to_media_elements').removeClass('current');
    var pagination_div = $('#dashboard_pagination');
    var lessons_page = pagination_div.data('lessons-page');
    var lessons_tot = pagination_div.data('lessons-tot');
    reloadLessonsDashboardPagination(lessons_page, lessons_tot);
  });
}

/**
* Pagination html generator
* 
* @method getHtmlPagination
* @for getHtmlPagination
* @param pos {Number} current position
* @param pages_amount {Number} number of pages
* @return {Object} pagination html elements  
*/
function getHtmlPagination(pos, pages_amount) {
  var $prev_attrs = {};
  var $next_attrs = {};

  if(pos <= 1) {
    $prev_attrs.role = 'disabled';
  } else {
    $prev_attrs.data = { page: pos-1 };
    $prev_attrs.title = $('#popup_captions_container').data('title-pagination-left');
  }

  if(pos >= pages_amount) {
    $next_attrs.role = 'disabled';
  } else {
    $next_attrs.data = { page: pos+1 };
    $next_attrs.title = $('#popup_captions_container').data('title-pagination-right');
  }

  var $pagination = $('<span/>', { 'class': 'dots_pagination' });

  $pagination.append(
    $('<span/>', { role: 'pages' })
      .append( $('<a/>', $prev_attrs) )
      .append( $('<a/>', { role: 'current', data: { page: pos } }) )
      .append( $('<a/>', $next_attrs) )
  );
  return $pagination;
}

/**
* Realod pagination html for media elements.
* 
* Uses: [changePageDashboardMediaElements](../classes/changePageDashboardMediaElements.html#method_changePageDashboardMediaElements)
*
* @method reloadMediaElementsDashboardPagination
* @for reloadMediaElementsDashboardPagination
* @param pos {Number} pagination position
* @param poges_amount {Number} pagination pages amount
*/
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

/**
* Realod pagination html for lessons.
* 
* Uses: [changePageDashboardLessons](../classes/changePageDashboardLessons.html#method_changePageDashboardLessons)
*
* @method reloadLessonsDashboardPagination
* @for reloadLessonsDashboardPagination
* @param pos {Number} pagination position
* @param poges_amount {Number} pagination pages amount
*/
function reloadLessonsDashboardPagination(pos, pages_amount) {
  if(pages_amount == 0) {
    $('#dashboard_pagination').empty().data({ 'lessons-tot': 0, 'lessons-page': 0 });
    return;
  }
  $('#dashboard_pagination')
    .html(getHtmlPagination(pos, pages_amount))
    .data({ 'lessons-tot': pages_amount,'lessons-page': pos });
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

/**
* Change media elements page in dashboard.
* 
* Uses: [reloadMediaElementsDashboardPagination](../classes/reloadMediaElementsDashboardPagination.html#method_reloadMediaElementsDashboardPagination)
*
* @method changePageDashboardMediaElements
* @for changePageDashboardMediaElements
* @param old_pos {Number} pagination old position
* @param pos {Number} pagination position
* @param poges_amount {Number} pagination pages amount
*/
function changePageDashboardMediaElements(old_pos, pos, pages_amount) {
  $('#suggested_media_elements_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_media_elements_' + (pos)).show();
    reloadMediaElementsDashboardPagination(pos, pages_amount);
  });
}

/**
* Change lessons page in dashboard.
* 
* Uses: [reloadLessonsDashboardPagination](../classes/reloadLessonsDashboardPagination.html#method_reloadLessonsDashboardPagination)
*
* @method changePageDashboardLessons
* @for changePageDashboardLessons
* @param old_pos {Number} pagination old position
* @param pos {Number} pagination position
* @param poges_amount {Number} pagination pages amount
*/
function changePageDashboardLessons(old_pos, pos, pages_amount) {
  $('#suggested_lessons_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_lessons_' + (pos)).show();
    reloadLessonsDashboardPagination(pos, pages_amount);
  });
}
