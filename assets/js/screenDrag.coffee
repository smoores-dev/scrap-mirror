$ ->

  $(window).on 'mousedown', (event) ->
    prev =
      x: event.clientX
      y: event.clientY
    $(window).on 'mousemove', (event) ->
      deltaX = (event.clientX - prev.x) / currScale()
      deltaY = (event.clientY - prev.y) / currScale()

      totalDelta.x += deltaX
      totalDelta.y += deltaY

      prev.x = event.clientX
      prev.y = event.clientY

      $('article.text').animate( { top: "+=#{deltaY}", left: "+=#{deltaX}" }, 0, 'linear' )

  $(window).on 'mouseup', ->
    $(this).off 'mousemove'

  $('article').on 'click', (event) ->
    $(window).off 'mousemove'