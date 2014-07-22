emitNewElement = (socket) ->
  (event) ->
    event.preventDefault()
    columnId = $('input[name=columnId]', this).val()
    content = $('input[name=content]', this).val()

    if columnId?
      index = $('input[name=index]', this).val()
      socket.emit('newElement', { columnId: +columnId, contentType: 'text', content: content, index: +index })

    else # make a new column with a new element
      socket.emit 'newColumn', { contentType: 'text', content }

$ ->
  socket = io.connect()
  $('form').submit emitNewElement(socket)