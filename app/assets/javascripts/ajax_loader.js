/**
Shows a loading image while page is loading, it handles ajax calls too.
@module ajax-loader
**/

/**
Initializes the ajax loader. Used also in {{#crossLinkModule "administration"}}{{/crossLinkModule}}.
@method ajaxLoaderDocumentReady
@for AjaxLoaderDocumentReady
**/
function ajaxLoaderDocumentReady() {
  bindLoader();
}

/**
Bind Loader, show loader on ajaxStart and hide loader on ajaxStop.
@method bindLoader
@for AjaxLoaderBinder
**/
function bindLoader() {
  showLoader();
  var oldLoad = window.onload;
  var newLoad = function() {
    hideLoader();
  };
  if(oldLoad) {
    newLoad = function() {
      hideLoader();
      oldLoad.call(this);
    };
  }
  window.onload = newLoad;
  $('#loading').bind({
    ajaxStart: function() {
      showLoader();
    },
    ajaxStop: function() {
      hideLoader();
    }
  });
}

/**
Unbind Loader, unbind loader for ajaxStart and ajaxStop.
@method unbindLoader
@for AjaxLoaderBinder
**/
function unbindLoader() {
  $('#loading').unbind('ajaxStart ajaxStop');
}

/**
Show Loader, force loader to show. It comes with timeout (default=5000) to force loader to hide [hideLoader](../classes/hideLoader.html#method_hideLoader)
@method showLoader
@for AjaxLoaderVisibility
**/
function showLoader() {
  var loader = $('#loading .containerLoading');
  loader.css('top', (($(window).height() / 2) - 100) + 'px');
  loader.css('left', (($(window).width() / 2) - 50) + 'px');
  $('#loading').show();
  setTimeout('hideLoader()', 5000);
}

/**
Hide Loader, force loader to hide.
@method hideLoader
@for AjaxLoaderVisibility
**/
function hideLoader() {
  $('#loading').hide();
}
