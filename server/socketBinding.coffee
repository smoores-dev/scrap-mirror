sio = require('socket.io')
module.exports = (server)->
  io = sio.listen server
  io.sockets.on 'connection', (socket) ->

    console.log 'Client Connected'

    socket.on 'disconnect', ->
      console.log 'Client Disconnected.'
