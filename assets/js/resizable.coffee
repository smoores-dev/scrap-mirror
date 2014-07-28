$ ->
  oldElementScale = 0
  $('article').resizable(
    autoHide: true
    handles: 'all'
    aspectRatio: true
    start: (event, ui) ->
      # $(window).off 'mousemove'
      click.x = event.clientX
      click.y = event.clientY
      oldElementScale = elementScale(ui.element)

    resize: (event, ui) ->
      screenScale = currScale()
      console.log "screenScale =", screenScale

      deltaX = (event.clientX - click.x) / screenScale
      deltaY = (event.clientY - click.y) / screenScale

      click.x = event.clientX
      click.y = event.clientY

      scaleX = deltaX / (ui.originalSize.width * oldElementScale)
      scaleY = deltaY / (ui.originalSize.height * oldElementScale)

      console.log scaleX, scaleY

      console.log ui.size
      ui.element.css("-webkit-transform": "scale(#{oldElementScale + scaleX + scaleY})")
      ui.size.width = 300
  )