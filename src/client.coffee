window.socket = socket = io.connect 'http://localhost'

socket.on 'frisbee', (data) ->
    alert('something!')