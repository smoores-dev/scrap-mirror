db = require '../../models'

module.exports =
  
  # create a new space and save it to the db
  newSpace : (socket, data, callback) ->
    name = data.name
    db.Space.create( { name } ).error((err) ->
      callback err if err?)
    

  # reorder the columns in a space
  reoderSpace : (socket, data, callback) ->
    spaceId = data.spaceId
    columnSorting = data.columnSorting

    # first find the space
    db.Space.find(where: { spaceId } ).success((space) ->

      # update the columns
      space.updateAttributes( { columnSorting } ).error (err) ->
        callback err if err?

    ).error (err) -> # from space.find
      callback err if err?