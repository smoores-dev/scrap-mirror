$ ->

  socket = io.connect()

  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = currScale()
    newScale = parseFloat(oldScale) * (event.deltaY / 100)
    $('section.content').css(
      '-webkit-transform': "scale(#{oldScale - newScale})"
    )