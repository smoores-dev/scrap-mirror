$ ->

  socket = io.connect()

  $('article.text').draggable(
    stop: ->
      xString = $(this).css('left')
      x = xString.slice(0,xString.length - 2)
      yString = $(this).css('top')
      y = yString.slice(0,yString.length - 2)
      elementId = this.id
      console.log elementId
      socket.emit('updateElement', { x, y, elementId })
  )