$ ->

  socket = io.connect()

  # adding a new space
  $('.add-space').submit (event) ->
    event.preventDefault()
    name = $('input[name=name]', this).val()
    socket.emit 'newSpace', { name }

  # updating a space name
  $('.name').on 'dblclick', (event) ->
    editing = !!$('form', this).length
    event.stopPropagation()
    if not editing
      parent = $(this).parent()
      oldName = $(this).html()
      $(this).text('')

      formEl = "<form><input type='text' name='name' value='#{oldName}'><input style='visibility:hidden' type='submit'></form>"
      $(this).append(formEl)
      $('input[name="name"]').focus()
        .on 'blur', (event) ->
          $(this).parent().remove()
          $('.name').text(oldName)
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

  # adding a new element
  emitElement = (clickX, clickY, screenScale, content, contentType) ->
    text = $('textarea[name=content]').val()

    if text?
      content = text.slice(0, -1)
      contentType = 'text'
    else if $('img','.add-image').attr('src')?
      content = $('img','.add-image').attr('src')
      contentType = 'image'
    else 
      content = $('a','.add-website').attr('href').slice(0, -1)
      contentType = 'website'

    caption = $('textarea[name=caption]').val()
    caption = if caption? then caption.slice(0, -1) else caption # remove last newline 
    window.maxZ += 1
    x = Math.floor(clickX / screenScale)
    y = Math.floor(clickY / screenScale)
    z = window.maxZ
    scale = 1/screenScale

    socket.emit 'newElement', { contentType, content, x, y, z, scale, caption }

    $('.add-element').remove()
    $('.add-image').remove()
    $('.add-website').remove()

  isImage = (url) ->
    not url.match(/\.(jpeg|jpg|gif|png)$/)?

  isWebsite = (url) ->
    expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
    !!url.match expression

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

    $('.content').append elementForm
    $('.add-element').css(
      scale: 1/screenScale
      "transform-origin": "top left"
      'z-index': "#{window.maxZ + 1}"
      top: "#{clickY / screenScale}px"
      left: "#{clickX / screenScale}px")

    $('textarea').focus().autoGrow()
      .on 'blur', (event) -> $(this).parent().remove()
      .on 'keyup', (event) ->
        # on paste of image 
        if isImage $(this).val() 
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
          $('.content').append imageEl
          $('.add-image').css(
            scale: 1/screenScale
            "transform-origin": "top left"
            'z-index': window.maxZ
            top: "#{clickY / screenScale}px"
            left: "#{clickX / screenScale}px")
          $(this).remove()
          $('textarea').focus()
            .on 'blur', (event) -> emitElement clickX, clickY, screenScale
            .on 'keyup', (event) -> emitElement clickX, clickY, screenScale if event.keyCode is 13 and not event.shiftKey

        else if event.keyCode is 13 and not event.shiftKey # press enter (not shift + enter)
          if isWebsite $(this).val() 
            siteEl =
              "<article class='website add-website'>
                <div class='card website'>
                  <p><a href='#{$(this).val()}'>#{$(this).val()}</a></p>
                  <p><code>Loading thumbnail...</code></p>
                  <div class='background'></div>
                </div>
                <div class='card text'>
                  <textarea name='caption' placeholder='Add a caption'></textarea>
                  <div class='background'></div>
                </div>
                <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
                </div>
              </article>"
            $('.content').append siteEl
            $('.add-website').css(
              scale: 1/screenScale
              "transform-origin": "top left"
              'z-index': window.maxZ
              top: "#{clickY / screenScale}px"
              left: "#{clickX / screenScale}px")
            $(this).remove()
            $('textarea').focus()
              .on 'blur', (event) -> emitElement clickX, clickY, screenScale 
              .on 'keyup', (event) -> emitElement clickX, clickY, screenScale if event.keyCode is 13 and not event.shiftKey
          else
            emitElement clickX, clickY, screenScale

