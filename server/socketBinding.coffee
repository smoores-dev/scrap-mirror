sio = require('socket.io')
spaceHandlers = require './socket_handlers/space_handlers'
columnHandlers = require './socket_handlers/column_handlers'
elementHandlers = require './socket_handlers/element_handlers'
userSpaceHandlers = require './socket_handlers/user_space_handlers'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    console.log url.parse(socket.handshake.headers.referer, true).query.id

    socket.join(''+id)

    socket.on 'newSpace',     (data) -> spaceHandlers.newSpace sio, socket, data
    socket.on 'reorderSpace', (data) -> spaceHandlers.reorderSpace sio, socket, data

    socket.on 'addUserToSpace',      (data) -> userSpaceHandlers.addUserToSpace sio, socket, data
    socket.on 'removeUserFromSpace', (data) -> userSpaceHandlers.removeUserFromSpace sio, socket, data

    socket.on 'newColumn',     (data) -> columnHandlers.newColumn sio, socket, data
    socket.on 'reorderColumn', (data) -> columnHandlers.reorderColumn sio, socket, data

    socket.on 'newElement',    (data) -> elementHandlers.newElement sio, socket, data
    socket.on 'removeElement', (data) -> elementHandlers.removeElement sio, socket, data
    socket.on 'moveElement',   (data) -> elementHandlers.moveElement sio, socket, data

    socket.on 'disconnect', ->
      socket.leave(''+id)
      console.log 'Client Disconnected.'
