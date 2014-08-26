models   = require '../../models'
async    = require 'async'
webshot  = require 'webshot'
fs       = require 'fs'
Uploader = require('s3-streaming-upload').Uploader

memCache = {}

module.exports =
  # create a new element and save it to db
  newElement : (sio, socket, data, spaceKey, callback) =>

    attributes = {
      contentType: data.contentType
      content: data.content
      caption: data.caption
      x: data.x
      y: data.y
      z: data.z
      scale: data.scale
    }

    randString = () ->
      text = ""
      possible = "abcdefghijklmnopqrstuvwxyz0123456789"
      for i in [0..6]
        text += possible.charAt(Math.floor(Math.random() * possible.length))
      text

    createThumbNail = (callback) ->
      if data.contentType isnt 'website'
        return callback null, null
      if data.content of memCache
        return callback null, memCache[data.content]

      url = "websites/#{randString()}_#{data.content}.png"
      options =
        windowSize: { width: 900, height: 1200 }
        shotSize:   { width: 'window', height: 'window' }

      webshot data.content, '', options, (err, renderStream) ->
        return callback err if err
        upload = new Uploader {
          accessKey:  'AKIAJQ7VP2SMGLIV5JQA'
          secretKey:  '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'
          bucket:     'scrap_images'
          objectName: url
          stream:     renderStream
          streamType: 'png'
          objectParams:
            ACL: 'public-read'
            ContentType: 'image/png'
        }
        upload.on 'completed', (err, res) ->
          console.log 'upload completed'
          callback null, 'https://s3.amazonaws.com/scrap_images/' +url

        upload.on 'failed', (err) ->
          console.log 'upload failed with error', err
          callback err

    models.Space.find(where: { spaceKey }).complete (err, space) =>
      return callback err if err?
      attributes.SpaceId = space.id
      models.Element.create(attributes).complete (err, element) =>
        return callback err if err?
        # emit element before laboriously generating thumbnail
        sio.to(spaceKey).emit 'newElement', { element, loaded: false }
  
        createThumbNail (err, thumbnail) =>
          memCache[data.content] = thumbnail
          return callback err if err?
          # if it was a website and we made a thumbnail, then emit the updated
          # element to the room
          if thumbnail?
            query = "UPDATE \"Elements\" SET"
            query += " \"thumbnail\"=:thumbnail "
            query += "WHERE \"id\"=:id RETURNING *"

            # new element to be filled in by update
            elementShell = models.Element.build()

            models.sequelize.query(query, elementShell, null, { thumbnail, id: element.id })
              .complete (err, result) ->
                return callback err if err?
                sio.to(spaceKey).emit 'newElement', { element: result, loaded: true}

  # delete the element
  removeElement : (sio, socket, data, spaceKey, callback) =>
    id = data.elementId

    query = "DELETE FROM \"Elements\" WHERE \"id\"=:id"

    elementShell = models.Element.build()
    models.sequelize.query(query, null, null, { id })
      .complete (err, result) ->
        return callback err if err?
        sio.to(spaceKey).emit 'removeElement', { id }
        callback()

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
