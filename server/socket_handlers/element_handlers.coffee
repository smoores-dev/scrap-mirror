module.exports = 
  newElement : (socket, data) ->
    spaceId = data.spaceId
    columnId = data.columnId
    element = data.element

  removeElement : (socket, data) ->
    spaceId = data.spaceId
    columnId = data.columnId
    elementId = data.elementId

  moveElement : (socket, data) ->
    spaceId = data.spaceId
    oldColumn = data.oldColumn
    newColumn = data.newColumn
    newIndex = data.newIndex
    elementId = data.elementId