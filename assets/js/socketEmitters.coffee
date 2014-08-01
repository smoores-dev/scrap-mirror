$ ->

  socket = io.connect()

  $('.add-space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    # make new space, wait for response to redirect
    socket.emit 'newSpace', { name }
