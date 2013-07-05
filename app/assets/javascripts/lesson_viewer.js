/**
The Lesson Viewer is the instrument to reporoduce single and multiple lessons (playlists). The Viewer provides the user of a screen containing the current slide with <b>two arrows</b> to switch to the next one. If the lesson is being reproduced inside a playlist, it's additionally available a <b>playlst menu</b> (opened on the bottom of the current slide).
<br/><br/>
The main methods of this module are {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewer:method"}}{{/crossLink}} (moves to a given slide) and {{#crossLink "LessonViewerPlaylist/switchLessonInPlaylistMenuLessonViewer:method"}}{{/crossLink}} (moves to the first slide of a given lesson and updates the selected lesson in the menu). The first method can be used separately if there is no playlist, or together with the second one if there is one (they are called together inside {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewerWithLessonSwitch:method"}}{{/crossLink}}).
<br/><br/>
Additionally, {{#crossLink "LessonViewerPlaylist/switchLessonInPlaylistMenuLessonViewer:method"}}{{/crossLink}} can be provided of a callback that is passed to {{#crossLink "LessonViewerPlaylist/selectComponentInLessonViewerPlaylistMenu:method"}}{{/crossLink}} and executed after the animation of the scroll inside the lesson menu: the callback is used when the user selects a lesson directly from the menu, and {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewer:method"}}{{/crossLink}} is executed to get to the cover of the selected lesson after that the menu has been closed.
<br/><br/>
There are <b>three known bugs</b> due to the bad quality of the plugin <b>JScrollPain</b>:
<ul>
  <li>When the user passes from <i>the first slide of the third lesson</i> to <i>the last slide of the second lesson</i>, the scroll doesn't follow the selection of the new lesson</li>
  <li>Same problem when the user passes from <i>the last slide of the last lesson</i> to <i>the first slide of the first lesson</i></li>
  <li>If, after having opened <b>for the first time</b> (and only for that time) the playlist menu, I click before two seconds on a lesson, the menu gets broken</li>
</ul>
@module lesson-viewer
**/





/**
Global initializer.
@method lessonViewerDocumentReady
@for LessonViewerDocumentReady
**/
function lessonViewerDocumentReady() {
  initializeLessonViewer();
  lessonViewerDocumentReadyPlaylist();
  lessonViewerDocumentReadySlidesNavigation();
  lessonViewerDocumentReadySocialNetworks();
}

/**
Initializer for functionalities of the playlist menu.
@method lessonViewerDocumentReadyPlaylist
@for LessonViewerDocumentReady
**/
function lessonViewerDocumentReadyPlaylist() {
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
        slideToInLessonViewer($('._cover_bookmark_for_lesson_viewer_' + lesson_id, false));
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
}

/**
Initializer for slides navigation.
@method lessonViewerDocumentReadySlidesNavigation
@for LessonViewerDocumentReady
**/
function lessonViewerDocumentReadySlidesNavigation() {
  $(document.documentElement).keyup(function(e) {
    if(e.keyCode == 37) {
      goToPrevSlideInLessonViewer(false);
    } else if(e.keyCode == 39) {
      goToNextSlideInLessonViewer(false);
    }
  });
  $('body').on('click', '#right_scroll', function(e) {
    e.preventDefault();
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      goToNextSlideInLessonViewer(false);
    }
  });
  $('body').on('click', '#left_scroll', function(e) {
    e.preventDefault();
    if(!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      goToPrevSlideInLessonViewer(false);
    }
  });
  $('.lesson-viewer-layout').on('swipeleft', function() {
    if(mustReactToSwipe()) {
      goToNextSlideInLessonViewer(true);
    }
  });
  $('.lesson-viewer-layout').on('swiperight', function() {
    if(mustReactToSwipe()) {
      goToPrevSlideInLessonViewer(true);
    }
  });
}

