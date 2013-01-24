function currentPageIs(controller, action) {
  return $('html.'+controller+'-controller.'+action+'-action').length > 0;
}