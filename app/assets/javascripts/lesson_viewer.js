/*
  NOTA DI ADRIANO:
    ci sono tre bug conosciuti e dovuti al malfunzionamento di JScrollPane:
     (1) quando passo dalla prima slide della terza lezione all'ultima slide della seconda lezione, lo scroll non segue la selezione della lezione in basso
     (2) quando passo dall'ultima slide dell'ultima lezione alla prima slide della prima lezione, idem
     (3) se, dopo aver aperto la prima volta il menu delle lezioni, (SOLO LA PRIMA VOLTA), clicco su una delle lezioni entro due secondi, si rompe il menu
*/

/**
* Lesson viewer, it handles slides switching and playlist menu effects.
* 
* @module LessonViewer
*/
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
    if(!$(this).data('loaded') && $('._playlist_menu_item').length > 3) {
      $(this).data('loaded', true);
      $('#playlist_menu').jScrollPane({
        autoReinitialise: true,
        contentWidth: (($('._playlist_menu_item').length * 307) - 60)
      });
    }
    stopMediaInLessonViewer();
    openPlaylistMenuInLessonViewer();
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
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      goToNextSlideInLessonViewer();
    }
  });
  
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      goToPrevSlideInLessonViewer();
    }
  });
  
});

/**
* Open playlist menu, show lessons conver list and change playlist toggle label
*
* Uses: [hideArrowsInLessonViewer](../classes/hideArrowsInLessonViewer.html#method_hideArrowsInLessonViewer)
* 
* @method openPlaylistMenuInLessonViewer
* @for openPlaylistMenuInLessonViewer
*/
function openPlaylistMenuInLessonViewer() {
  hideArrowsInLessonViewer();
  $('a._open_playlist span').hide();
  $('a._close_playlist span').show();
  $('.playlistMenu').slideDown('slow');
}

/**
* Open playlist menu, show lessons conver list and change playlist toggle label
*
* Uses: [showArrowsInLessonViewer](../classes/showArrowsInLessonViewer.html#method_showArrowsInLessonViewer)
* 
* @method closePlaylistMenuInLessonViewer
* @for closePlaylistMenuInLessonViewer
* @param callback {Object} to call after effect is complete
*/
function closePlaylistMenuInLessonViewer(callback) {
  $('.playlistMenu').slideUp('slow', function() {
    callback();
    showArrowsInLessonViewer();
    $('a._open_playlist span').show();
    $('a._close_playlist span').hide();
  });
}

/**
* Sets selected lesson from playlist menu
*
* @method selectComponentInLessonViewerPlaylistMenu
* @for selectComponentInLessonViewerPlaylistMenu
* @param component {Object} selected lesson
* @param callback {Object} to call after function is complete
*/
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
  } else {
    if(callback != undefined) {
      callback();
    }
  }
}

/**
* Gets the current slide id
*
* @method getLessonViewerCurrentSlide
* @for getLessonViewerCurrentSlide
* @return {Number} current slide id
*/
function getLessonViewerCurrentSlide() {
  return $('#' + $('._lesson_viewer_current_slide').attr('id'));
}

/**
* Slide to given slide
*
* Uses: [stopMediaInLessonViewer](../classes/stopMediaInLessonViewer.html#method_stopMediaInLessonViewer)
* and [getLessonViewerCurrentSlide](../classes/getLessonViewerCurrentSlide.html#method_getLessonViewerCurrentSlide)
* and [unbindLoader](../classes/unbindLoader.html#method_unbindLoader)
* and [bindLoader](../classes/bindLoader.html#method_bindLoader)
* 
* @method slideToInLessonViewer
* @for slideToInLessonViewer
* @param to {Object} slide to slide to
*/
function slideToInLessonViewer(to) {
  stopMediaInLessonViewer();
  var from = getLessonViewerCurrentSlide();
  from.removeClass('_lesson_viewer_current_slide');
  to.addClass('_lesson_viewer_current_slide');
  from.hide('fade', {}, 500, function() {
    to.show();
    if(!to.data('loaded')) {
      $.ajax({
        type: 'get',
        beforeSend: unbindLoader(),
        url: '/lessons/' + to.data('lesson-id') + '/view/slides/' + to.data('slide-id') + '/load?token=' + to.data('lesson-token'),
        success: function() {
          $('#left_scroll, #right_scroll').removeClass('disabled');
          var media = to.find('._instance_of_player');
          if(media.length > 0) {
            media.find('._media_player_play').click();
          }
        }
      }).always(bindLoader);
    } else {
      $('#left_scroll, #right_scroll').removeClass('disabled');
      var media = to.find('._instance_of_player');
      if(media.length > 0) {
        media.find('._media_player_play').click();
      }
    }
  });
}