/**
Initializer for functionality of sharing the lesson in social networks.
@method lessonViewerDocumentReadySocialNetworks
@for LessonViewerDocumentReady
**/
function lessonViewerDocumentReadySocialNetworks() {
  $('body').on('click', '#open_social_networks', function() {
    $(this).hide();
    $('#social_networks').show();
  });
  $('body').on('mouseout', '#social_networks', function(e) {
    var position = $(this).offset();
    var top = position.top;
    var right = position.left + 158;
    var bottom = position.top + 214;
    var left = position.left;
    if(left <= e.clientX && e.clientX <= right && top <= e.clientY && e.clientY <= bottom) {
      return;
    }
    $(this).hide();
    $('#open_social_networks').show();
  });
  $('body').on('click', '#social_networks .facebook', function() {
    $('#social_networks').hide();
    $('#open_social_networks').show();
    var fb_url = 'https://www.facebook.com/sharer/sharer.php?s=100&p[url]=' + encodeURIComponent($(this).data('url'));
    fb_url += '&p[summary]=' + encodeURIComponent($(this).data('description'));
    fb_url += '&p[title]=' + encodeURIComponent($('title').html());
    if($(this).data('image') != undefined) {
      fb_url += '&p[images][0]=' + encodeURIComponent($(this).data('image'));
    }
    window.open(
      fb_url,
      'facebook-share-dialog',
      'width=626,height=436'
    );
  });
  $('body').on('click', '#social_networks .twitter', function() {
    $('#social_networks').hide();
    $('#open_social_networks').show();
    var tw_url = 'https://twitter.com/intent/tweet?original_referer=' + encodeURIComponent($(this).data('url'));
    tw_url += '&text=' + encodeURIComponent($('title').html());
    tw_url += '&tw_p=tweetbutton&url=' + encodeURIComponent($(this).data('url'));
    window.open(
      tw_url,
      'twitter-share-dialog',
      'width=626,height=436'
    );
  });
  $('body').on('click', '#social_networks .google-plus', function() {
    $('#social_networks').hide();
    $('#open_social_networks').show();
    var gp_url = 'https://plus.google.com/share?url=' + encodeURIComponent($(this).data('url'));
    window.open(
      gp_url,
      'google-plus-share-dialog',
      'width=626,height=436'
    );
  });
}





/**
Gets the HTML id of the current slide (marked with the class <b>lesson viewer current slide</b>).
@method getLessonViewerCurrentSlide
@for LessonViewerGeneral
@return {String} HTML id of the current slide
**/
function getLessonViewerCurrentSlide() {
  return $('#' + $('._lesson_viewer_current_slide').attr('id'));
}

/**
Initializes the positions, and selects the right lesson in the playlist menu. Called in {{#crossLink "LessonViewerDocumentReady/lessonViewerDocumentReady:method"}}{{/crossLink}}.
@method initializeLessonViewer
@for LessonViewerGeneral
**/
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
Stops media playing in current slide.
@method stopMediaInLessonViewer
@for LessonViewerGeneral
**/
function stopMediaInLessonViewer() {
  var current_slide_id = $('._lesson_viewer_current_slide').attr('id');
  stopMedia('#' + current_slide_id + ' audio');
  stopMedia('#' + current_slide_id + ' video');
  var media_audio = $('#' + current_slide_id + ' audio');
  var media_video = $('#' + current_slide_id + ' video');
  if(media_audio.length > 0) {
    setCurrentTimeToMedia(media_audio, 0);
  } else if(media_video.length > 0){
    setCurrentTimeToMedia(media_video, 0);
  }
}





/**
Hides slides navigation arrows.
@method hideArrowsInLessonViewer
@for LessonViewerGraphics
**/
function hideArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').hide();
}

/**
Shows slides navigation arrows.
@method showArrowsInLessonViewer
@for LessonViewerGraphics
**/
function showArrowsInLessonViewer() {
  $('#right_scroll, #left_scroll').show();
}





/**
Closes the playlist menu and executes a callback.
@method closePlaylistMenuInLessonViewer
@for LessonViewerPlaylist
@param callback {Function} to call after effect is complete
**/
function closePlaylistMenuInLessonViewer(callback) {
  $('.playlistMenu').slideUp('slow', function() {
    callback();
    showArrowsInLessonViewer();
    $('a._open_playlist span').show();
    $('a._close_playlist span').hide();
  });
}

/**
Opposite of {{#crossLink "LessonViewerPlaylist/closePlaylistMenuInLessonViewer:method"}}{{/crossLink}}.
@method openPlaylistMenuInLessonViewer
@for LessonViewerPlaylist
**/
function openPlaylistMenuInLessonViewer() {
  hideArrowsInLessonViewer();
  $('a._open_playlist span').hide();
  $('a._close_playlist span').show();
  $('.playlistMenu').slideDown('slow');
}

