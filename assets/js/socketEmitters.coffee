$ ->

  socket = io.connect()
  $('form').submit (event) ->
    event.preventDefault()
    content = $('input[name=content]', this).val()
    x = 20
    y = 20
    z = 1
    scale = 1

    socket.emit 'newElement', { contentType: 'text', content, x, y, z, scale }

    # clear the textbox
    $('input[name=content]', 'form').val('')