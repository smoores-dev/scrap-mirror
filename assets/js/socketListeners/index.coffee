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

    if not caption? or caption is ''
      captionDiv = ''
    else
      captionDiv =
        "<div class='card text caption'>
          <p>#{caption}</p>
          <div class='background'></div>
          <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
          </div>
        <div class='background'></div></div>"

    if contentType is "image"
      contentDiv =
        "<div class='card image'>
          <img src=#{content}>
          <div class='background'></div>
          <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
          </div>
        </div>"

    else if contentType is 'website'
      if data.loaded
        $("\##{id}").remove()
        contentDiv =
          "<div class='card website'>
            <a href='#{content}' target='_blank'><img src=#{thumbnail}></a>
            <div class='background'></div>
            <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
            </div>
          </div>"
      else
        contentDiv =
          "<div class='card website'>
            <p><a href=#{content} target='_blank'>#{content}</a></p>
            <p><code>Loading thumbnail...</code></p>
            <div class='background'></div>
            <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
            </div>
          </div>"

    else #type == text
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
      .css( '-webkit-transform': "salec(#{scale})","-webkit-transform-origin": "top left")
    $('.ui-resizable-handle', "\##{id}").on 'mousedown', resize socket
    cluster()
<<<<<<< HEAD
=======
    if contentType == 'website'
      $("\##{id}").data 'content', content
      $("\##{id}").on 'dblclick', websiteOption

    updateGlobals element
>>>>>>> 0bf34c19d5f416ef1d621ffe942f400495900051

  socket.on 'removeElement', (data) ->
    id = data.element.id
    $("\##{id}").remove()

  socket.on 'updateElement', (data) ->
    element = data.element
    id = element.id
    x = element.x + totalDelta.x
    y = element.y + totalDelta.y
    z = element.z
    scale = element.scale

    window.maxZ +=1
    updateGlobals element

    $("\##{id}").zIndex(window.maxZ)
    $("\##{id}").data 'oldZ', window.maxZ
    $("\##{id}").animate({ top: y, left: x }, cluster)
    $("\##{id}").transition { scale }


  updateGlobals = (element) ->
    if (element.x + 300 * element.scale) > window.maxX
      window.maxX = (element.x + 300 * element.scale)

    if element.x < window.minX
      window.minX = element.x

    if element.y > window.maxY
      window.maxY = element.y

    if element.y < window.minY
      window.minY = element.y

    if element.scale < window.minScale
      window.minScale = element.scale
    
