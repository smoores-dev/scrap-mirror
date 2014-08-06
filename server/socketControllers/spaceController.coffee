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
  updateSpace : (sio, socket, data, spaceKey, callback) ->
    name = data.name

    query = "UPDATE \"Spaces\" SET"
    query += " \"name\"=:name"
    query += " WHERE \"spaceKey\"=:spaceKey RETURNING *"

    #new space to be filled in by update
    space = models.Space.build()
    
    models.sequelize.query(query, space, null, { name, spaceKey }).complete (err, res) ->
      return callback err if err?
      sio.to("#{spaceKey}").emit 'updateSpace', { name: res.name }
      callback()

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text