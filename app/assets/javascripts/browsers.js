/**
bla bla bla
@for BrowsersDocumentReady
@method browsersDocumentReady
**/
function browsersDocumentReady() {
  (function(){
    var name = $.grep(_.keys($.browser), function(el, i) {
      return el !== 'version';
    })[0];
    if(name) {
      $('html').addClass(name);
    }
    if($('html').hasClass('msie')) {
      $('._audio_editor_component ._double_slider .ui-slider-range').css('opacity', 0.4);
    }
  })();
}
