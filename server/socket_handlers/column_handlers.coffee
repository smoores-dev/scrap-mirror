db = require '../../models'
async = require 'async'

module.exports =
	# create a new column and save it to db
  newColumn : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    contentType = data.contentType
    content = data.content

    db.Column.create(SpaceId : spaceId).complete (err, column) ->
      return callback err if err?
      db.Element.create( { contentType, content , ColumnId : column.id } ).complete (err, element) ->
        return callback err if err?
        db.Space.find(where: { id: spaceId } ).complete (err, space) ->
          return callback err if err?
          space.columnSorting.push column.id
          space.updateAttributes( { columnSorting: space.columnSorting } ).complete (err) ->
            return callback err if err?
            sio.to("#{spaceId}").emit 'newColumn', { column }
            callback null


  # reorder the elements in the column
  reorderColumn : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    id = data.columnId
    elementSorting = data.elementSorting

    # first find the column
    db.Column.find(where: { id } ).complete (err, column) ->
      return callback err if err?
      # update the columns
      column.updateAttributes( { elementSorting } ).complete (err) ->
        return callback err if err?
        sio.to("#{spaceId}").emit 'reorderColumn', { elementSorting }
        callback null