sio = require('socket.io')
url = require('url')
spaceController = require './socketControllers/spaceController'
columnController = require './socketControllers/columnController'
elementController = require './socketControllers/elementController'
errorHandler = require './errorHandler'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    spaceId = url.parse(socket.handshake.headers.referer, true).path.split('/')[1]
    socket.join spaceId
    console.log 'joined', spaceId

    socket.on 'newSpace',     (data) -> spaceController.newSpace io, socket, data, spaceId, errorHandler
    socket.on 'reorderSpace', (data) -> spaceController.reorderSpace io, socket, data, spaceId, errorHandler

    socket.on 'newColumn',     (data) -> columnController.newColumn io, socket, data, spaceId, errorHandler
    socket.on 'reorderColumn', (data) -> columnController.reorderColumn io, socket, data, spaceId, errorHandler

    socket.on 'newElement',    (data) -> elementController.newElement io, socket, data, spaceId, errorHandler
    socket.on 'removeElement', (data) -> elementController.removeElement io, socket, data, spaceId, errorHandler
    socket.on 'moveElement',   (data) -> elementController.moveElement io, socket, data, spaceId, errorHandler

    socket.on 'disconnect', ->
      socket.leave(''+spaceId)
      console.log 'Client Disconnected.'
