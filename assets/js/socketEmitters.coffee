$ ->

  socket = io.connect()
  $('form').submit (event) ->
    event.preventDefault()
    content = $('input[name=content]', this).val()

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


isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true