/**
Huge method that replaces missing functionalities of the bad plugin JScrollPain. The aim of this method is to select a lesson in the menu, adapt the size of the scroll pane, and if required scroll and execute a callback.
@method selectComponentInLessonViewerPlaylistMenu
@for LessonViewerPlaylist
@param component {Object} selected lesson
@param callback {Function} to call after function is complete (optional)
**/
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
This method can be used in two ways:
<ul>
  <li><b>with callback</b>, if the user clicks on a lesson in the menu</li>
  <li><b>without callback</b>, if the user gets to a new lesson while navigating normally (he clicks only on <i>next slide</i> and <i>prev slide</i>, see {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewerWithLessonSwitch:method"}}{{/crossLink}})</li>
</ul>
@method switchLessonInPlaylistMenuLessonViewer
@for LessonViewerPlaylist
@param lesson_id {Number} id in the database of the lesson, used to extract the HTML id
@param callback {Function} callback after function is complete (optional)
**/
function switchLessonInPlaylistMenuLessonViewer(lesson_id, callback) {
  if($('._lesson_title_in_playlist').data('lesson-id') != lesson_id) {
    $('._lesson_title_in_playlist').hide();
    $('#lesson_viewer_playlist_title_' + lesson_id).show();
    selectComponentInLessonViewerPlaylistMenu($('#playlist_menu_item_' + lesson_id), callback);
  }
}





/**
Goes to next slide using {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewer:method"}}{{/crossLink}}.
@method goToNextSlideInLessonViewer
@for LessonViewerSlidesNavigation
**/
function goToNextSlideInLessonViewer(with_drop) {
  var next_slide = getLessonViewerCurrentSlide().next();
  if(next_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('._slide_in_lesson_viewer').first(), with_drop, true);
  } else {
    slideToInLessonViewerWithLessonSwitch(next_slide, with_drop, true);
  }
}

/**
Goes to previous slide using {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewer:method"}}{{/crossLink}}.
@method goToPrevSlideInLessonViewer
@for LessonViewerSlidesNavigation
**/
function goToPrevSlideInLessonViewer(with_drop) {
  var prev_slide = getLessonViewerCurrentSlide().prev();
  if(prev_slide.length == 0) {
    slideToInLessonViewerWithLessonSwitch($('._slide_in_lesson_viewer').last(), with_drop, false);
  } else {
    slideToInLessonViewerWithLessonSwitch(prev_slide, with_drop, false);
  }
}

/**
Goes to a given slide. If the new slide contains a media and the browser is not a mobile the media is automaticly played.
@method slideToInLessonViewer
@for LessonViewerSlidesNavigation
@param to {Object} destination slide
**/
function slideToInLessonViewer(to, with_drop, to_right) {
  stopMediaInLessonViewer();
  var from = getLessonViewerCurrentSlide();
  from.removeClass('_lesson_viewer_current_slide');
  to.addClass('_lesson_viewer_current_slide');
  var my_effect = 'fade';
  var my_options = {};
  if(with_drop) {
    my_effect = 'drop';
    my_options = {direction: 'right'};
    if(to_right) {
      my_options = {direction: 'left'};
    }
  }
  from.hide(my_effect, my_options, 500, function() {
    to.show();
    var to_prev = to.prev();
    if(to_prev.length == 0) {
      to_prev = $('._slide_in_lesson_viewer').last();
    }
    var to_next = to.next();
    if(to_next.length == 0) {
      to_next = $('._slide_in_lesson_viewer').first();
    }
    var loading_url = '/lessons/' + to.data('lesson-id') + '/view/slides/' + to.data('slide-id') + '/load?token=' + to.data('lesson-token');
    if($('._lesson_title_in_playlist').length > 0) {
      loading_url += '&with_playlist=true';
    }
    if(!to_prev.data('loaded') || !to.data('loaded') || !to_next.data('loaded')) {
      $.ajax({
        type: 'get',
        beforeSend: unbindLoader(),
        url: loading_url,
        success: function() {
          $('#left_scroll, #right_scroll').removeClass('disabled');
        }
      }).always(bindLoader);
    } else {
      $('#left_scroll, #right_scroll').removeClass('disabled');
    }
    var media = to.find('._instance_of_player');
    var with_autoplay = mustAutoplayMediaInLessonViewer();
    if(media.length > 0 && with_autoplay) {
      media.find('._media_player_play').click();
    }
  });
}

/**
Goes to a slide (using {{#crossLink "LessonViewerSlidesNavigation/slideToInLessonViewer:method"}}{{/crossLink}}) and updates the lesson in playlist menu (using {{#crossLink "LessonViewerPlaylist/switchLessonInPlaylistMenuLessonViewer:method"}}{{/crossLink}} without callbacks).
@method slideToInLessonViewerWithLessonSwitch
@for LessonViewerSlidesNavigation
@param component {Object} destination slide
**/
function slideToInLessonViewerWithLessonSwitch(component, with_drop, to_right) {
  slideToInLessonViewer(component, with_drop, to_right);
  switchLessonInPlaylistMenuLessonViewer(component.data('lesson-id'));
}
