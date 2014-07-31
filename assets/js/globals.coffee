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
    console.log 'Moving', getIdsInCluster( this.id )
    $('.delete').addClass('visible')
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    highestZ += 1
    z = highestZ
    $(this).zIndex z

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
      start = elem.data 'startPosition'
      elem.css('left', (event.clientX - click.x + start.left)/currScale())
      elem.css('top', (event.clientY - click.y + start.top)/currScale())

    ui.position = # $('#'+this.id)
      left: (event.clientX - click.x + startPosition.left) / (currScale())
      top: (event.clientY - click.y + startPosition.top) / (currScale())

  stop: (event, ui) ->
    $('.delete').removeClass('visible')
    getIdsInCluster( this.id ).forEach (id) ->
      elem = $('#'+id)
      x = parseInt(elem.css('left')) - parseInt(totalDelta.x)
      y = parseInt(elem.css('top')) - parseInt(totalDelta.y)
      z = elem.zIndex();
      # z = highestZ
      elementId = id
      # elementId = this.id
      socket.emit('updateElement', { x, y, z, elementId })