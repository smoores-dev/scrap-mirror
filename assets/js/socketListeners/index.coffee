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

    newArticle =
      "<article class='#{contentType}' id='#{id}' style='top:#{y}px;left:#{x}px;z-index:#{z};'>
          <p>#{content}</p>
          <div class='background'></div>
        </article>"

    $('.content').append(newArticle)
    $("\##{id}").draggable(draggableOptions socket)

  socket.on 'removeElement', (data) ->
    element = element

  socket.on 'updateElement', (data) ->
    id = data.element.id
    x = data.element.x + totalDelta.x
    y = data.element.y + totalDelta.y
    z = data.element.z

    $("\##{id}").animate( top: y, left: x, 'z-index': z )
