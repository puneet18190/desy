function secondsToDateString(seconds) {
  var mm = parseInt(seconds / 60);
  var ss = seconds % 60;
  var hh = parseInt(mm / 60);
  mm = mm % 60;
  var resp = '';
  if(hh > 0) {
    resp = hh + ':';
    if(mm == 0) {
      resp = resp + '00:';
    } else {
      if(mm < 10) {
        resp = resp + '0' + mm + ':';
      } else {
        resp = resp + '' + mm + ':';
      }
    }
    if(ss == 0) {
      resp = resp + '00';
    } else {
      if(mm < 10) {
        resp = resp + '0' + ss;
      } else {
        resp = resp + '' + ss;
      }
    }
  } else {
    if(mm > 0) {
      resp = mm + ':';
      if(ss == 0) {
        resp = resp + '00';
      } else {
        if(ss < 10) {
          resp = resp + '0' + ss;
        } else {
          resp = resp + '' + ss;
        }
      }
    } else {
      resp = ss + '';
    }
  }
  return resp;
}
