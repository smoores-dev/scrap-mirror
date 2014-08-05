$ ->
  content = $ '.content'
  viewOffsetX = viewOffsetY = 0

  screenFitScale = () ->
    scaleX = (window.innerWidth / (window.maxX - window.minX)) * .95
    scaleY = (window.innerHeight / (window.maxY - window.minY)) * .95
    Math.min scaleX, scaleY

  fitTocenter = () ->
    cluster()
    wx = window.innerWidth / 2
    wy = window.innerHeight / 2

    viewOffsetX = (-window.minX) - (window.maxX - window.minX)/2 + wx
    viewOffsetY = (-window.minY) - (window.maxY - window.minY)/2 + wy
  
    content.css
        marginLeft: -viewOffsetX * screenFitScale()
        marginTop: -viewOffsetY * screenFitScale()
    content.css(scale: screenFitScale())

  socket = io.connect()
  fitTocenter()
  scrollTimer = null

  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = content.css 'scale'
    scaleDelta = (parseFloat(oldScale) * (event.deltaY / 100))
    newScale = oldScale - scaleDelta

    tooSmall = newScale < screenFitScale()/2 # zoom out
    tooBig = newScale > 1/window.minScale # zoom in

    if !tooBig && !tooSmall
      viewOffsetX += (event.clientX / 100 / newScale) * -event.deltaY
      viewOffsetY += (event.clientY / 100 / newScale) * -event.deltaY

      content.css
        marginLeft: -viewOffsetX * newScale
        marginTop: -viewOffsetY * newScale

      content.css scale: newScale

      clearTimeout(scrollTimer)
      scrollTimer = setTimeout((() ->
        cluster()
      ), 200)

