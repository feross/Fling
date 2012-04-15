SERVER = if LOCAL then "http://localhost" else "http://50.116.7.184"

window.socket = socket = io.connect SERVER

percentOfHeight = (percent) -> $(window).height() * (percent / 100)
percentOfWidth = (percent) -> $(window).width() * (percent / 100)

playWhoosh = ->
  $('body').append '<audio preload="auto" autoplay><source src="/static/sound/whoosh.mp3" /><source src="/static/sound/whoosh.ogg" /></audio>'

$(document).ready ->
    $('#frisbee-button').click ->
        socket.emit 'frisbee', {lat: 5, lng: 5}
        
    navigator.geolocation.getCurrentPosition (position) ->
        console.log(position.coords.latitude, position.coords.longitude)
        # TODO: ask the user for their name
        socket.emit 'id', {lat: position.coords.latitude, lng: position.coords.longitude, name: 'test'}
        
    # TODO: Handle denials, in the case of denial, just fail
    
handleData = (data) ->
    {type, content} = data

    switch type
        when "url"
            a = $("<iframe src='#{content}'></iframe>")
            a.css width: percentOfWidth(100) - 100, height: percentOfHeight(100) - 100
        when "youtube"
            time = if data.time then data.time else ""
            a = $("<iframe src='http://www.youtube.com/embed/#{content}?autoplay=1\#t=#{time}' frameborder='0' autoplay=true allowfullscreen></iframe>")
            a.css width: percentOfWidth(100) - 100, height: percentOfHeight(100) - 100

        when "image"
            $("body").append $("<img src='#{content}'></img>")
        when "spotify"
            document.location = "spotify:track:#{content}"
        else
            alert("Unknown")
            return
    a.hide()
    a.appendTo('.content')
    a.fadeIn('slow')

socket.on 'frisbee', (data) ->
    console.log data

    throwFrisbee ->
        handleData data


throwFrisbee = window.throwFrisbee = (cb) ->
    if !$('.content').length
        $("body").append $('<div>', class: 'content')
    else
        $('.content').empty()

    $('.swoosh').fadeOut().remove()
    oldFrisbee = $ '.frisbee'

    animateFrisbee = ->
        oldFrisbee.remove()

        playWhoosh()

        frisbee = $ '<div>', class: 'frisbee frisbeeContent'
        frisbee.css left: 145, bottom: 137, width: 50, height: 29
        frisbee.appendTo '#fixed'

        frisbee.animate width: percentOfWidth(150), height: percentOfHeight(150),
            duration: 1500
            easing: 'linear'
            queue: false
        frisbee.animate {left: percentOfWidth(75), bottom: percentOfHeight(45)}, 750, 'easeOutQuad'
        frisbee.animate {left: percentOfWidth(-25), bottom: percentOfHeight(-25)}, 750, 'easeInOutQuad', ->
                cb()

    if oldFrisbee.length is 0
        animateFrisbee()
    else if oldFrisbee.hasClass('frisbeeContent')
        oldFrisbee.fadeOut animateFrisbee
    else
        oldFrisbee.animate left: -300, 1000, 'easeInOutQuad', animateFrisbee


showSwoosh = ->
    swoosh = $ '<img>', class: 'swoosh', src: '/static/img/swoosh.png'
    swoosh.css left: 100, bottom: 150, width: percentOfWidth(75), height: percentOfHeight(60) - 50, opacity: 0
    swoosh.appendTo '#fixed'
    swoosh.animate opacity: 1, 500, 'linear'

    # icons = ['music', 'video', 'article']
    # for type in icons
    #     icon = $ '<div>', class: type
    #     icon 

throwLogoFrisbee = (frisbee) ->
    kid2 = $ '<div>', class: 'kid2'
    kid2.css right: -50, bottom: 50
    kid2.appendTo '#fixed'
    kid2.animate right: 75, 250

    frisbee.animate width: 249, height: 145,
        duration: 2500
        easing: 'linear'
        queue: false
    frisbee.animate {left: percentOfWidth(75), bottom: percentOfHeight(45)}, 1250, 'easeOutQuad'
    frisbee.animate {left: percentOfWidth(25), bottom: percentOfHeight(60)}, 1250, 'easeInOutQuad', ->
        showSwoosh()

createCloud = ->
    cloudNum = Math.floor(Math.random()*3) + 1
    cloudTop = Math.floor(Math.random()*200) + 1

    cloud = $ '<div>', class: 'cloud'+cloudNum
    cloud.css left: $(window).width(), top: cloudTop
    cloud.appendTo '#fixed'

    cloud.animate {left: -250}, 60000, 'linear', ->
        cloud.remove()

performYTSearch = (s, cb) ->
    $.ajax
      dataType: 'jsonp'
      type: 'GET'
      url: "http://gdata.youtube.com/feeds/api/videos?q=#{ encodeURIComponent(s) }" +
           "&format=5&v=2&alt=jsonc" + # Force embeddable vids (format=5)
           "&max-results=1"
      success: (responseData, textStatus, XMLHttpRequest) =>
          if videoId = responseData?.data?.items?[0].id
              cb (videoId)

startAnimation = ->
    createCloud()
    window.setInterval ->
        createCloud()
    , 15000

    kid1 = $ '<div>', class: 'kid1'
    kid1.css left: -50, bottom: 50
    kid1.appendTo '#fixed'

    frisbee = $ '<img>', class: 'frisbeeLogo frisbee', src: '/static/img/frisbee-logo.png'
    frisbee.css left: 20, bottom: 137, width: 50, height: 29
    frisbee.appendTo '#fixed'

    time = 500
    kid1.animate left: 75, time
    frisbee.animate left: 145, bottom: 137, time, ->
        window.setTimeout ->
            throwLogoFrisbee(frisbee)
        , 200

$ ->
    search = window.location.search
    if search
        YT_SEARCH = ///youtube=([^&]*)///
        result = YT_SEARCH.exec search
        s = result[1]
        s = s.replace(',', ' ')

        YT_TIME = ///time=([^&]*)///
        result = YT_TIME.exec search
        time = result[1]

        console.log 'hey'

        performYTSearch s, (videoId) ->
            throwFrisbee ->
                handleData type: 'youtube', content: videoId, time: time
    else
        startAnimation()





