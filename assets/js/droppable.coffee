$ ->

  socket = io.connect()
  $('.delete').droppable(
    drop: (event, ui) ->
      elementId = ui.draggable.attr('id')
      socket.emit 'removeElement', { elementId }
  )