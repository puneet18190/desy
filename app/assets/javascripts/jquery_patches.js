/**
bla bla bla (dire che devono venire caricati prima di document ready, e che a momento c'è solamente la classe per detectare i browsers)
@module jquery-patches
**/





/**
bla bla bla
@method iPadDetection
@for JqueryPatchesBrowsers
**/
(function() {
  var ua = navigator.userAgent.toLowerCase();
  if(ua.indexOf('ipad') >= 0) {
    $.browser.ipad = true;
  }
})();
