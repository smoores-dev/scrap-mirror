totalDelta =
  x: 0
  y: 0

matrixToArray = (str) ->
  str.match(/(-?[0-9\.]+)/g)

currScale = -> matrixToArray($('section.content').css('-webkit-transform'))[0]

elementScale = (element) -> matrixToArray(element.css('-webkit-transform'))[0]

dimension = (elem) ->
  scale = currScale()
  elemScale = elementScale elem
  w = parseInt(elem.css('width')) * elemScale
  h = parseInt(elem.css('height')) * elemScale
  {w, h}

click = {}
startPosition = {}

resize = (socket) ->
  (event) ->
    event.stopPropagation()
    element = $(this).parent()
    clickX = event.clientX
    clickY = event.clientY
    screenScale = currScale()

    $(window).on 'mouseup', (event) ->
      socket.emit 'updateElement', { elementId: element.attr('id'), scale: elementScale(element) }

    $(window).on 'mousemove', (event) ->
      event.preventDefault()
      oldElementScale = elementScale(element)

      deltaX = (event.clientX - clickX) / screenScale
      deltaY = (event.clientY - clickY) / screenScale

      delta = Math.sqrt(deltaX*deltaX + deltaY*deltaY)

      clickX = event.clientX
      clickY = event.clientY

      newScale = delta / Math.sqrt(element.width()*element.width() + element.height() * element.height())

      newScale *= -1 if deltaX < 0 || deltaY < 0

      element.css("-webkit-transform": "scale(#{+oldElementScale + newScale})")

draggableOptions = (socket) ->
  start: (event, ui) ->
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    highestZ += 1
    z = highestZ
    $(this).zIndex z

    startPosition.left = ui.position.left
    startPosition.top = ui.position.top 

  drag: (event, ui) ->
    s = elementScale(ui.helper)
    ui.position =
      left: (event.clientX - click.x + startPosition.left) / (currScale())
      top: (event.clientY - click.y + startPosition.top) / (currScale())

  stop: (event, ui) ->
    xString = $(this).css('left')
    #remove the 'px' from the end of the string
    x = Math.floor(xString.slice(0,xString.length - 2) - totalDelta.x)
    yString = $(this).css('top')
    y = Math.floor(yString.slice(0,yString.length - 2) - totalDelta.y)
    z = highestZ
    elementId = this.id
    socket.emit('updateElement', { x, y, z, elementId })