function getNormalizedPositionTimelineHorizontalScrollPane(jscrollpane_id, component_width, component_position, components_visible_number) {
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width);
  var resp = how_many_hidden_to_left * component_width;
  if(how_many_hidden_to_left + components_visible_number < component_position) {
    resp += component_width;
  }
  return resp;
}

function getAbsolutePositionTimelineHorizontalScrollPane(jscrollpane_id, component_width, component_position, components_visible_number) {
  var how_many_hidden_to_left = getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width);
  var resp = (components_visible_number - 1);
  if(how_many_hidden_to_left + components_visible_number >= component_position) {
   resp = (component_position - how_many_hidden_to_left - 1);
  }
  return resp * component_width;
}

function getHowManyComponentsHiddenToLeftTimelineHorizontalScrollPane(jscrollpane_id, component_width) {
  var hidden_to_left = $('#' + jscrollpane_id).data('jsp').getContentPositionX();
  var how_many_hidden_to_left = parseInt(hidden_to_left / component_width);
}
