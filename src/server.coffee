net = require 'net'
{log, inspect}   = require 'util'
solid   = require 'solid'
sio     = require 'socket.io'
{read}  = require('node_util').sync()


# Aliases
# =======

dir = inspect

# Configuration
# =============

LOCAL = on
PORT = if LOCAL then 5000 else 80
SIO_PORT = 5001
TCP_PORT = 5002
IPHONE_TCP_PORT = 5003

# App
# ===

solid {port: PORT, cwd: "#{__dirname}/.."}, (app) ->
    
    # socket.io server
    io = sio.listen app.app
    io.configure () ->
      io.set 'transports', ['websocket']
      io.disable 'log'
      
    io.sockets.on 'connection', (socket) ->
                
        socket.on 'id', (msg) ->
            socket.set('info', msg)
            socket.get 'info', (err, info) ->
                log(inspect(info))
        
        socket.on 'frisbee', (data) ->
            log 'frisbee!!!'

            for client in io.sockets.clients()
                
                # TODO: Catch error here, which happens when the messages are too fast?
                # while client.store.data.info isnt undefined
                [lat, lng, name] = [5,5, 'test'] # client.store.data.info

                log "Sending to #{name}..."
                                
                client.emit 'frisbee', data
                # Messages for different kinds of content
                # TODO: Convert music to a spotify thing
                # {type: 'spotify', content: '7My5AMVGC5KUYgsxZVOQUI'}
                # {type: 'image', content: 'http://i.imgur.com/RJlON.jpg'}
                # {type: 'youtube', content: '4qYwk37F0PQ'}
                # {type: 'url', content: 'http://reddit.com'}
    
    app.get "/", @render (req) ->
        @doctype 5
        @html ->
            @head ->
                @title 'Frisbee'
                @js '/jquery.js'
                @js '/static/js/libs/jquery-ui-1.8.18.custom.min.js'
                @script "window.LOCAL = #{LOCAL};"
                @js '/socket.io/socket.io.js'
                @js 'client.js'
                @css '/static/css/home.css'
            @body ->
                @div '#fixed'
                @input {id: 'frisbee-button', type: 'button', value: 'frisbee'}
            
    app.post "/new", @render (req) ->
        # req.params.id
        # TODO: Send to the right socket, only the ones closest to the
            
    app.get "/home", "/"           # URL rewriting/redirects
    app.get "/jquery.js", @jquery  # Put <script src="/jquery.js"></script> in HTML
    app.get "/javascripts/client.js" , () -> type: 'text/javascript', body: read("#{__dirname}/../js/client.js")
    app.get "/javascripts/bookmarklet.js", () -> type: 'text/javascript', body: read("#{__dirname}/../js/bookmarklet.js")
    app.get "/javascripts/handler.js", () -> type: 'text/javascript', body: read("#{__dirname}/../js/handler.js")
    
    # app.namespace "/user", ->
    #   app.get "/:id", @render (req) ->
    #     @p "Hi, #{req.params.id}!"
    # 
    #   app.get "/:id/requests", (req) ->
    #     "<p>#{req.params.id}: you have no requests.</p>"


# TCP server that the Mac app polls to find out if it has received any messages
# We have to kill dead connections, etc.

dummy = ""

# TCP Text Protocol
# poll -> empty | w:[url] | m:[song] 
net.createServer( (socket) ->
    msg = ""
    socket.on 'data', (data) ->
        msg += data.toString 'ascii'
        console.log msg
        if msg is 'poll' and dummy isnt ""
            socket.write dummy
            dummy = ""
        else
            socket.write 'empty'
        
    socket.on 'end', () ->
        
).listen TCP_PORT

log "Running Mac TCP server on #{TCP_PORT}"

# iPhone TCP server

net.createServer( (socket) ->
    msg = ""
    socket.on 'data', (data) ->
        msg += data.toString 'ascii'
        dummy = msg
        console.log msg
        
    socket.on 'end', () ->
        
).listen IPHONE_TCP_PORT

log "Running iPhone TCP server on #{IPHONE_TCP_PORT}"