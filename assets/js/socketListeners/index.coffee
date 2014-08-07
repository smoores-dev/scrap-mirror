$ ->  

  socket = io.connect()
  
  socket.on 'newSpace', (data) ->
    space = data.space
    spaceKey = space.spaceKey

    # redirect to new page
    window.location.href = "/s/" + spaceKey

  socket.on 'updateSpace', (data) ->
    name = data.name

    $('h1').text(name)
    document.title = name

  socket.on 'newElement', (data) ->
    element = data.element
    content = element.content
    contentType = element.contentType
    caption = element.caption
    thumbnail = element.thumbnail

    id = element.id
    x = element.x
    y = element.y
    z = element.z
    scale = element.scale

    if contentType == "image"
      if not caption? or caption is ''
        contentDiv =
          "<div class='card image'>
            <img src=#{content}>
            <div class='background'></div>
            <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
            </div>
          </div>"
        captionDiv = ''
      else
        contentDiv =
          "<div class='card image'>
            <img src=#{content}>
            <div class='background'></div>
            <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
            </div>
          </div>"
        captionDiv =
          "<div class='card text caption'>
            <p>#{caption}</p>
            <div class='background'></div>
            <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
            </div>
          <div class='background'></div></div>"

    else if contentType == 'website'
      contentDiv =
        "<div class='card image'>
          <img src=#{thumbnail}>
          <div class='background'></div>
          <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
          </div>
        </div>"
      captionDiv = ''
    else
      contentDiv =
        "<div class='card text'>
          <p>#{content}</p>
          <div class='background'></div>
          <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
          </div>
        </div>"
      captionDiv = ''
    
    newArticle =
      "<article class='#{contentType}' id='#{id}' style='top:#{y}px;left:#{x}px;z-index:#{z};'>
        #{contentDiv}
        #{captionDiv}
      </article>"


    $('.content').append(newArticle)
    $("\##{id}").draggable(draggableOptions socket)
      .css( '-webkit-transform': "scale(#{scale})","-webkit-transform-origin": "top left")
    $('.ui-resizable-handle', "\##{id}").on 'mousedown', resize socket
    cluster()
    if contentType == 'website'
      $("\##{id}").data 'content', content
      $("\##{id}").on 'dblclick', websiteOption



  socket.on 'removeElement', (data) ->
    id = data.element.id
    $("\##{id}").remove()

  socket.on 'updateElement', (data) ->
    id = data.element.id
    x = data.element.x + totalDelta.x
    y = data.element.y + totalDelta.y
    z = data.element.z
    window.maxZ +=1
    scale = data.element.scale

    if scale < window.minScale
      window.minScale = scale

    $("\##{id}").zIndex(window.maxZ)
    $("\##{id}").animate({ top: y, left: x }, cluster)
    $("\##{id}").transition { scale }
    
