$ ->

  socket = io.connect()
  $('.delete').droppable(
    tolerance: "pointer"

    drop: (event, ui) ->
      getIdsInCluster( ui.draggable.attr('id') ).forEach (elementId) ->
        $("\##{elementId}").draggable null
        socket.emit 'removeElement', { elementId }
      $(this).removeClass('rollover')

    over: (event, ui) ->
      $(this).addClass('rollover')

    out: (event, ui) ->
      $(this).removeClass('rollover')
  )
