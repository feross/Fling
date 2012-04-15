solid   = require 'solid'
sio     = require 'socket.io'
{read}  = require('node_util').sync()
{log, inspect}   = require 'util'
dir = inspect

# Configuration
# =============

LOCAL = off
PORT = if LOCAL then 5000 else 80
SIO_PORT = 5001

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
                {lat, lng, name} = client.store.data.info
                log "Sending to #{name}..."
                client.emit 'frisbee', {type: 'youtube', content: '4qYwk37F0PQ'} # {type: 'url', content: 'http://reddit.com'}
    
    app.get "/", @render (req) ->
      @doctype 5
      @html ->
        @head ->
          @title 'Frisbee'
          @js '/jquery.js'
          @script "var window.LOCAL = #{LOCAL}"
          @js '/socket.io/socket.io.js'
          @js 'client.js'
          @css '/static/css/home.css'
        @body ->
            @div '#logo', -> 'Frisbee'
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
