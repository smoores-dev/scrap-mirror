$ ->

  $(window).on 'mousedown', (event) ->
    $(this).off 'mouseup'
    prev =
      x: event.clientX
      y: event.clientY
      
    $(window).on 'mousemove', (event) ->
      screenScale = $('.content').css('scale')
      deltaX = (event.clientX - prev.x) / screenScale
      deltaY = (event.clientY - prev.y) / screenScale

      totalDelta.x += deltaX
      totalDelta.y += deltaY   

      prev.x = event.clientX
      prev.y = event.clientY

      $('article').animate( { top: "+=#{deltaY}", left: "+=#{deltaX}" }, 0, 'linear' )

    $(window).on 'mouseup', ->
      $(this).off 'mousemove'

  $('article').on 'click', (event) ->
    $(window).off 'mousemove'
