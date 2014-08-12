$ ->
  # adding a new element
  emitElement = (x, y, scale, content, contentType) ->
    caption = $('textarea[name=caption]').val()
    caption = if caption? then caption.slice(0, -1) else caption # remove last newline 
    window.maxZ += 1
    z = window.maxZ

    socket.emit 'newElement', { contentType, content, x, y, z, scale, caption }

    $('.add-element').remove()
    $('.add-image').remove()
    $('.add-website').remove()

  isImage = (url) ->
    url.match(/\.(jpeg|jpg|gif|png)$/)?

  isWebsite = (url) ->
    expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
    !!url.match expression

  # adds caption and element to DOM
  addCaption = (x, y, scale, contentType, content, innerHTML) ->
    captionForm = 
      "<div class='card text'>
        <textarea name='caption' placeholder='Add a caption'></textarea>
        <div class='background'></div>
      </div>
      <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
      </div>"

    element =
      "<article class='#{contentType} add-#{contentType}'>
        <div class='card #{contentType}'>
          #{innerHTML content}
          <div class='background'></div>
        </div>
        #{captionForm}
      </article>"

    $('.content').append element
    $(".add-#{contentType}").css(
      scale: scale
      "transform-origin": "top left"
      'z-index': window.maxZ
      top: "#{y}px"
      left: "#{x}px")
    $(this).remove()
    $('textarea').focus()
      .on 'blur', (event) -> emitElement x, y, scale, content, contentType
      .on 'keyup', (event) -> emitElement x, y, scale, content, contentType if event.keyCode is 13 and not event.shiftKey

  # on double-click, append new element form, then process the new element if one is submitted
  $(window).on 'dblclick', (event) ->
    screenScale = $('.content').css('scale')
    x = Math.floor((event.clientX - $('.content').offset().left) / screenScale)
    y = Math.floor((event.clientY - $('.content').offset().top) / screenScale)

    elementForm =
      "<article class='add-element'>
        <div class='card text'>
          <textarea name='content' placeholder='Add something new'></textarea>
        </div>
      </article>"

    # add the new element form
    $('.content').append elementForm
    $('.add-element').css(
      scale: 1/screenScale
      "transform-origin": "top left"
      'z-index': "#{window.maxZ + 1}"
      top: "#{y}px"
      left: "#{x}px")

    $('textarea').focus().autoGrow()
      .on 'blur', (event) -> $(this).parent().remove()
      .on 'keyup', (event) ->

        # on paste of image, submit without hitting enter
        if isImage $(this).val() 
          content = $(this).val()
          innerHTML = (content) -> "<img src='#{content}'>"
          addCaption x, y, 1/screenScale, 'image', content, innerHTML

        # on enter (not shift + enter), submit either website or text
        else if event.keyCode is 13 and not event.shiftKey
          if isWebsite $(this).val() 
            content = $(this).val().slice(0, -1)
            innerHTML = (content) ->
              "<p><a href='#{content}'>#{content}</a></p>
               <p><code>Loading thumbnail...</code></p>"
            addCaption x, y, 1/screenScale, 'website', content, innerHTML

          else # this is text
            content = $('textarea[name=content]').val().slice(0, -1)
            emitElement x, y, 1/screenScale, content, 'text'
