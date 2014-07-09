db = require '../../models'
errorHandler = require '../errorHandler'

module.exports =

	# create a new column and save it to db
  newColumn : (socket, data, callback) ->
    spaceId = data.spaceId
    contentType = data.contentType
    content = data.content

    # find the associated space first
    db.Space.find(where: { spaceId } ).complete (err, space) ->
      return errorHandler err if err?
      # once we have it, create the column
      db.Column.create(spaceId).complete (err, column) ->
        return errorHandler err if err?
        column.setSpace(space).complete (err) ->
          return errorHandler err if err?
          # now create the first element in it
          db.Element.create( { contentType, content } ).complete (err, element) ->
            return errorHandler err if err?
            element.setColumn(column).complete (err) ->
              return errorHandler err if err?

  # reorder the elements in the column
  reorderColumn : (socket, data, callback) ->
    columnId = data.columnId
    elementSorting = data.elementSorting

    # first find the column
    db.Column.find(where: { columnId } ).complete (err, column) ->
      return errorHandler err if err?
      # update the columns
      column.updateAttributes( { elementSorting } ).error (err) ->
        return errorHandler err if err?