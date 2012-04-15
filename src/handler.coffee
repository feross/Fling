LOCAL = off
SERVER = if LOCAL then "http://localhost" else "http://50.116.7.184"

window.socket = socket = io.connect SERVER

window.foundLocation = false
url = window.location.search.substring 1

window.onShake = ->
    if !window.foundLocation
        return

    console.log 'shake'
    window.socket.emit 'frisbee', {
        lat: window.foundPosition.coords.latitude,
        lng: window.foundPosition.coords.longitude,
        url: url
    }, ->
        history.go -1

success = (position) ->
    if (window.foundLocation)
        # not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back
        return

    console.log 'found position'
    window.foundLocation = true
    window.foundPosition = position

error = (msg) ->
    alert 'Geolocation failed. Try again and ALLOW access! ' + msg
    history.go -1

$ ->
    window.addEventListener 'shake', window.onShake

    if (navigator.geolocation)
        navigator.geolocation.getCurrentPosition success, error
    else
        alert 'geolocation not supported'

