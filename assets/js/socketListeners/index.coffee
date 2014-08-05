$ ->  

  socket = io.connect()
  
  socket.on 'newSpace', (data) ->
    space = data.space
    spaceKey = space.spaceKey

    # redirect to new page
    window.location.href = "/s/" + spaceKey

  socket.on 'updateName', (data) ->
    name = data.name
    $('h1').text(name)
    document.title = name

  socket.on 'newElement', (data) ->
    element = data.element
    content = element.content
    contentType = element.contentType
    caption = element.caption
    id = element.id
    x = element.x
    y = element.y
    z = element.z
    scale = element.scale

    if contentType == "image"
      body = "<img src=#{content}>"
    else
      body = "<p>#{content}</p>"

    if caption?
      captionDiv = "<div class='card'><p>#{caption}</p><div class='background'></div></div>"
    else
      captionDiv = ""
    
    newArticle =
      "<article class='#{contentType}' id='#{id}' style='top:#{y}px;left:#{x}px;z-index:#{z};'>
        <div class='card'>
          #{body}
          <div class='background'></div>
        </div>
        #{captionDiv}
        <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-grip-diagonal-se'>
        </div>
      </article>"


    $('.content').append(newArticle)
    $("\##{id}").draggable(draggableOptions socket)
      .css( '-webkit-transform': "scale(#{scale})","-webkit-transform-origin": "top left")
    $('.ui-resizable-handle', "\##{id}").on 'mousedown', resize socket

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

    $("\##{id}").zIndex(window.maxZ)
    $("\##{id}").animate({ top: y, left: x }, cluster)
    $("\##{id}").transition { scale }
    
