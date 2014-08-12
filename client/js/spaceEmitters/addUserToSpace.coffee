$ ->

  socket = io.connect()

  # adding a user to a space
  $('.add-user').on 'submit', (event) ->
    event.preventDefault()
    email = $('input[name="user[email]"]', this).val()
    $('input[name="user[email]"]', this).val('')
    socket.emit 'addUserToSpace', { email }
