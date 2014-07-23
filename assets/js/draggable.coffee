$ ->
  socket = io.connect()

  $('article.text').draggable(
    start: ->
      highestZ += 1
      z = highestZ
      $(this).zIndex z

    stop: ->
      xString = $(this).css('left')
      x = Math.floor(xString.slice(0,xString.length - 2))
      yString = $(this).css('top')
      y = Math.floor(yString.slice(0,yString.length - 2))
      z = highestZ
      elementId = this.id
      
      console.log x, y, z
      socket.emit('updateElement', { x, y, z, elementId })
  )