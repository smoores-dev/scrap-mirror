db = require '../../models'
async = require 'async'

module.exports =
	# create a new column and save it to db
  newColumn : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    contentType = data.contentType
    content = data.content

    db.Column.create(spaceId).complete (err, column) ->
      return callback err if err?
      column.setSpace(space).complete (err) ->
        return callback err if err?
        db.Element.create( { contentType, content , ColumnId : column.id } ).complete (err, element) ->
          return callback err if err?
          sio.to("#{spaceId}").emit 'newColumn', { column }


  # reorder the elements in the column
  reorderColumn : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    columnId = data.columnId
    elementSorting = data.elementSorting

    # first find the column
    db.Column.find(where: { columnId } ).complete (err, column) ->
      return callback err if err?
      # update the columns
      column.updateAttributes( { elementSorting } ).error (err) ->
        return callback err if err?
        sio.to("#{spaceId}").emit 'reorderColumn', { elementSorting }