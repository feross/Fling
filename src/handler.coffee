LOCAL = off
SERVER = if LOCAL then "http://localhost" else "http://50.116.7.184"

window.socket = socket = io.connect SERVER

foundLocation = false
url = window.location.search.substring 1

success = (position) ->
    if (foundLocation)
        # not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back
        return

    foundLocation = true;

    console.log 'emit frisbee!!'
    socket.emit 'frisbee', {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        type: 'url',
        content: url
    }

    history.go -1

error = (msg) ->
    alert 'Geolocation failed. Try again and ALLOW access! ' + msg
    history.go -1

$ ->
    if (navigator.geolocation)
        navigator.geolocation.getCurrentPosition success, error
    else
        alert 'geolocation not supported'

