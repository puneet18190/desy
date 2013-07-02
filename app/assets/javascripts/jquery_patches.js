/**
This module contains all the patches for JQuery. Notice that the methods listed here sometimes are defined using anonimous functions fired in this same file: this is because in the javascript loading tree these functions can be loaded where the application needs, rather than in the file <i>document_ready.js</i>.
<br/><br/>
So far the only class present in the module is {{#crossLink "JqueryPatchesBrowsers"}}{{/crossLink}}, used to detect browsers. The functions in this class differ by {{#crossLink "AdminDocumentReady/adminBrowsersDocumentReady:method"}}{{/crossLink}} and {{#crossLink "GeneralDocumentReady/browsersDocumentReady:method"}}{{/crossLink}} because instead of adding a class to the HTML tag they create an attribute for a JQuery object.
@module jquery-patches
**/





/**
Detects if the browser is an iPad, or iPhone, or other mobile browsers, and saves the result in <b>$.browser.[mobile_kind]</b>.
@method mobileDetection
@for JqueryPatchesBrowsers
**/
(function() {
  var ua = navigator.userAgent.toLowerCase();
  if(ua.indexOf('ipad') >= 0) {
    $.browser.ipad = true;
  } else if(ua.indexOf('iphone') >= 0) {
    $.browser.iphone = true;
  }
})();

/**
Checks if the application must autoplay media
@method mustAutoplayMediaInLessonViewer
@for JqueryPatchesBrowsers
**/
function mustAutoplayMediaInLessonViewer() {
  return (!$.browser.ipad && !$.browser.iphone);
}

/**
Checks if the application must react to swipe
@method mustReactToSwipe
@for JqueryPatchesBrowsers
**/
function mustReactToSwipe() {
  return ($.browser.ipad || $.browser.iphone);
}
