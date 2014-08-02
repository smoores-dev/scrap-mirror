$ ->

  socket = io.connect()
  $('.add-element').submit (event) ->
    event.preventDefault()
    content = $('input[name=content]', this).val()
    highestZ += 1
    x = 20
    y = 20
    z = highestZ
    scale = 1/currScale()

    if isImage(content)
        contentType = 'image'
    else
        contentType = 'text'

    socket.emit 'newElement', { contentType, content, x, y, z, scale }

    # clear the textbox
    $('input[name=content]', 'form').val('')

  $('.add-space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    # make new space, wait for response to redirect
    socket.emit 'newSpace', { name }

isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true
