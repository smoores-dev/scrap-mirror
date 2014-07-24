$ ->

  matrixToArray = (str) ->
    str.match(/(-?[0-9\.]+)/g)

  $(window).on 'mousedown', (event) ->
    scale = matrixToArray($('section.content').css('-webkit-transform'))[0]
    prev =
      x: event.clientX
      y: event.clientY
    $(this).on 'mousemove', (event) ->
      deltaX = event.clientX - prev.x
      deltaY = event.clientY - prev.y

      prev.x = event.clientX
      prev.y = event.clientY

      $('article.text').animate( { top: "+=#{deltaY / scale}", left: "+=#{deltaX / scale}" }, 0, 'linear' )

      $(this).on 'mouseup', ->
        $(this).off 'mousemove'