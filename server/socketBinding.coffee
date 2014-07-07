sio = require('socket.io')
spaceHandlers = require './socket_handlers/space_handlers'
columnHandlers = require './socket_handlers/column_handlers'
elementHandlers = require './socket_handlers/element_handlers'
userSpaceHandlers = require './socket_handlers/user_space_handlers'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    socket.on 'newSpace',     (data) -> spaceHandlers.newSpace socket, data
    socket.on 'reorderSpace', (data) -> spaceHandlers.reorderSpace socket, data

    socket.on 'addUserToSpace',      (data) -> userSpaceHandlers.addUserToSpace socket, data
    socket.on 'removeUserFromSpace', (data) -> userSpaceHandlers.removeUserFromSpace socket, data

    socket.on 'newColumn',     (data) -> columnHandlers.newColumn socket, data
    socket.on 'reorderColumn', (data) -> columnHandlers.reorderColumn socket, data

    socket.on 'newElement',    (data) -> elementHandlers.newElement socket, data
    socket.on 'removeElement', (data) -> elementHandlers.removeElement socket, data
    socket.on 'moveElement',   (data) -> elementHandlers.moveElement socket, data

    socket.on 'disconnect', ->
      console.log 'Client Disconnected.'
