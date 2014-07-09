db = require '../../models'

module.exports = 
  # create a new space and save it to the db
  newSpace : (socket, data) ->
    name = data.name
    db.Space.create(name).error((callback) -> 
        callback err if err?)
    
  # reorder the columns in a space
  reoderSpace : (socket, data) ->
    spaceId = data.spaceId
    columns= data.columns
    db.Space.find(where: { spaceId } ).success((space) -> 
      space.updateAttributes(columns, ['columns']).error((callback) -> 
        callback err if err?)
      ).error((callback) -> 
        callback err if err?)