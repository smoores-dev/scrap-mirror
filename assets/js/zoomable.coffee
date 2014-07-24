$ ->

  socket = io.connect()

  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = matrixToArray($('section.content').css('-webkit-transform'))[0]
    newScale = parseFloat(oldScale) * (event.deltaY / 100)
    $('section.content').css(
      '-webkit-transform': "scale(#{oldScale - newScale})"
    )