$ ->

  socket = io.connect()

  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = currScale()
    scaleDelta = (parseFloat(oldScale) * (event.deltaY / 100))
    newScale = oldScale - scaleDelta
    if newScale > 0.01 && newScale < 6
      $('section.content').css(
        '-webkit-transform': "scale(#{newScale})"
      )