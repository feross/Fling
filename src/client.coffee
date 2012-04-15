SERVER = if LOCAL then "http://localhost" else "http://50.116.7.184"

window.socket = socket = io.connect SERVER

$(document).ready ->
    $('#frisbee-button').click ->
        socket.emit 'frisbee', {lat: 5, lng: 5}
        
    navigator.geolocation.getCurrentPosition (position) ->
        console.log(position.coords.latitude, position.coords.longitude)
        # TODO: ask the user for their name
        socket.emit 'id', {lat: position.coords.latitude, lng: position.coords.longitude, name: 'test'}
        
    # TODO: Handle denials, in the case of denial, just fail
    
socket.on 'frisbee', (data) ->
    console.log data
    {type, content} = data
    switch type
        when "url"
            $("body").append $("<iframe src='#{content}'></iframe>")
            # window.open('')
        when "youtube"
            $("body").append $("""<iframe width='420' height='315'
                                  src='http://www.youtube.com/embed/#{content}'
                                  frameborder='0' autoplay=true allowfullscreen></iframe>""")
        when "image"
            $("body").append $("<img src='#{content}'></img>")
        when "spotify"
            document.location = "spotify:track:#{content}"
        else
            alert("Unknown")

window.createCloud = ->
    cloudNum = Math.floor(Math.random()*3) + 1
    cloudTop = Math.floor(Math.random()*200) + 1

    cloud = $ '<div>', class: 'cloud'+cloudNum
    cloud.css left: $(window).width(), top: cloudTop
    cloud.appendTo '#fixed'

    cloud.animate {left: -250}, 45000, 'linear', ->
        cloud.remove()

percentOfHeight = (percent) -> $(window).height() * (percent / 100)
percentOfWidth = (percent) -> $(window).width() * (percent / 100)

throwFrisbee = (frisbee) ->
    kid2 = $ '<div>', class: 'kid2'
    kid2.css right: -50, bottom: 50
    kid2.appendTo '#fixed'
    kid2.animate right: 50, 250

    window.setTimeout ->
        swoosh = $ '<img>', src: '/static/img/swoosh.png'
        swoosh.css left: 100, bottom: 150, width: percentOfWidth(75), height: percentOfHeight(60) - 50, opacity: 0
        swoosh.appendTo '#fixed'
        swoosh.animate opacity: 1,
            duration: 1000,
            easing: 'linear',
            queue: false
    , 1500

    frisbee.animate width: 249,
        duration: 2500
        easing: 'linear'
        queue: false
    frisbee.animate {left: percentOfWidth(75), bottom: percentOfHeight(45)}, 1250, 'easeOutQuad'
    frisbee.animate {left: percentOfWidth(25), bottom: percentOfHeight(60)}, 1250, 'easeInOutQuad'

startAnimation = ->
    window.setTimeout window.createCloud, 0
    window.setInterval window.createCloud, 12000

    kid1 = $ '<div>', class: 'kid1'
    kid1.css left: -50, bottom: 50
    kid1.appendTo '#fixed'

    frisbee = $ '<img>', class: 'frisbee', src: '/static/img/frisbee-logo.png'
    frisbee.css left: 20, bottom: 137, width: 50
    frisbee.appendTo '#fixed'

    time = 500
    kid1.animate left: 50, time
    frisbee.animate left: 120, bottom: 137, time, ->
        window.setTimeout ->
            throwFrisbee(frisbee)
        , 200

$ ->
    startAnimation()