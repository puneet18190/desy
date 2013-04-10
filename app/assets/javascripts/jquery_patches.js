/**
bla bla bla (dire che devono venire caricati prima di document ready)
@module jquery-patches
**/





/**
bla bla bla
@method iPadDetection
@for JQueryPatches
**/
(function() {
  var ua = navigator.userAgent.toLowerCase();
  if(ua.indexOf('ipad') >= 0) {
    $.browser.ipad = true;
  }
})();
