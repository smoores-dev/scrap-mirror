$ ->

  socket = io.connect()
  $('.add').submit (event) ->
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

  $('.space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    socket.emit 'newSpace', { name }
    spaceId = 1

    # redirect to new page
    window.location.href = "/s/" + spaceId

isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true