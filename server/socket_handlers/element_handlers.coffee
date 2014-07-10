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
    db.Column.find(where: { id: columnId } ).complete (err, column) ->
      return callback err if err?
      # once we have it, create the element
      db.Element.create({ contentType, content }).complete (err, element) ->
        return callback err if err?
        element.setColumn(column).complete (err) -> 
          return callback err if err?
          sio.to("#{spaceId}").emit 'newElement', { columnId, element }
          callback()

  # delete the element
  removeElement : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    id = data.elementId

    # find/delete the element
    db.Element.find(where: { id } ).complete (err, element) ->
      return callback err if err?
      columnId = element.ColumnId
      element.destroy().complete (err) ->
        return callback err if err?

        # remove the element from the column's elementSorting
        db.Column.find(where: { id: columnId }).complete (err, column) ->
          return callback err if err?
          sortingArray = column.elementSorting

          # delete the column if the deleted element was the only one
          if sortingArray.length is 1
            column.destroy().complete (err) ->
              return callback err if err?
              sio.to("#{spaceId}").emit 'removeColumn', { column }
              return callback()

          else # else just find/remove from the array
            elementIndex = sortingArray.indexOf(id)
            sortingArray.splice(elementIndex, 1)
            column.updateAttributes( { columnSorting: sortingArray } ).complete (err) ->
              return callback err if err?
              sio.to("#{spaceId}").emit 'removeElement', { element }
              callback()

  # moves an element from one column to another
  moveElement : (sio, socket, data, callback) ->
    spaceId = data.spaceId
    oldColumnId = data.oldColumnId
    newColumnId = data.newColumnId
    newIndex = data.newIndex
    elementId = data.elementId
   
    # find the old column first
    db.Column.find(where: { id: oldColumnId } ).complete (err, column) ->
      return callback err if err?
      # now find the new column
      db.Column.find(where: { id: newColumnId } ).complete (err, column) ->
        return callback err if err?
        # the fuck do we do now???? TODO TODO TODO
        callback()