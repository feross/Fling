window.socket = socket = io.connect 'http://localhost'

$(document).ready ->
    $('#frisbee-button').click ->
        socket.emit 'frisbee', {lat: 5, lng: 5}
        
    navigator.geolocation.getCurrentPosition (position) ->
        console.log(position.coords.latitude, position.coords.longitude)
        socket.emit 'id', {lat: position.coords.latitude, lng: position.coords.longitude, name: 'test'}
        
    # TODO: Handle denials, in the case of denial, just fail
    
socket.on 'frisbee', (data) ->
    alert('something!')