renameSpace = (socket) ->
  (event) ->
    event.stopPropagation()
    parent = $(this).parent()
    oldName = $(this).html()
    $(this).text('')

    formEl = "<form><input type='text' name='name' value='#{oldName}'><input style='visibility:hidden' type='submit'></form>"
    $(this).append(formEl)
    $('input[name="name"]').focus()
      .on 'blur', (event) ->
        $(this).parent().remove()
        $('.space').append("<h1>#{oldName}</h1>")
        $('h1').on 'dblclick', renameSpace socket
    $('form').css(
        'z-index':2
        position: 'fixed'
        top: "#{$(this).offset().top}px"
        left: "#{$(this).offset().left}px")
    
    $('form').submit (event) ->
      event.preventDefault()
      newName = $('input[name="name"]').val()
      $(this).remove()
      socket.emit 'updateSpace', { name : newName }

$ ->

  socket = io.connect()

  #adding a new space
  $('.add-space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()

    # make new space, wait for response to redirect
    socket.emit 'newSpace', { name }

  # update a space
  $('h1').on 'dblclick', renameSpace socket

  #adding a new element
  emitElement = (clickX, clickY, screenScale) ->
    text = $('textarea[name=content]').val()
    [content, contentType] = if text? then [text, 'text'] else [$('img','.add-image').attr('src'), 'image']
    caption = $('textarea[name=caption]').val()
    window.maxZ += 1
    x = Math.floor(clickX / screenScale)
    y = Math.floor(clickY / screenScale)
    z = window.maxZ
    scale = 1/screenScale

    socket.emit 'newElement', { contentType, content, x, y, z, scale, caption }

    # clear the textbox
    $('.add-element').remove()
    $('.add-image').remove()

  isImage = (url) ->
    return false if (url.match(/\.(jpeg|jpg|gif|png)$/) == null)
    true

  $(window).on 'dblclick', (event) ->
    screenScale = $('.content').css('scale')
    clickX = event.clientX - $('.content').offset().left
    clickY = event.clientY - $('.content').offset().top

    elementForm =
      "<article class='add-element'>
        <div class='card text'>
          <textarea name='content' placeholder='Add something new'></textarea>
        </div>
      </article>"

    $('.content').append(elementForm)
    $('.add-element').css(
      scale: 1/screenScale
      "transform-origin": "top left"
      'z-index': "#{window.maxZ + 1}"
      top: "#{clickY / screenScale}px"
      left: "#{clickX / screenScale}px")

    $('textarea').focus().autoGrow()
      .on 'blur', (event) -> $(this).parent().remove()
      .on 'keyup', (event) ->
        if isImage($(this).val())
          imageEl =
            "<article class='image add-image'>
              <div class='card image'>
                <img src='#{$(this).val()}'>
                <div class='background'></div>
              </div>
              <div class='card text'>
                <textarea name='caption' placeholder='Add a caption'></textarea>
                <div class='background'></div>
              </div>
              <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
              </div>
            </article>"
          $('.content').append(imageEl)
          $('.add-image').css(
            scale: 1/screenScale
            "transform-origin": "top left"
            'z-index': window.maxZ
            top: "#{clickY / screenScale}px"
            left: "#{clickX / screenScale}px")
          $(this).remove()
          $('textarea').focus()
            .on 'blur', (event) -> emitElement(clickX, clickY, screenScale)
            .on 'keydown', (event) -> emitElement(clickX, clickY, screenScale) if event.keyCode is 13

        else if event.keyCode is 13 and not event.shiftKey # press enter (not shift + enter)
          emitElement(clickX, clickY, screenScale)

