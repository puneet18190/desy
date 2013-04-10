/**
Here it's defined the general <b>ajax loader</b> of the application.
@module ajax-loader
**/





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
Unbind Loader, unbind loader for ajaxStart and ajaxStop. Used occasionally, when the loader is not necessary (for instance in {{#crossLinkModule "lesson-editor"}}{{/crossLinkModule}})
@method unbindLoader
@for AjaxLoaderBinder
**/
function unbindLoader() {
  $('#loading').unbind('ajaxStart ajaxStop');
}





/**
Initializes the ajax loader. Used also in the initialization of the module {{#crossLinkModule "administration"}}{{/crossLinkModule}}.
@method ajaxLoaderDocumentReady
@for AjaxLoaderDocumentReady
**/
function ajaxLoaderDocumentReady() {
  bindLoader();
}





/**
Hides the loader without binding or unbinding it.
@method hideLoader
@for AjaxLoaderVisibility
**/
function hideLoader() {
  $('#loading').hide();
}

/**
Shows the loader without binding or unbinding it (it has a timeout of 5000).
@method showLoader
@for AjaxLoaderVisibility
**/
function showLoader() {
  var loader = $('#loading .containerLoading');
  loader.css('top', (($(window).height() / 2) - 100) + 'px');
  loader.css('left', (($(window).width() / 2) - 50) + 'px');
  $('#loading').show();
  setTimeout(function() {
    hideLoader()
  }, 5000);
}
