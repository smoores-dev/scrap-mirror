db = require '../../models'

module.exports =

	# create a new column and save it to db
  newColumn : (socket, data, callback) ->
    spaceId = data.spaceId
    contentType = data.contentType
    content = data.content

    # find the associated space first
    db.Space.find(where: { columnId } ).success((space) ->

      # once we have it, create the column
      db.Column.create(contentType, content).success((column) ->
        element.setSpace(space)

        # now create the first element in it
        db.Element.create(contentType, content).success((element) ->
          element.setColumn column
        ).error (err) ->
          callback err if err?

      ).error (err) -> # from column.create
        callback err if err?

    ).error (err) -> # from space.find
      callback err if err?


  # reorder the elements in the column
  reorderColumn : (socket, data, callback) ->
    columnId = data.columnId
    elementSorting = data.elementSorting

    # first find the column
    db.Column.find(where: { columnId } ).success((column) ->

      # update the columns
      column.updateAttributes( { elementSorting } ).error (err) ->
        callback err if err?

    ).error (err) -> # from column.find
      callback err if err?