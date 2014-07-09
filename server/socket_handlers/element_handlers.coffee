db = require '../../models'

module.exports =

  # create a new element and save it to db
  newElement : (socket, data, callback) ->
    columnId = data.columnId
    contentType = data.contentType
    content = data.content

    # find the associated column first
    db.Column.find(where: { columnId } ).success((column) ->

      # once we have it, create the element
      db.Element.create(contentType, content).success((element) ->
        element.setColumn column
      ).error (err) ->
        callback err if err?

    ).error (err) -> # from column.find
      callback err if err?


  # delete the element
  removeElement : (socket, data, callback) ->
    elementId = data.elementId

    # find the element to be deleted
    db.Element.find(where: { elementId } ).success((element) ->

      # destroy that shit!
      element.destroy().error (err) ->
        callback err if err?

    ).error (err) -> # from element.find
      callback err if err?


  # moves an element from one column to another
  moveElement : (socket, data, callback) ->
    oldColumnId = data.oldColumnId
    newColumnId = data.newColumnId
    newIndex = data.newIndex
    elementId = data.elementId
   
    # find the old column first
    db.Column.find(where: { columnId: oldColumnId } ).success((column) ->

      # now find the new column
      db.Column.find(where: { columnId: newColumnId } ).success((column) ->

        # the fuck do we do now???? TODO TODO TODO

      ).error (err) -> # from column.find inner
        callback err if err?

    ).error (err) -> # from column.find
      callback err if err?
