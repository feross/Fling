solid   = require 'solid'
sio     = require 'socket.io'
{read}  = require('node_util').sync()
{log}   = require 'util'

# Configuration
# =============

PORT = 5000
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
        log 'New connection!'
        
    app.get "/", @render (req) ->
      @doctype 5
      @html ->
        @head ->
          @title 'Fling'
          @js '/jquery.js'
          @js '/socket.io/socket.io.js'
          @js 'client.js'
          @css '/static/css/home.css'
        @body ->
            @div -> 'Fling'
            
    app.post "/new", @render (req) ->
        # req.params.id
        # TODO: Send to the right socket, only the ones closest to the
            
    app.get "/home", "/"           # URL rewriting/redirects
    app.get "/jquery.js", @jquery  # Put <script src="/jquery.js"></script> in HTML
    app.get "/javascripts/client.js" , () -> type: 'text/javascript', body: read("#{__dirname}/../js/client.js")
    
    # app.namespace "/user", ->
    #   app.get "/:id", @render (req) ->
    #     @p "Hi, #{req.params.id}!"
    # 
    #   app.get "/:id/requests", (req) ->
    #     "<p>#{req.params.id}: you have no requests.</p>"
