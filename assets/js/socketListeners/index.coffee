$ ->  

  socket = io.connect()
  
  socket.on 'newSpace', (data) ->
    space = data.space

  socket.on 'newElement', (data) ->
    element = data.element
    content = element.content
    contentType = element.contentType
    id = element.id
    x = element.x
    y = element.y
    z = element.z
    scale = element.scale

    newArticle =
      "<article class='#{contentType}' id='#{id}' style='top:#{y}px;left:#{x}px;z-index:#{z};'>
        <div class='zoomBox'>
          <p>#{content}</p>
          <div class='background'></div>
        </div>
        <div class='ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se'>
        </div>
      </article>"

    $('.content').append(newArticle)

    $("\##{id}").draggable(draggableOptions socket)
      .css( '-webkit-transform': "scale(#{scale})","-webkit-transform-origin": "top left")
    $('.ui-resizable-handle', "\##{id}").on 'mousedown', resize socket

  socket.on 'removeElement', (data) ->
    element = element

  socket.on 'updateElement', (data) ->
    id = data.element.id
    x = data.element.x + totalDelta.x
    y = data.element.y + totalDelta.y
    z = data.element.z
    scale = data.element.scale

    $("\##{id}").animate( top: y, left: x, 'z-index': z )
    $("\##{id}").css '-webkit-transform': "scale(#{scale})"

