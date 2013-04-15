/**
bla bla bla
@module search
**/





/**
bla bla bla
@method searchDocumentReady
@for SearchDocumentReady
**/
function searchDocumentReady() {
  searchDocumentReadyGeneral();
  searchDocumentReadyFilterByTag();
  searchDocumentReadyPlaceholders();
}

/**
bla bla bla
@method searchDocumentReadyFilterByTag
@for SearchDocumentReady
**/
function searchDocumentReadyFilterByTag() {
  $('body').on('click', '._clickable_tag_for_lessons, ._clickable_tag_for_media_elements', function() {
    if(!$(this).hasClass('current')) {
      var url = $('#info_container').data('currenturl');
      url = updateURLParameter(url, 'tag_id', '' + $(this).data('param'));
      url = updateURLParameter(url, 'page', '1');
      window.location = url;
    }
  });
  $('body').on('click', '._clickable_tag_for_lessons.current, ._clickable_tag_for_media_elements.current', function() {
    var url = $('#info_container').data('currenturl');
    url = removeURLParameter(url, 'tag_id');
    url = updateURLParameter(url, 'page', '1');
    window.location = url;
  });
}

/**
bla bla bla
@method searchDocumentReadyGeneral
@for SearchDocumentReady
**/
function searchDocumentReadyGeneral() {
  $('body').on('click', '#which_item_to_search_switch_media_elements', function() {
    $('#search_lessons_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').show();
      $('#search_lessons_main_page').hide();
      if($('#general_pagination').is(':visible')) {
        $('#general_pagination').hide();
      } else {
        $('#general_pagination').show();
      }
    });
  });
  $('body').on('click', '#which_item_to_search_switch_lessons', function() {
    $('#search_media_elements_main_page').hide('fade', {}, 500, function() {
      $('#search_media_elements_main_page').hide();
      $('#search_lessons_main_page').show();
      if($('#general_pagination').is(':visible')) {
        $('#general_pagination').hide();
      } else {
        $('#general_pagination').show();
      }
    });
  });
  $('body').on('click', '#search_general_submit', function() {
    if(!$(this).hasClass('current')) {
      $('#search_general').submit();
      $(this).addClass('current');
    }
  });
  $('body').on('click', '._keep_searching', function() {
    var form = $(this).parent();
    form.animate({
      height: '210'
    }, 500, function() {
      form.find('._search_engine_form').show();
      form.find('._keep_searching').hide();
    });
  });
}

/**
bla bla bla
@method searchDocumentReadyPlaceholders
@for SearchDocumentReady
**/
function searchDocumentReadyPlaceholders() {
  $('body').on('focus', '#lessons_tag_reader_for_search', function() {
    if($('#lessons_tag_kind_for_search').val() == '') {
      $(this).val('');
      $(this).css('color', '#939393');
      $('#lessons_tag_kind_for_search').val('0');
    }
  });
  $('body').on('focus', '#media_elements_tag_reader_for_search', function() {
    if($('#media_elements_tag_kind_for_search').val() == '') {
      $(this).val('');
      $(this).css('color', '#939393');
      $('#media_elements_tag_kind_for_search').val('0');
    }
  });
  $('body').on('focus', '#general_tag_reader_for_search', function() {
    $(this).attr('value', '');
    $(this).css('color', '#939393');
    $('#general_tag_kind_for_search').attr('value', '0');
    $('#search_general_submit').removeClass('current');
  });
}