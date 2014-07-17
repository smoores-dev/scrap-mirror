db = require '../../models'
async = require 'async'

module.exports =

  # create a new element and save it to db
  newElement : (sio, socket, data, spaceId, callback) =>
    columnId = data.columnId
    contentType = data.contentType
    content = data.content
    index = data.index

      # find the associated column first
    db.Column.find(where: { id: columnId } ).complete (err, column) =>
      return callback err if err?
      # once we have it, create the element
      db.Element.create({ contentType, content, ColumnId: column.id}).complete (err, element) =>
        return callback err if err?
        module.exports.insertIntoSorting column, element.id, index, (err) ->
          return callback err if err?
          sio.to("#{spaceId}").emit 'newElement', { columnId, element }
          callback()

  # delete the element
  removeElement : (sio, socket, data, spaceId, callback) =>
    id = data.elementId

    # find/delete the element
    db.Element.find(where: { id } ).complete (err, element) =>
      return callback err if err?
      columnId = element.ColumnId
      element.destroy().complete (err) =>
        return callback err if err?

        # remove the element from the column's elementSorting
        db.Column.find(where: { id: columnId }).complete (err, column) =>
          return callback err if err?

          # delete the column if the deleted element was the only one
          if column.elementSorting.length is 1
            column.destroy().complete (err) =>
              return callback err if err?
              sio.to("#{spaceId}").emit 'removeColumn', { column }
              return callback()

          else # else just find/remove from the array
            module.exports.removeFromSorting column, id, (err) =>
              return callback err if err?
              sio.to("#{spaceId}").emit 'removeElement', { element }
              callback()

  # moves an element from one column to another
  moveElement : (sio, socket, data, spaceId, callback) =>
    oldColumnId = data.oldColumnId
    newColumnId = data.newColumnId
    newIndex = data.newIndex
    elementId = data.elementId
   
    # find the old column first
    db.Column.find(where: { id: oldColumnId } ).complete (err, oldColumn) =>
      return callback err if err?
      # now find the new column
      db.Column.find(where: { id: newColumnId } ).complete (err, newColumn) =>
        return callback err if err?
        # now find the element and modify its columnId
        db.Element.find(where: { id: elementId } ).complete (err, element) =>
          return callback err if err?
          element.setColumn(newColumn).complete (err) =>
            return callback err if err?
            # remove from the old column and add to new one
            module.exports.removeFromSorting oldColumn, elementId, (err) =>
              return callback err if err?
              module.exports.insertIntoSorting newColumn, elementId, newIndex, (err) =>
                return callback err if err?
                sio.to("#{spaceId}").emit 'moveElement', { newColumn, oldColumn, element }
                callback()


  # removes specified element from the sorting and updates the db
  removeFromSorting : (column, elementId, callback) =>
    elementSorting = column.elementSorting
    elementIndex = elementSorting.indexOf(elementId)
    elementSorting.splice(elementIndex, 1)
    column.updateAttributes( { elementSorting } ).complete (err) =>
      return callback err if err?
      callback()

  # adds the element at that index to the column and updates the db
  insertIntoSorting : (column, elementId, index, callback) =>
    elementSorting = column.elementSorting.splice(index, 0, elementId)
    column.updateAttributes( { elementSorting: column.elementSorting } ).complete (err) =>
      return callback err if err?
      callback()