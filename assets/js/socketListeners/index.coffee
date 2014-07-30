$ ->  

  socket = io.connect()
  
  socket.on 'newSpace', (data) ->
    space = data.space
    spaceId = space.id

    # redirect to new page
    window.location.href = "/s/" + spaceId

  socket.on 'newElement', (data) ->
    element = data.element
    content = element.content
    contentType = element.contentType
    id = element.id
    x = element.x
    y = element.y
    z = element.z
    scale = element.scale

    if contentType == "image"
      body = "<img src=#{content}>"
    else
      body = "<p>#{content}</p>"
    
    newArticle =
      "<article class='#{contentType}' id='#{id}' style='top:#{y}px;left:#{x}px;z-index:#{z};'>
          #{body}
          <div class='background'></div>
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
    scale = data.element.scale

    $("\##{id}").animate({ top: y, left: x, 'z-index': z }, cluster)
    $("\##{id}").css '-webkit-transform': "scale(#{scale})"
    
