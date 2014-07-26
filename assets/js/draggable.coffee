$ ->

  socket = io.connect()

  $('article.text').draggable(draggableOptions socket)
