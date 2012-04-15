var foundLocation = false;

function success(position) {
  if (foundLocation) {
    // not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back    
    return;
  }

  foundLocation = true;
  
  var latlng = {
    lat: position.coords.latitude,
    lng: position.coords.longitude
  };

  history.go(-1);

}

function error(msg) {
  alert ('Geolocation failed. Try again and ALLOW access! ' + msg);
  history.go(-1);
}

$(function() {
	var url = window.location.search.substring(1);

	if (navigator.geolocation) {
	  navigator.geolocation.getCurrentPosition(success, error);
	} else {
	  alert('geolocation not supported');
	}
});

