sio = require 'socket.io'
url = require 'url'
spaceHandlers     = require './socket_handlers/space_handlers'
columnHandlers    = require './socket_handlers/column_handlers'
elementHandlers   = require './socket_handlers/element_handlers'
userSpaceHandlers = require './socket_handlers/user_space_handlers'
errorHandler      = require './errorHandler'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    spaceId = url.parse(socket.handshake.headers.referer, true).path.split('/')[1]
    socket.join spaceId
    console.log 'joined', spaceId

    socket.on 'newSpace',     (data) -> spaceHandlers.newSpace sio, socket, data, spaceId, errorHandler
    socket.on 'reorderSpace', (data) -> spaceHandlers.reorderSpace sio, socket, data, spaceId, errorHandler

    socket.on 'addUserToSpace',      (data) -> userSpaceHandlers.addUserToSpace sio, socket, data, spaceId, errorHandler
    socket.on 'removeUserFromSpace', (data) -> userSpaceHandlers.removeUserFromSpace sio, socket, data, spaceId, errorHandler

    socket.on 'newColumn',     (data) -> columnHandlers.newColumn sio, socket, data, spaceId, errorHandler
    socket.on 'reorderColumn', (data) -> columnHandlers.reorderColumn sio, socket, data, spaceId, errorHandler

    socket.on 'newElement',    (data) -> elementHandlers.newElement sio, socket, data, spaceId, errorHandler
    socket.on 'removeElement', (data) -> elementHandlers.removeElement sio, socket, data, spaceId, errorHandler
    socket.on 'moveElement',   (data) -> elementHandlers.moveElement sio, socket, data, spaceId, errorHandler

    socket.on 'disconnect', ->
      socket.leave spaceId
      console.log 'Client Disconnected.'