/**
* Hide slides navigation arrows in lesson viewer
* 
* @method hideArrowsInLessonViewer
* @for hideArrowsInLessonViewer
*/
function hideArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').hide();
}

/**
* Show slides navigation arrows in lesson viewer
* 
* @method hideArrowsInLessonViewer
* @for hideArrowsInLessonViewer
*/
function showArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').show();
}

/**
* Handle playlist menu on lesson viewer startup
*
* Uses: [selectComponentInLessonViewerPlaylistMenu](../classes/selectComponentInLessonViewerPlaylistMenu.html#method_selectComponentInLessonViewerPlaylistMenu)
* 
* @method initializeLessonViewer
* @for initializeLessonViewer
*/
function initializeLessonViewer() {
  selectComponentInLessonViewerPlaylistMenu($('._playlist_menu_item').first());
  if($('._playlist_menu_item').length <= 3) {
    $('#playlist_menu').css('overflow', 'hidden');
  }
  $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  $(window).resize(function() {
    $('html.lesson-viewer-layout .container').css('margin-top', ($(window).height() - 590) / 2 + 'px');
  });
}

/**
* Stop media playling in current slide in lesson viewer
* 
* @method stopMediaInLessonViewer
* @for stopMediaInLessonViewer
*/
function stopMediaInLessonViewer() {
  var current_slide_id = $('._lesson_viewer_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
}

/**
* Open playlist menu, show lessons conver list and change playlist toggle label
*
* Uses: [selectComponentInLessonViewerPlaylistMenu](../classes/selectComponentInLessonViewerPlaylistMenu.html#method_selectComponentInLessonViewerPlaylistMenu)
* 
* @method switchLessonInPlaylistMenuLessonViewer
* @for switchLessonInPlaylistMenuLessonViewer
* @param lesson_id {Number} lesson id to switch to
* @param callback {Object} callback after function is complete
*/
function switchLessonInPlaylistMenuLessonViewer(lesson_id, callback) {
  if($('._lesson_title_in_playlist').data('lesson-id') != lesson_id) {
    $('._lesson_title_in_playlist').hide();
    $('#lesson_viewer_playlist_title_' + lesson_id).show();
    selectComponentInLessonViewerPlaylistMenu($('#playlist_menu_item_' + lesson_id), callback);
  }
}

/**
* Open playlist menu, show lessons conver list and change playlist toggle label
*
* Uses: [slideToInLessonViewer](../classes/slideToInLessonViewer.html#method_slideToInLessonViewer)
* and [switchLessonInPlaylistMenuLessonViewer](../classes/switchLessonInPlaylistMenuLessonViewer.html#method_switchLessonInPlaylistMenuLessonViewer)
* 
* @method slideToInLessonViewerWithLessonSwitch
* @for slideToInLessonViewerWithLessonSwitch
* @param component {Object} slide to slide to
*/
function slideToInLessonViewerWithLessonSwitch(component) {
  slideToInLessonViewer(component);
  switchLessonInPlaylistMenuLessonViewer(component.data('lesson-id'));
}

/**
* Go to next slide in lesson viewer,
* if last slide it goes to first one.
*
* Uses: [slideToInLessonViewerWithLessonSwitch](../classes/slideToInLessonViewerWithLessonSwitch.html#method_slideToInLessonViewerWithLessonSwitch)
* 
* @method goToNextSlideInLessonViewer
* @for goToNextSlideInLessonViewer
*/
function goToNextSlideInLessonViewer() {
  var next_slide = getLessonViewerCurrentSlide().next();
  if(next_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('._slide_in_lesson_viewer').first());
  } else {
    slideToInLessonViewerWithLessonSwitch(next_slide);
  }
}

/**
* Go to previous slide in lesson viewer,
* if first slide it goes to last one.
*
* Uses: [slideToInLessonViewerWithLessonSwitch](../classes/slideToInLessonViewerWithLessonSwitch.html#method_slideToInLessonViewerWithLessonSwitch)
* 
* @method goToPrevSlideInLessonViewer
* @for goToPrevSlideInLessonViewer
*/
function goToPrevSlideInLessonViewer() {
  var prev_slide = getLessonViewerCurrentSlide().prev();
  if(prev_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('._slide_in_lesson_viewer').last());
  } else {
    slideToInLessonViewerWithLessonSwitch(prev_slide);
  }
}
