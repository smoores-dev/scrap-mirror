module.exports = 
  newSpace : (socket, data) ->
    space = data.space
    creatorId = data.creatorId
    
  reoderSpace : (socket, data) ->
    spaceId = data.spaceId
    columns= data.columns