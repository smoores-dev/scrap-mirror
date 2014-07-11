db = require '../../models'

module.exports =
  addUserToSpace : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    userId = data.userId
    # doesn't exist yet

  removeUserFromSpace : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    userId = data.userId
    # doesn't exist yet