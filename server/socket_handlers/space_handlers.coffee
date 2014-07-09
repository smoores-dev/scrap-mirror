db = require '../../models'
errorHandler = require '../errorHandler'

module.exports =
  
  # create a new space and save it to the db
  newSpace : (socket, data) ->
    name = data.name
    db.Space.create( { name } ).error (err) ->
      return errorHandler err if err?
    

  # reorder the columns in a space
  reoderSpace : (socket, data) ->
    spaceId = data.spaceId
    columnSorting = data.columnSorting

    # first find the space
    db.Space.find(where: { spaceId } ).complete (err, space) ->
      return errorHandler err if err?
      # update the columns
      space.updateAttributes( { columnSorting } ).complete (err) ->
        return errorHandler err if err?