module.exports =
  addUserToSpace : (socket, data) ->
    spaceId = data.spaceId
    userId = data.userId
    
  removeUserFromSpace : (socket, data) ->
    spaceId = data.spaceId
    userId = data.userId