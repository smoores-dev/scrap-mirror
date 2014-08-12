models = require '../../models'
module.exports =
  
  # update the space name and save it to the db
  updateSpace : (sio, socket, data, spaceKey, callback) ->
    name = data.name

    query = "UPDATE \"Spaces\" SET"
    query += " \"name\"=:name"
    query += " WHERE \"spaceKey\"=:spaceKey RETURNING *"

    # new space to be filled in by update
    space = models.Space.build()
    
    models.sequelize.query(query, space, null, { name, spaceKey }).complete (err, res) ->
      return callback err if err?
      sio.to(spaceKey).emit 'updateSpace', { name: res.name }
      callback()

  addUserToSpace : (sio, socket, data, spaceKey, callback) ->
    email = data.email

    models.Space.find( where: { spaceKey }).complete (err, space) ->
      return callback err if err?
      models.User.find( where: { email }).complete (err, user) ->
        return callback err if err?
        if user?
          console.log "USER", user
          space.addUser(user).complete (err) ->
            return callback err if err?
            sio.to(spaceKey).emit 'addUserToSpace', { name: user.name }
            callback()
        else
          sio.to(spaceKey).emit 'addUserToSpace', null

