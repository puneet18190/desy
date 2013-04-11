/**
This module contains all the patches for JQuery. Notice that the methods listed here sometimes are defined using anonimous functions fired in this same file: this is because in the javascript loading tree these functions can be loaded where the application needs, rather than in the file <i>document_ready.js</i>.
<br/><br/>
So far the only class present in the module is {{#crossLink "JqueryPatchesBrowsers"}}{{/crossLink}}, used to detect browsers. The functions in this class differ by {{#crossLink "AdminDocumentReady/adminBrowsersDocumentReady:method"}}{{/crossLink}} and {{#crossLink "GeneralDocumentReady/browsersDocumentReady:method"}}{{/crossLink}} because instead of adding a class to the HTML tag they create an attribute for a JQuery object.
@module jquery-patches
**/





/**
Detects if the browser is an iPad, and saves the result in <b>$.browser.ipad</b>.
@method iPadDetection
@for JqueryPatchesBrowsers
**/
(function() {
  var ua = navigator.userAgent.toLowerCase();
  if(ua.indexOf('ipad') >= 0) {
    $.browser.ipad = true;
  }
})();
