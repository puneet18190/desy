// This is a manifest file that'll be compiled into admin.js, which will include all the files
// listed below.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.9.0.custom
//= require jquery.peity
//= require bootstrap
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-datepicker
//= require jquery-fileupload/basic
//= require ajax_loader
//= require admin/functions

$(document).ready(function() {
  window.$html = $('html');
  window.$loaderVisible = true;
  window.$loading = $('#loading');
  window.$body = $('body');
  window.$captions = $('#popup_captions_container');
  window.$parameters = $('#popup_parameters_container');
  ajaxLoaderDocumentReady();
  adminSearchDocumentReady();
  adminSortingDocumentReady();
  adminUsersDocumentReady();
  adminMediaElementsDocumentReady();
  adminMiscellaneaDocumentReady();
  adminEffectsDocumentReady();
  adminBrowsersDocumentReady();
  adminLocationsDocumentReady();
});
