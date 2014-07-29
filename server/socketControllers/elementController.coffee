db = require '../../models'
async = require 'async'

module.exports =

  # create a new element and save it to db
  newElement : (sio, socket, data, spaceId, callback) =>

    options =
      contentType : data.contentType
      content : data.content
      x: data.x
      y: data.y
      z: data.z
      scale: data.scale
      SpaceId: spaceId

    db.Element.create(options).complete (err, element) =>
      return callback err if err?
      sio.to("#{spaceId}").emit 'newElement', { element }
      callback()

  # delete the element
  removeElement : (sio, socket, data, spaceId, callback) =>
    id = data.elementId

    # find/delete the element
    db.Element.find(where: { id } ).complete (err, element) =>
      return callback err if err?
      return callback() if not element? 
      element.destroy().complete (err) =>
        return callback err if err?
        sio.to("#{spaceId}").emit 'removeElement', { element }
        callback()

  # moves an element from one column to another
  updateElement : (sio, socket, data, spaceId, callback) =>
    id = +data.elementId
    
    toUpdate = {id}
    toUpdate.x = data.x if data.x?
    toUpdate.y = data.y if data.y?
    toUpdate.z = data.z if data.z?
    toUpdate.scale = data.scale if data.scale?

    db.Element.update(toUpdate, {id}).complete (err, element) =>
      return callback err if err?
      sio.to("#{spaceId}").emit 'updateElement', { element }
      callback()
