// Limit scope pollution from any deprecated API
(function() {

var matched, browser;

// Use of jQuery.browser is frowned upon.
// More details: http://api.jquery.com/jQuery.browser
// jQuery.uaMatch maintained for back-compat
jQuery.uaMatch = function( ua ) {
  var match = [];
  ua = ua.toLowerCase();

  if(ua.indexOf('ipad') >= 0) {
    match[ 0 ] = 'ipad';
  } else if(ua.indexOf('iphone') >= 0) {
    match[ 0 ] = 'iphone';
  } else {
    match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
      /(webkit)[ \/]([\w.]+)/.exec( ua ) ||
      /(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
      // Internet Explorer < 11
      /(msie) ([\w.]+)/.exec( ua ) ||
      // Internet Explorer >= 11
      /(trident)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
      ( ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) );

    if ( match[ 1 ] === "trident" ) {
      match[ 1 ] = "msie";
    }
  }

  return {
    browser: match[ 1 ] || "",
    version: match[ 2 ] || "0"
  };
};

matched = jQuery.uaMatch( navigator.userAgent );
browser = {};

if ( matched.browser ) {
  browser[ matched.browser ] = true;
  browser.version = matched.version;
}

// Chrome is Webkit, but Webkit is also Safari.
if ( browser.chrome ) {
  browser.webkit = true;
} else if ( browser.webkit ) {
  browser.safari = true;
}

jQuery.browser = browser;

})();
