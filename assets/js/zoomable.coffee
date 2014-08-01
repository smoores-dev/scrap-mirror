$ ->
  fitTocenter = () ->
    cx = ((maxX - minX)/2) + minX
    cy = ((maxY - minY)/2) + minY
    wx = window.innerWidth / 2
    wy = window.innerHeight / 2

    console.log totalDelta

    deltaX = (-minX) - (maxX - minX)/2 + wx
    deltaY = (-minY) - (maxY - minY)/2 + wy

    totalDelta.x += deltaX
    totalDelta.y += deltaY
    
    $('article').animate( { top: "+=#{deltaY}px", left: "+=#{deltaX}px" }, 0, 'linear' )    
    scaleX = (window.innerWidth / (maxX - minX)) * .95
    scaleY = (window.innerHeight / (maxY - minY)) * .95
    newScale = Math.min(scaleX, scaleY)
    $('section.content').css('-webkit-transform': "scale(#{newScale})")

    console.log "maxX:#{maxX}"
    console.log "minX:#{minX}"
    console.log "maxY:#{maxY}"
    console.log "minY:#{minY}"
    console.log totalDelta

  socket = io.connect()
  fitTocenter()
  scrollTimer = null
  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = currScale()
    scaleDelta = (parseFloat(oldScale) * (event.deltaY / 100))
    newScale = oldScale - scaleDelta
    if newScale > 0.01 && newScale < 6
      $('section.content').css('-webkit-transform': "scale(#{newScale})")
      clearTimeout(scrollTimer)
      scrollTimer = setTimeout((() ->
        cluster()
      ), 200)
      
