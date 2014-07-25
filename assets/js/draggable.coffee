$ ->

  socket = io.connect()

  $('article').draggable(draggableOptions socket)
