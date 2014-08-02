models = require '../../models'
module.exports =
  
  # create a new space and save it to the db
  newSpace : (sio, socket, data, callback) ->
    name = data.name
    spaceKey = @generateUUID()
    
    models.Space.create( { name, spaceKey } ).complete (err, space) ->
      return callback err if err?
      socket.emit 'newSpace', { space }
      callback()

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text