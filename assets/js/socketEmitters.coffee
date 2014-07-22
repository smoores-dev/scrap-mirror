emitNewElement = (socket) ->
  (event) ->
    event.preventDefault()
    columnId = $(this).parent().parent().data('columnid')
    content = $('input[name=content]', this).val()

    if columnId?
      index = ($(this).parent().index() + 1) / 2
      console.log index
      socket.emit('newElement', { columnId: +columnId, contentType: 'text', content: content, index: +index })

    else # make a new column with a new element
      socket.emit 'newColumn', { contentType: 'text', content }

$ ->
  socket = io.connect()
  $('form').submit emitNewElement(socket)