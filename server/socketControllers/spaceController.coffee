models = require '../../models'
module.exports =
  
  # create a new space and save it to the db
  newSpace : (sio, socket, data, spaceId, callback) ->
    name = data.name
    models.Space.create( { name } ).complete (err, space) ->
      return callback err if err?
      socket.emit 'newSpace', { space }
      callback()