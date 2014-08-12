sio = require('socket.io')
url = require('url')
spaceController = require './socketControllers/spaceController'
elementController = require './socketControllers/elementController'
errorHandler = require './errorHandler'
validator = require 'validator'

clean = (data) ->
  for k, v of data
    data[k] = (validator.escape v).replace /\n/g, '</p><p>'
  data

module.exports = (io)->
  io.sockets.on 'connection', (socket) ->

    spaceKey = url.parse(socket.handshake.headers.referer, true).path.split('/')[2]
    socket.join spaceKey
    console.log 'joined', spaceKey

    socket.on 'newElement',   (data) -> elementController.newElement io, socket, clean(data), spaceKey, errorHandler
    socket.on 'removeElement',(data) -> elementController.removeElement io, socket, clean(data), spaceKey, errorHandler
    socket.on 'updateElement',(data) -> elementController.updateElement io, socket, clean(data), spaceKey, errorHandler
    socket.on 'updateSpace',(data) -> spaceController.updateSpace io, socket, clean(data), spaceKey, errorHandler
    socket.on 'addUserToSpace',(data) -> spaceController.addUserToSpace io, socket, clean(data), spaceKey, errorHandler

    socket.on 'disconnect', ->
      socket.leave(spaceKey)
      console.log 'Client Disconnected.'
