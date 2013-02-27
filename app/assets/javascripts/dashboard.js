function reloadDashboardPages(lessons_page, media_elements_page) {
  $('#suggested_media_elements_1').hide();
  $('#suggested_media_elements_' + media_elements_page).show();
  $('#suggested_lessons_1').hide();
  $('#suggested_lessons_' + lessons_page).show();
}

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

function getHtmlPagination(pos, pages_amount) {
  var $prev_attrs = {};
  var $next_attrs = {};

  if(pos <= 1) {
    $prev_attrs.role = 'disabled';
  } else {
    $prev_attrs.data = { page: pos-1 };
  }

  if(pos >= pages_amount) {
    $next_attrs.role = 'disabled';
  } else {
    $next_attrs.data = { page: pos+1 };
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

function changePageDashboardMediaElements(old_pos, pos, pages_amount) {
  $('#suggested_media_elements_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_media_elements_' + (pos)).show();
    reloadMediaElementsDashboardPagination(pos, pages_amount);
  });
}

function changePageDashboardLessons(old_pos, pos, pages_amount) {
  $('#suggested_lessons_' + (old_pos)).hide('fade', {}, 500, function() {
    $(this).hide();
    $('#suggested_lessons_' + (pos)).show();
    reloadLessonsDashboardPagination(pos, pages_amount);
  });
}

function asyncFormSubmit($form, resultDiv) {
    // Create the iframe…
    var $iframe = $('<iframe/>')
            .attr("name", "upload_iframe")
            .attr("id", "upload_iframe")
            .hide();

    $("body").append($iframe);

    // When iframe loads, copy content back to target
    var copyIframe = function() {
        var contents = $iframe.contents().find("body").html();
        $(resultDiv).html(contents);
        // Delete the iframe
        setTimeout(function () { $iframe.remove(); }, 250);
    }
    $iframe.one("load", copyIframe);

    // Set properties of form
    $form.attr("target", "upload_iframe");

    // Submit the form. This triggers the iframe to "load" the
    // response from the server. Once loaded we can then do other
    // stuff.
    $form.submit();

    // This gets replaced by iframe content when ready
    // $(resultDiv).html("Uploading...");
    console.log('uploading');
}
