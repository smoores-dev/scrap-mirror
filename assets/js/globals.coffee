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
    $(this).off 'mouseup'
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

moveAll = () ->

moveSelected = ( ui, offsetLeft, offsetTop ) ->

draggableOptions = (socket) ->
  start: (event, ui) ->
    console.log this.id
    $('.delete').animate(opacity: 100)
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    highestZ += 1
    z = highestZ
    $(this).zIndex z

    console.log ui.position.left, (parseFloat($('#'+this.id).css('left')))*currScale()
    startPosition.left = ui.position.left
    startPosition.top = ui.position.top 

    getIdsInCluster( this.id ).forEach (id)->
      elem = $('#'+id)
      elem.data 'startPosition', {
        left: parseFloat(elem.css('left')) * currScale()
        top: parseFloat(elem.css('top')) * currScale()
      }


  drag: (event, ui) ->
    diffX = event.clientX - click.x
    diffY = event.clientY - click.y
    getIdsInCluster( this.id ).forEach (id)->
      elem = $('#'+id)
      # console.log id, elem
      start = elem.data 'startPosition'
      # ui.position.left, (parseFloat($('#'+this.id).css('left')))*currScale()
      elem.css('left', (event.clientX - click.x + start.left)*currScale())
      elem.css('right', (event.clientY - click.y + start.right)*currScale())

      # elem.css('left', (diffX + start.left) / (currScale()))
      # elem.css('right', (diffY + start.top) / (currScale()))
    # left: 
    # top: (event.clientY - click.y + startPosition.top) / (currScale())
    # if not prevLoc?
    #   prevLoc = ui.originalPosition

    # console.log $(this).position()
        # currentLoc = $(this).position()
    # prevLoc = $(this).data 'prevLoc'
    # if not prevLoc?
    #   prevLoc = ui.originalPosition

    # offsetLeft = currentLoc.left-prevLoc.left
    # offsetTop = currentLoc.top-prevLoc.top
    # moveSelected(offsetLeft, offsetTop);

  drag2: (event, ui) ->
    # s = elementScale(ui.helper)
    # console.log (event.clientX - click.x + startPosition.left), (event.clientX - click.x + startPosition.left) / (currScale())
    
    # ui.position.left, (parseFloat($('#'+this.id).css('left')))*currScale()
    # $('#'+this.id).css('left', (event.clientX - click.x + startPosition.left))
    # ui.position.x /= currScale()

    ui.position = # $('#'+this.id)
      left: (event.clientX - click.x + startPosition.left) / (currScale())
      top: (event.clientY - click.y + startPosition.top) / (currScale())

  stop: (event, ui) ->
    $('.delete').animate(opacity: 0)
    x = parseInt($(this).css('left')) - parseInt(totalDelta.x)
    y = parseInt($(this).css('top')) - parseInt(totalDelta.y)
    z = highestZ
    elementId = this.id
    socket.emit('updateElement', { x, y, z, elementId })