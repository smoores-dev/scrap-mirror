$ ->
  content = $ '.content'
  viewOffsetX = viewOffsetY = 0

  screenFitScale = () ->
    scaleX = (window.innerWidth / (window.maxX - window.minX)) * .95
    scaleY = (window.innerHeight / (window.maxY - window.minY)) * .95
    scale = Math.min scaleX, scaleY
    if scale isnt 0 then scale else 1
    # 2

  fitTocenter = () ->
    cluster()
    centerX = window.innerWidth / 2
    centerY = window.innerHeight / 2

    scale = screenFitScale()

    sMinX = window.minX * scale
    sMaxX = window.maxX * scale

    sMinY = window.minY * scale
    sMaxY = window.maxY * scale

    clusterCenterX = ((sMinX) + (sMaxX - sMinX)/2)
    clusterCenterY = ((sMinY) + (sMaxY - sMinY)/2)

    viewOffsetX = centerX - clusterCenterX
    viewOffsetY = centerY - clusterCenterY

    content.css
      marginLeft: viewOffsetX
      marginTop: viewOffsetY
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

    # if !tooBig && !tooSmall
    if true
      viewOffsetX += (event.clientX / 100 / newScale) * event.deltaY
      viewOffsetY += (event.clientY / 100 / newScale) * event.deltaY

      content.css
        marginLeft: viewOffsetX  * newScale
        marginTop: viewOffsetY * newScale

      content.css scale: newScale

      clearTimeout(scrollTimer)
      scrollTimer = setTimeout((() ->
        cluster()
      ), 200)

