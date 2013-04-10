/**
The dashboard is the home page of DESY: the page is divided in two sections, one for <b>suggested elements</b> and one for <b>suggested lessons</b>. Each of these two sections is split into three pages of lessons and elements. When the server loads the dashboard, all the six pages (three for lessons, three for elements) are loaded together, and all the operations are handled with javascript functions.
<br/><br/>
There are two simple functions that switch between the pages for lessons and elements (see both methods of {{#crossLink "DashboardGeneral"}}{{/crossLink}}). A bit more complicated are the functions to pass from a page to another (all contained in the class {{#crossLink "DashboardPagination"}}{{/crossLink}}): the core of such an asynchronous pagination is the method {{#crossLink "DashboardPagination/getHtmlPagination:method"}}{{/crossLink}} that reconstructs the normal pagination without calling the corresponding partial in <i>views/shared/pagination.html.erb</i>: this pagination is unique for both elements and lessons, and it is reloaded each time the user changes page using the functions {{#crossLink "DashboardPagination/reloadLessonsDashboardPagination:method"}}{{/crossLink}} and {{#crossLink "DashboardPagination/reloadMediaElementsDashboardPagination:method"}}{{/crossLink}}.
@module dashboard
**/





/**
Initializer for the animation effects of the Dashboard.
@method dashboardDocumentReady
@for DashboardDocumentReady
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
This function switched to the page of suggested lessons, and reloads the pagination (if there are no suggested lessons the pagination is removed).
@method switchToSuggestedLessons
@for DashboardGeneral
**/
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
This function switches to the page of suggested elements, and reloads the pagination (if there are no suggested elements the pagination is removed).
@method switchToSuggestedMediaElements
@for DashboardGeneral
**/
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
This function changes page of the section containing suggested lessons. As already mentioned, the method reloads the pagination using {{#crossLink "DashboardPagination/reloadLessonsDashboardPagination:method"}}{{/crossLink}}.
@method changePageDashboardLessons
@for DashboardPagination
@param old_pos {Number} old page
@param pos {Number} new page
@param poges_amount {Number} amount of pages of lessons
**/
function changePageDashboardLessons(old_pos, pos, pages_amount) {
  $('#suggested_lessons_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_lessons_' + (pos)).show();
    reloadLessonsDashboardPagination(pos, pages_amount);
  });
}

/**
This function changes page of the section containing suggested elements. As already mentioned, the method reloads the pagination using {{#crossLink "DashboardPagination/reloadMediaElementsDashboardPagination:method"}}{{/crossLink}}.
@method changePageDashboardMediaElements
@for DashboardPagination
@param old_pos {Number} old page
@param pos {Number} new page
@param poges_amount {Number} amount of pages of elements
**/
function changePageDashboardMediaElements(old_pos, pos, pages_amount) {
  $('#suggested_media_elements_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_media_elements_' + (pos)).show();
    reloadMediaElementsDashboardPagination(pos, pages_amount);
  });
}

/**
This function generates HTML code with the same functionality of the one defined in the partial <i>views/shared/pagination.html.erb</i>.
@method getHtmlPagination
@for DashboardPagination
@param pos {Number} selected page
@param pages_amount {Number} total amount of pages
@return {Object} JQuery HTML element to be attached to the document
**/
function getHtmlPagination(pos, pages_amount) {
  var prev_attrs = {};
  var next_attrs = {};
  if(pos <= 1) {
    prev_attrs.role = 'disabled';
  } else {
    prev_attrs.data = {
      page: pos - 1
    };
    prev_attrs.title = $('#popup_captions_container').data('title-pagination-left');
  }
  if(pos >= pages_amount) {
    next_attrs.role = 'disabled';
  } else {
    next_attrs.data = {
      page: pos + 1
    };
    next_attrs.title = $('#popup_captions_container').data('title-pagination-right');
  }
  var pagination = $('<span/>', {
    'class': 'dots_pagination'
  });
  pagination.append($('<span/>', {
    role: 'pages'
  }).append($('<a/>', prev_attrs)).append($('<a/>', {
    role: 'current',
    data: {
      page: pos
    }
  })).append($('<a/>', next_attrs)));
  return pagination;
}

/**
This function sets the current pages of lessons and elements, without loading the pagination. It's only used in the index.js.erb for pagination.
@method reloadDashboardPages
@for DashboardPagination
@param lessons_page {Number} page to be selected for lessons
@param media_elements_page {Number} page to be selected for media elements
**/
function reloadDashboardPages(lessons_page, media_elements_page) {
  $('#suggested_media_elements_1').hide();
  $('#suggested_media_elements_' + media_elements_page).show();
  $('#suggested_lessons_1').hide();
  $('#suggested_lessons_' + lessons_page).show();
}

/**
This function reloads the pagination for lessons (it uses {{#crossLink "DashboardPagination/getHtmlPagination:method"}}{{/crossLink}}).
@method reloadLessonsDashboardPagination
@for DashboardPagination
@param pos {Number} current page
@param poges_amount {Number} amount of pages for lessons
**/
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
This function reloads the pagination for media elements (it uses {{#crossLink "DashboardPagination/getHtmlPagination:method"}}{{/crossLink}}).
@method reloadMediaElementsDashboardPagination
@for DashboardPagination
@param pos {Number} current page
@param poges_amount {Number} amount of pages for elements
**/
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
