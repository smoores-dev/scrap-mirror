draggableOptions = (socket) ->
  start: (event, ui) ->
    screenScale = $('.content').css('scale')
    if not getIdsInCluster( this.id )?
      return
    $('.delete').addClass('visible')
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    window.maxZ += 1
    z = window.maxZ
    $(this).zIndex z

    startPosition.left = ui.position.left
    startPosition.top = ui.position.top 

    getIdsInCluster( this.id ).forEach (id)->
      elem = $('#'+id)
      elem.data 'startPosition', {
        left: parseFloat(elem.css('left')) * screenScale
        top: parseFloat(elem.css('top')) * screenScale
      }

  drag: (event, ui) ->
    screenScale = $('.content').css('scale')
    diffX = event.clientX - click.x
    diffY = event.clientY - click.y
    getIdsInCluster( this.id ).forEach (id)->
      elem = $('#'+id)
      start = elem.data 'startPosition'
      elem.css('left', (event.clientX - click.x + start.left)/screenScale)
      elem.css('top', (event.clientY - click.y + start.top)/screenScale)

    ui.position = # $('#'+this.id)
      left: (event.clientX - click.x + startPosition.left) / (screenScale)
      top: (event.clientY - click.y + startPosition.top) / (screenScale)

  stop: (event, ui) ->
    $('.delete').removeClass 'visible'
    getIdsInCluster( this.id ).forEach (id) ->
      elem = $('#'+id)
      x = parseInt(elem.css('left')) - parseInt(totalDelta.x)
      y = parseInt(elem.css('top')) - parseInt(totalDelta.y)
      z = elem.zIndex()
      elementId = id
      
      window.maxX = Math.max x, maxX
      window.minX = Math.min x, minX

      window.maxY = Math.max y, maxY
      window.minY = Math.min y, minY

      socket.emit('updateElement', { x, y, z, elementId })

$ ->
  socket = io.connect()
  $('article').draggable draggableOptions socket