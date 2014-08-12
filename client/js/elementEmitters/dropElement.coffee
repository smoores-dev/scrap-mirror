$ ->

  socket = io.connect()
  $('.delete').droppable(
    tolerance: "pointer"

    # delete the chunk of elements when dropped on the x
    drop: (event, ui) ->
      getIdsInCluster( ui.draggable.attr('id') ).forEach (elementId) ->
        # don't update position of element to be deleted
        $("\##{elementId}").draggable null
        socket.emit 'removeElement', { elementId }
      $(this).removeClass('rollover')

    over: (event, ui) ->
      $(this).addClass('rollover')

    out: (event, ui) ->
      $(this).removeClass('rollover')
  )
