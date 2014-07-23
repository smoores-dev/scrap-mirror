sio = require('socket.io')
url = require('url')
spaceController = require './socketControllers/spaceController'
elementController = require './socketControllers/elementController'
errorHandler = require './errorHandler'

module.exports = (io)->
  io.sockets.on 'connection', (socket) ->

    spaceId = url.parse(socket.handshake.headers.referer, true).path.split('/')[1]
    socket.join spaceId
    console.log 'joined', spaceId

    socket.on 'newSpace',     (data) -> spaceController.newSpace io, socket, data, spaceId, errorHandler
    socket.on 'newElement',   (data) -> elementController.newElement io, socket, data, spaceId, errorHandler
    socket.on 'removeElement',(data) -> elementController.removeElement io, socket, data, spaceId, errorHandler
    socket.on 'updateElement',(data) -> elementController.updateElement io, socket, data, spaceId, errorHandler

    socket.on 'disconnect', ->
      socket.leave(''+spaceId)
      console.log 'Client Disconnected.'
