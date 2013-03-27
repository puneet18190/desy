/**
* Shows a loading image while page is loading, 
* it handles ajax calls too.
* 
* @module Times
*/

/**
* Get seconds amount formatted as datetime
* 
* @method secondsToDateString
* @for secondsToDateString
* @param seconds {Number} amount of seconds
* @return {String} formatted seconds 
*/
function secondsToDateString(seconds) {
  var mm = parseInt(seconds / 60);
  var ss = seconds % 60;
  var hh = parseInt(mm / 60);
  mm = mm % 60;
  var resp = '';
  if(hh > 0) {
    resp = hh + ':';
  }
  if(mm > 9) {
    resp = mm + ':';
  } else {
    resp = '0' + mm + ':';
  }
  if(ss > 9) {
    resp = resp + ss;
  } else {
    resp = resp + '0' + ss;
  }
  return resp;
}
