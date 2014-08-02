$ ->

  socket = io.connect()

  #adding a new space
  $('.add-space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    # make new space, wait for response to redirect
    socket.emit 'newSpace', { name }

  #adding a new element
  emitElement = (clickX, clickY, screenScale) ->
    console.log "called emitElement"
    text = $('textarea[name=content]').val()
    [content, contentType] = if text? then [text, 'text'] else [$('img','.add-image').attr('src'), 'image']
    caption = $('textarea[name=caption]').val()
    window.maxZ += 1
    x = Math.floor(clickX / screenScale)
    y = Math.floor(clickY / screenScale)
    z = window.maxZ
    scale = 1/screenScale

    console.log totalDelta.x, totalDelta.y

    socket.emit 'newElement', { contentType, content, x, y, z, scale, caption }

    # clear the textbox
    $('.add-element').remove()
    $('.add-image').remove()

  isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true

  $(window).on 'dblclick', (event) ->
    screenScale = parseFloat(currScale())
    clickX = event.clientX - $('.content').offset().left
    clickY = event.clientY - $('.content').offset().top

    elementForm =
      "<article class='add-element'>
        <textarea name='content' placeholder='Add something new'></textarea>
      </article>"

    $('.content').append(elementForm)
    $('.add-element').css(
      transform: "scale(#{1/screenScale})"
      "transform-origin": "top left"
      'z-index': "#{window.maxZ + 1}"
      top: "#{clickY / screenScale}px"
      left: "#{clickX / screenScale}px")

    $('textarea').focus()
      .on 'blur', (event) -> $(this).parent().remove()
      .on 'keydown', (event) ->
        console.log "something"
        if isImage($(this).val())
          imageEl =
            "<article class='image add-image'>
              <div class='card'>
                <img src='#{$(this).val()}'>
                <div class='background'></div>
              </div>
              <div class='card'>
                <textarea name='caption' placeholder='Add a caption'></textarea>
                <div class='background'></div>
              </div>
              <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
              </div>
            </article>"
          $('.content').append(imageEl)
          $('.add-image').css(
            transform: "scale(#{1/screenScale})"
            "transform-origin": "top left"
            'z-index': window.maxZ
            top: "#{clickY / screenScale}px"
            left: "#{clickX / screenScale}px")
          $(this).remove()
          $('textarea').focus()
            .on 'blur', (event) -> emitElement(clickX, clickY, screenScale)
            .on 'keydown', (event) -> emitElement(clickX, clickY, screenScale) if event.keyCode is 13

        else if event.keyCode is 13
          console.log "hey"
          emitElement(clickX, clickY, screenScale)
