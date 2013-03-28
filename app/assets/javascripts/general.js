/**
* Generic shared javascript functions
* 
* @module General
*/

/**
* Add new parameters to an url
* 
* @method updateURLParameter
* @for updateURLParameter
* @param url {String} starting url
* @param param {String} new param
* @param paramVal {String} new param value
* @return {String} updated url
*/
function updateURLParameter(url, param, paramVal) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i<tempArray.length; i++){
      if(tempArray[i].split('=')[0] != param){
        newAdditionalURL += temp + tempArray[i];
        temp = '&';
      }
    }
  }
  var rows_txt = temp + '' + param + '=' + paramVal;
  return baseURL + '?' + newAdditionalURL + rows_txt;
}

/**
* Remove a param from url
* 
* @method removeURLParameter
* @for removeURLParameter
* @param url {String} starting url
* @param param {String} param to remove
* @return {String} update url
*/
function removeURLParameter(url, param) {
  var newAdditionalURL = '';
  var tempArray = url.split('?');
  var baseURL = tempArray[0];
  var additionalURL = tempArray[1];
  var temp = '';
  if (additionalURL) {
    tempArray = additionalURL.split('&');
    for (i=0; i<tempArray.length; i++){
      if(tempArray[i].split('=')[0] != param){
        newAdditionalURL += temp + tempArray[i];
        temp = '&';
      }
    }
  }
  return baseURL + '?' + newAdditionalURL;
}

/**
* Center a div into a given container
* 
* @method centerThisInContainer
* @for centerThisInContainer
* @param div {String} div selector to center, class or id
* @param container {String} container selector to center div into, class or id
* @example
      centerThisInContainer('._saved','#image_wrapper');
*/
function centerThisInContainer(div,container) {
  var contH = $(container).height();
  var contW = $(container).width();
  var centerDiv = $(div);
  centerDiv.css('top', (contH/2-centerDiv.height()/2)+$(container).position().top);
  centerDiv.css('left', (contW/2-centerDiv.width()/2)+$(container).position().left);
}

/**
* Center a div into current window
* 
* @method centerThis
* @for centerThis
* @param div {String} div selector to center, class or id
* @example
      centerThis("._slide_error");
*/
function centerThis(div) {
  var winH = $(window).height();
  var winW = $(window).width();
  var centerDiv = $(div);
  centerDiv.css('top', winH/2-centerDiv.height()/2);
  centerDiv.css('left', winW/2-centerDiv.width()/2);
}
