sio = require('socket.io')
url = require('url')
spaceHandlers = require './socket_handlers/space_handlers'
columnHandlers = require './socket_handlers/column_handlers'
elementHandlers = require './socket_handlers/element_handlers'
userSpaceHandlers = require './socket_handlers/user_space_handlers'
errorHandler = require './errorHandler'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    id = url.parse(socket.handshake.headers.referer, true).query.id
    socket.join(''+id)
    console.log 'joined', id
    socket.on 'newSpace',     (data) -> spaceHandlers.newSpace sio, socket, data, errorHandler
    socket.on 'reorderSpace', (data) -> spaceHandlers.reorderSpace sio, socket, data, errorHandler

    socket.on 'addUserToSpace',      (data) -> userSpaceHandlers.addUserToSpace sio, socket, data, errorHandler
    socket.on 'removeUserFromSpace', (data) -> userSpaceHandlers.removeUserFromSpace sio, socket, data, errorHandler

    socket.on 'newColumn',     (data) -> columnHandlers.newColumn sio, socket, data, errorHandler
    socket.on 'reorderColumn', (data) -> columnHandlers.reorderColumn sio, socket, data, errorHandler

    socket.on 'newElement',    (data) -> elementHandlers.newElement sio, socket, data, errorHandler
    socket.on 'removeElement', (data) -> elementHandlers.removeElement sio, socket, data, errorHandler
    socket.on 'moveElement',   (data) -> elementHandlers.moveElement sio, socket, data, errorHandler

    socket.on 'disconnect', ->
      socket.leave(''+id)
      console.log 'Client Disconnected.'
