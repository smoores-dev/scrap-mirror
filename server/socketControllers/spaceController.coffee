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

  # update the space name and save it to the db
  updateName : (sio, socket, data, spaceKey, callback) ->
    name = data.name
    
    models.Space.find(where: { spaceKey }).complete (err, space) =>
      return callback err if err?
      return callback() if not space? 
      space.updateAttributes({ name }).success () =>
        sio.to("#{spaceKey}").emit 'updateName', { name }
        callback()

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text