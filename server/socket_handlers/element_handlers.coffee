db = require '../../models'
async = require 'async'
errorHandler = require '../errorHandler'

module.exports =

  # create a new element and save it to db
  newElement : (socket, data) ->
    columnId = data.columnId
    contentType = data.contentType
    content = data.content

      # find the associated column first
    db.Column.find(where: { columnId } ).complete (err, column) ->
      return errorHandler err if err?
      # once we have it, create the element
      db.Element.create({ contentType, content }).complete (err, element) ->
        return errorHandler err if err?
        element.setColumn(column). complete (err) -> 
          return errorHandler err if err?


  # delete the element
  removeElement : (socket, data, callback) ->
    elementId = data.elementId
    # find the element to be deleted
    db.Element.find(where: { elementId } ).complete (err, element) ->
      return errorHandler err if err?
      # destroy that shit!
      element.destroy().error (err) ->
        return errorHandler err if err?

  # moves an element from one column to another
  moveElement : (socket, data, callback) ->
    oldColumnId = data.oldColumnId
    newColumnId = data.newColumnId
    newIndex = data.newIndex
    elementId = data.elementId
   
    # find the old column first
    db.Column.find(where: { columnId: oldColumnId } ).complete (err, column) ->
      return errorHandler err if err?
      # now find the new column
      db.Column.find(where: { columnId: newColumnId } ).complete (err, column) ->
        return errorHandler err if err?
        # the fuck do we do now???? TODO TODO TODO