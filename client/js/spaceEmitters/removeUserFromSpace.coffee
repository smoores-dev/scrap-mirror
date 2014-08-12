$ ->

  socket = io.connect()

  # deleting a user from a space
  $('.deletable-user').on 'click', (event) ->
    event.preventDefault()
    id = $(this).data 'id'
    socket.emit 'removeUserFromSpace', { id }
