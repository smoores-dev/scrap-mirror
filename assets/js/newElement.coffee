$ ->

  socket = io.connect()

  isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true

  $(window).on 'dblclick', (event) ->
    screenScale = parseFloat(currScale())
    clickX = event.clientX - $('.content').offset().left
    clickY = event.clientY - $('.content').offset().top
    console.log clickX, clickY

    elementForm =
      "<article class='add-element'>
      <textarea name='content' placeholder='Add something new'></textarea>
      </article>"

    $('.content').append(elementForm)
    $('.add-element').css(
      transform: "scale(#{1/screenScale})"
      "transform-origin": "top left"
      'z-index': highestZ
      top: "#{clickY / screenScale}px"
      left: "#{clickX / screenScale}px")

    $('textarea').focus()
      .on 'blur', (event) -> $(this).parent().remove()
      .on 'keydown', (event) ->
        if event.keyCode is 13
          content = $('textarea[name=content]').val()
          highestZ += 1
          x = Math.floor(clickX - totalDelta.x)
          y = Math.floor(clickY - totalDelta.y)
          z = highestZ
          scale = 1/screenScale

          if isImage(content)
              contentType = 'image'
          else
              contentType = 'text'

          socket.emit 'newElement', { contentType, content, x, y, z, scale }

          # clear the textbox
          $('.add-element').remove()



