$ ->

  socket = io.connect()
  $('.delete').droppable(
    tolerance: "pointer"

    drop: (event, ui) ->
      getIdsInCluster( ui.draggable.attr('id') ).forEach (elementId)->
        socket.emit 'removeElement', { elementId }
      $(this).removeClass('hover')

    over: (event, ui) ->
      $(this).addClass('hover')
    out: (event, ui) ->
      $(this).removeClass('hover')
  )