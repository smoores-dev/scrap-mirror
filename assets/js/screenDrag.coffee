totalDelta =
  x: 0
  y: 0

$ ->

  matrixToArray = (str) ->
    str.match(/(-?[0-9\.]+)/g)

  $(window).on 'mousedown', (event) ->
    scale = matrixToArray($('section.content').css('-webkit-transform'))[0]
    prev =
      x: event.clientX
      y: event.clientY
    $(this).on 'mousemove', (event) ->
      deltaX = (event.clientX - prev.x) / scale
      deltaY = (event.clientY - prev.y) / scale

      totalDelta.x += deltaX
      totalDelta.y += deltaY

      prev.x = event.clientX
      prev.y = event.clientY

      $('article.text').animate( { top: "+=#{deltaY}", left: "+=#{deltaX}" }, 0, 'linear' )

      $(this).on 'mouseup', ->
        $(this).off 'mousemove'