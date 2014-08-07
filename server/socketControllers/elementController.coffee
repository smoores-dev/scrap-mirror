models = require '../../models'
async = require 'async'
module.exports =
db      = require '../../models'
async   = require 'async'
webshot = require 'webshot'
fs      = require 'fs'
Uploader = require('s3-streaming-upload').Uploader

randString = () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789"
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text

createThumbNail = (content, contentType, callback) ->
  if contentType != 'website'
    return callback null, null
  url = randString() + '.png'
  options =
    screenSize: { width: 240, height: 150 }
    shotSize: { width: 'all', height: 'window' }

  webshot content, (err, renderStream) ->
    return callback err if err
    upload = new Uploader {
      accessKey:  'AKIAJQ7VP2SMGLIV5JQA'
      secretKey:  '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'
      bucket:     'scrap_images'
      objectName: url
      stream:     renderStream
      objectParams:
        ACL: 'public-read'
        ContentType: 'image/png'
    }
    upload.on 'completed', (err, res) ->
      console.log('upload completed')
      callback null, 'https://s3.amazonaws.com/scrap_images/' +url


    upload.on 'failed', (err) ->
      console.log('upload failed with error', err)
      callback err

module.exports =
  # create a new element and save it to db
  newElement : (sio, socket, data, spaceKey, callback) =>
    content     = data.content
    contentType = data.contentType
    caption     = data.caption

    models.Space.find(where: { spaceKey }).complete (err, space) =>
      return callback err if err?
      createThumbNail content, contentType, (err, thumbnail) =>
        console.log err, thumbnail
        return callback err if err?
        options = {
          contentType
          content
          thumbnail
          caption : data.caption
          x: data.x
          y: data.y
          z: data.z
          scale: data.scale
          SpaceId: space.id
        }
        db.Element.create(options).complete (err, element) =>
          return callback err if err?
          sio.to("#{spaceKey}").emit 'newElement', { element }
          callback()

  # delete the element
  removeElement : (sio, socket, data, spaceKey, callback) =>
    id = data.elementId
    # find/delete the element
    models.Element.find(where: { id } ).complete (err, element) =>
      return callback err if err?
      return callback() if not element? 
      element.destroy().complete (err) =>
        return callback err if err?
        sio.to("#{spaceKey}").emit 'removeElement', { element }
        callback()

  # moves an element from one column to another
  updateElement : (sio, socket, data, spaceKey, callback) =>
    data.id = +data.elementId

    query = "UPDATE \"Elements\" SET"
    query += " \"x\"=:x," if data.x?
    query += " \"y\"=:y," if data.y?
    query += " \"z\"=:z," if data.z?
    query += " \"scale\"=:scale" if data.scale?
    # remove the trailing comma if necessary
    query = query.slice(0,query.length - 1) if query[query.length - 1] is ","
    query += " WHERE \"id\"=:id RETURNING *"

    # new element to be filled in by update
    element = models.Element.build()

    models.sequelize.query(query, element, null, data).complete (err, result) ->
      return callback err if err?
      sio.to("#{spaceKey}").emit 'updateElement', { element: result }
      callback()
