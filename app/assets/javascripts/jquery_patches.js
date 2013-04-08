/**
bla bla bla
@method IPadDetection
@for JQueryPatches
**/
(function(){
  var ua = navigator.userAgent.toLowerCase();
  if ( ua.indexOf("ipad") >= 0 ) {
    $.browser.ipad = true;
  }
})();