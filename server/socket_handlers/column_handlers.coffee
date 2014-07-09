db = require '../../models'

module.exports = 

	# create a new column and save it to db
  newColumn : (socket, data) ->
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
	        element.setColumn(column)
	        ).error((callback) -> 
	          callback err if err?)

        ).error((callback) -> # from column.create
          callback err if err?)

      ).error((callback) -> # from space.find
        callback err if err?)


  # reorder the elements in the column
  reorderColumn : (socket, data) ->
    columnId = data.columnId
    elementSorting = data.elementSorting

    # first find the column
    db.Column.find(where: { columnId } ).success((column) -> 

      # update the columns
      column.updateAttributes(elementSorting, ['elementSorting']).error((callback) -> 
        callback err if err?)

      ).error((callback) -> # from column.find
        callback err if err?)