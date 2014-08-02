screenFitScale = () ->
  scaleX = (window.innerWidth / (maxX - minX)) * .95
  scaleY = (window.innerHeight / (maxY - minY)) * .95
  Math.min scaleX, scaleY

$ ->
  fitTocenter = () ->
    wx = window.innerWidth / 2
    wy = window.innerHeight / 2

    deltaX = (-minX) - (maxX - minX)/2 + wx
    deltaY = (-minY) - (maxY - minY)/2 + wy

    totalDelta.x += deltaX
    totalDelta.y += deltaY
    
    $('article').animate( { top: "+=#{deltaY}px", left: "+=#{deltaX}px" }, 0, 'linear' )    
    $('section.content').css('-webkit-transform': "scale(#{screenFitScale()})")

  socket = io.connect()
  fitTocenter()
  scrollTimer = null
  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = currScale()
    scaleDelta = (parseFloat(oldScale) * (event.deltaY / 100))
    newScale = oldScale - scaleDelta
    # console.log newScale, screenFitScale()
    if newScale > screenFitScale()/2 && newScale < 6
      $('section.content').css('-webkit-transform': "scale(#{newScale})")
      clearTimeout(scrollTimer)
      scrollTimer = setTimeout((() ->
        cluster()
      ), 200)
      
