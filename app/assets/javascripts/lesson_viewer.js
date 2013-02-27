$(document).ready(function() {
  
  initializeLessonViewer();
  
  $('body').on('click', '#carousel_container a', function() {
    var me = $(this);
    if(!me.hasClass('esciButton') && !me.hasClass('_playlist_menu_item') && !me.hasClass('_open_playlist') && !me.hasClass('_close_playlist')) {
      closePlaylistMenuInLessonViewer(function() {});
    }
  });
  
  $('body').on('click', '._playlist_menu_item', function() {
    var lesson_id = $(this).data('lesson-id');
    switchLessonInPlaylistMenuLessonViewer(lesson_id, function() {
      closePlaylistMenuInLessonViewer(function() {
        slideToInLessonViewer($('._cover_bookmark_for_lesson_viewer_' + lesson_id));
      });
    });
  });
  
  $('body').on('click', 'a._open_playlist', function() {
    stopMediaInLessonViewer();
    openPlaylistMenuInLessonViewer(function() {});
  });
  
  $('body').on('click', 'a._close_playlist', function() {
    closePlaylistMenuInLessonViewer(function() {});
  });
  
  $(document.documentElement).keyup(function(e) {
    if(e.keyCode == 37) {
      goToPrevSlideInLessonViewer();
    } else if(e.keyCode == 39) {
      goToNextSlideInLessonViewer();
    }
  });
  
  $('body').on('click', '#right_scroll', function(e) {
    e.preventDefault();
    goToNextSlideInLessonViewer();
  });
  
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    goToPrevSlideInLessonViewer();
  });
  
});

function openPlaylistMenuInLessonViewer(callback) {
  hideArrowsInLessonViewer();
  $('a._open_playlist span').hide();
  $('a._close_playlist span').show();
  $('.playlistMenu').slideDown('slow', function() {
    callback();
  });
}

function closePlaylistMenuInLessonViewer(callback) {
  $('.playlistMenu').slideUp('slow', function() {
    callback();
    showArrowsInLessonViewer();
    $('a._open_playlist span').show();
    $('a._close_playlist span').hide();
  });
}

function selectComponentInLessonViewerPlaylistMenu(component, callback) {
  $('._playlist_menu_item').css('margin', '2px 60px 2px 0').css('border', 0);
  $('._playlist_menu_item').last().css('margin-right', 0);
  $('._playlist_menu_item._selected').removeClass('_selected');
  component.addClass('_selected');
  var prev = component.prev();
  var next = component.next();
  if(prev.length == 0 && next.length == 0) {
    component.css('margin-top', 0);
    component.css('margin-bottom', 0);
    component.css('border', '2px solid white');
  } else if(prev.length == 0) {
    component.css('margin-top', 0);
    component.css('margin-bottom', 0);
    component.css('border', '2px solid white');
    if(next.next().length == 0) {
      component.css('margin-right', '56px');
    } else {
      component.css('margin-right', '58px');
      next.css('margin-right', '58px');
    }
  } else if(next.length == 0) {
    component.css('margin-top', 0);
    component.css('margin-bottom', 0);
    component.css('border', '2px solid white');
    var prev_prev = prev.prev();
    if(prev_prev.length == 0) {
      prev.css('margin-right', '56px');
    } else {
      prev.css('margin-right', '58px');
      prev_prev.css('margin-right', '58px');
    }
  } else {
    component.css('margin-top', 0);
    component.css('margin-bottom', 0);
    component.css('margin-right', '58px');
    component.css('border', '2px solid white');
    prev.css('margin-right', '58px');
  }
  if($('#playlist_menu').data('jsp') != undefined) {
    var flag = true;
    var tot_prev_components = 0;
    $('._playlist_menu_item').each(function() {
      if(flag && !$(this).hasClass('_selected')) {
        tot_prev_components += 1;
      } else {
        flag = false;
      }
    });
    if(tot_prev_components > 1) {
      if(tot_prev_components == $('._playlist_menu_item').length - 1) {
        if(callback == undefined) {
          $('#playlist_menu').data('jsp').scrollToPercentX(100);
        } else {
          $('#playlist_menu').jScrollPane().bind('panescrollstop', function() {
            callback();
            $('#playlist_menu').jScrollPane().unbind('panescrollstop');
          });
          $('#playlist_menu').data('jsp').scrollToPercentX(100, true);
        }
      } else {
        if(callback == undefined) {
          $('#playlist_menu').data('jsp').scrollToX(307 * (tot_prev_components - 1));
        } else {
          $('#playlist_menu').jScrollPane().bind('panescrollstop', function() {
            callback();
            $('#playlist_menu').jScrollPane().unbind('panescrollstop');
          });
          $('#playlist_menu').data('jsp').scrollToX(307 * (tot_prev_components - 1), true);
        }
      }
    } else {
      if(callback != undefined) {
        callback();
      }
    }
  }
}

function getLessonViewerCurrentSlide() {
  return $('#' + $('._lesson_viewer_current_slide').attr('id'));
}

function slideToInLessonViewer(to) {
  stopMediaInLessonViewer();
  var from = getLessonViewerCurrentSlide();
  from.removeClass('_lesson_viewer_current_slide');
  to.addClass('_lesson_viewer_current_slide');
  from.hide('fade', {}, 500, function() {
    to.show();
  });
}

function hideArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').hide();
}

function showArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').show();
}

function initializeLessonViewer() {
  selectComponentInLessonViewerPlaylistMenu($('._playlist_menu_item').first());
  if($('._playlist_menu_item').length > 3) {
    $('#playlist_menu').jScrollPane({
      autoReinitialise: true,
      contentWidth: (($('._playlist_menu_item').length * 307) - 60)
    });
  } else {
    $('#playlist_menu').css('overflow', 'hidden');
  }
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  $(window).resize(function() {
    $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
}

function stopMediaInLessonViewer() {
  var current_slide_id = $('._lesson_viewer_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}

function switchLessonInPlaylistMenuLessonViewer(lesson_id, callback) {
  if($('._lesson_title_in_playlist').data('lesson-id') != lesson_id) {
    $('._lesson_title_in_playlist').hide();
    $('#lesson_viewer_playlist_title_' + lesson_id).show();
    selectComponentInLessonViewerPlaylistMenu($('#playlist_menu_item_' + lesson_id), callback);
  }
}

function slideToInLessonViewerWithLessonSwitch(component) {
  slideToInLessonViewer(component);
  switchLessonInPlaylistMenuLessonViewer(component.data('lesson-id'));
}

function goToNextSlideInLessonViewer() {
  var next_slide = getLessonViewerCurrentSlide().next();
  if(next_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('#slide_in_lesson_viewer_1'));
  } else {
    slideToInLessonViewerWithLessonSwitch(next_slide);
  }
}

function goToPrevSlideInLessonViewer() {
  var prev_slide = getLessonViewerCurrentSlide().prev();
  if(prev_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('._slide_in_lesson_viewer').last());
  } else {
    slideToInLessonViewerWithLessonSwitch(prev_slide);
  }
}
