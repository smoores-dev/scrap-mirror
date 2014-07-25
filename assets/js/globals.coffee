totalDelta =
  x: 0
  y: 0

matrixToArray = (str) ->
  str.match(/(-?[0-9\.]+)/g)

currScale = -> matrixToArray($('section.content').css('-webkit-transform'))[0]

elementScale = (element) -> matrixToArray(element.css('-webkit-transform'))[0]

click = {}
startPosition = {}

draggableOptions = (socket) ->
  start: (event, ui) ->
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    highestZ += 1
    z = highestZ
    $(this).zIndex z

    ui.position =
      left: ui.position.left / elementScale(ui.helper)
      top: ui.position.top / elementScale(ui.helper)

    startPosition.left = ui.position.left
    startPosition.top = ui.position.top

  drag: (event, ui) ->

    ui.position =
      left: (event.clientX - click.x + startPosition.left) / currScale()
      top: (event.clientY - click.y + startPosition.top) / currScale()

  stop: (event, ui) ->
    xString = $(this).css('left')
    #remove the 'px' from the end of the string
    x = Math.floor(xString.slice(0,xString.length - 2) - totalDelta.x)
    yString = $(this).css('top')
    y = Math.floor(yString.slice(0,yString.length - 2) - totalDelta.y)
    z = highestZ
    elementId = this.id
    
    socket.emit('updateElement', { x, y, z, elementId })