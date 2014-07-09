db = require '../../models'

module.exports =
  addUserToSpace : (socket, data) ->
    spaceId = data.spaceId
    userId = data.userId
    # doesn't exist yet

  removeUserFromSpace : (socket, data) ->
    spaceId = data.spaceId
    userId = data.userId
    # doesn't exist yet