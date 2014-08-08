$ ->
  content = $ '.content'
  viewOffsetX = viewOffsetY = 0

  screenFitScale = () ->
    scaleX = (window.innerWidth / (window.maxX - window.minX)) * .95
    scaleY = (window.innerHeight / (window.maxY - window.minY)) * .95
    Math.min scaleX, scaleY

  fitToCenter = () ->
    cluster()
    scale = Math.min(screenFitScale(), 1/window.minScale)
    scale = if scale isnt 0 then scale else 1

    centerX = window.innerWidth / 2 / scale
    centerY = window.innerHeight / 2 / scale

    clusterCenterX = ((window.minX) + (window.maxX - window.minX) / 2)
    clusterCenterY = ((window.minY) + (window.maxY - window.minY) / 2)

    clusterCenterX = if isNaN clusterCenterX then 0 else clusterCenterX
    clusterCenterY = if isNaN clusterCenterY then 0 else clusterCenterY

    viewOffsetX = centerX - clusterCenterX
    viewOffsetY = centerY - clusterCenterY

    content.css
      marginLeft: viewOffsetX * scale
      marginTop: viewOffsetY * scale

    content.css({ scale })

  socket = io.connect()
  fitToCenter()
  scrollTimer = null

  $(window).on 'mousewheel', (event) ->
    event.preventDefault()
    oldScale = content.css 'scale'
    scaleDelta = (parseFloat(oldScale) * (event.deltaY / 100))
    newScale = oldScale - scaleDelta

    tooSmall = newScale < screenFitScale()/2 # zoom out
    tooBig = newScale > 1/window.minScale # zoom in

    console.log tooBig, tooSmall

    if !tooBig && !tooSmall
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

