sio = require('socket.io')
url = require('url')
spaceController = require './socketControllers/spaceController'
columnController = require './socketControllers/columnController'
elementController = require './socketControllers/elementController'
errorHandler = require './errorHandler'

module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    id = url.parse(socket.handshake.headers.referer, true).query.id
    socket.join(''+id)
    console.log 'joined', id
    socket.on 'newSpace',     (data) -> spaceController.newSpace sio, socket, data, errorHandler
    socket.on 'reorderSpace', (data) -> spaceController.reorderSpace sio, socket, data, errorHandler

    socket.on 'newColumn',     (data) -> columnController.newColumn sio, socket, data, errorHandler
    socket.on 'reorderColumn', (data) -> columnController.reorderColumn sio, socket, data, errorHandler

    socket.on 'newElement',    (data) -> elementController.newElement sio, socket, data, errorHandler
    socket.on 'removeElement', (data) -> elementController.removeElement sio, socket, data, errorHandler
    socket.on 'moveElement',   (data) -> elementController.moveElement sio, socket, data, errorHandler

    socket.on 'disconnect', ->
      socket.leave(''+id)
      console.log 'Client Disconnected.'
