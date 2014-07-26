$ ->

  socket = io.connect()
  $('.add').submit (event) ->
    event.preventDefault()
    content = $('input[name=content]', this).val()
    x = 20
    y = 20
    z = 1
    scale = 1/currScale()

    socket.emit 'newElement', { contentType: 'text', content, x, y, z, scale }

    # clear the textbox
    $('input[name=content]', 'form').val('')

  $('.space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    socket.emit 'newSpace', { name }
    spaceId = 1

    # redirect to new page
    window.location.href = "/s/" + spaceId