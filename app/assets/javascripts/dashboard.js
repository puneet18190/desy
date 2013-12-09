function dashboardResizeController() {
  var width = $('#dashboard_container').width();
  console.log(width);
}

function dashboardDocumentReady() {
  dashboardResizeController();
  $(window).resize(function() {
    dashboardResizeController();
  });
}
