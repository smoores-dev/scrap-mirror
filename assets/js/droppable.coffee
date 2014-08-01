$ ->

  socket = io.connect()
  $('.delete').droppable(
    tolerance: "touch"
    drop: (event, ui) ->
      elementId = ui.draggable.attr('id')
      socket.emit 'removeElement', { elementId }
      $(this).removeClass('rollover')
    over: (event, ui) ->
      $(this).addClass('rollover')
    out: (event, ui) ->
      $(this).removeClass('rollover')
  )