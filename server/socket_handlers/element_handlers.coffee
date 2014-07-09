db = require '../../models'
async = require 'async'

module.exports =

  # create a new element and save it to db
  newElement : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    columnId = data.columnId
    contentType = data.contentType
    content = data.content

      # find the associated column first
    db.Column.find(where: { columnId } ).complete (err, column) ->
      return callback err if err?
      # once we have it, create the element
      db.Element.create({ contentType, content }).complete (err, element) ->
        return callback err if err?
        element.setColumn(column).complete (err) -> 
          return callback err if err?
          sio.to("#{spaceId}").emit 'newElement', { columnId, element }

  # delete the element
  removeElement : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    elementId = data.elementId
    db.Element.find(where: { elementId } ).complete (err, element) ->
      return callback err if err?
      element.destroy().error (err) ->
        return callback err if err?
        sio.to("#{spaceId}").emit 'removeElement', { element }

  # moves an element from one column to another
  moveElement : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    oldColumnId = data.oldColumnId
    newColumnId = data.newColumnId
    newIndex = data.newIndex
    elementId = data.elementId
   
    # find the old column first
    db.Column.find(where: { columnId: oldColumnId } ).complete (err, column) ->
      return callback err if err?
      # now find the new column
      db.Column.find(where: { columnId: newColumnId } ).complete (err, column) ->
        return callback err if err?
        # the fuck do we do now???? TODO TODO TODO