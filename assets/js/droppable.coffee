$ ->

  socket = io.connect()
  $('.delete').droppable(
    drop: (event, ui) ->
      elementId = ui.draggable.attr('id')
      socket.emit 'removeElement', { elementId }
    over: (event, ui) ->
      console.log "HOVER"
      $(this).addClass('hover')
    out: (event, ui) ->
      $(this).removeClass('hover')
  )