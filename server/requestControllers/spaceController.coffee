models = require '../../models'
module.exports =
  
  # create a new space and redirect to it
  newSpace : (req, res, callback) ->
    spaceKey = @generateUUID()
    name = req.body.space.name
    currentUserId = req.session.currentUserId
    
    models.User.find(
      where: { id: currentUserId }
      include: [ models.Space ]
    ).complete (err, user) ->
      return callback err if err?
      models.Space.create( { name, spaceKey } ).complete (err, space) ->
        return callback err if err?
        space.addUser(user).complete (err) ->
          return callback err if err?
          space.setCreator(user).complete (err) ->
            return callback err if err?
            # redirect to new page
            res.redirect "/s/" + spaceKey
            callback()
            
  showSpace : (req, res, callback) ->
    currentUserId = req.session.currentUserId
    models.Space.find(
      where: { spaceKey: req.params.spaceKey }
      include: [ models.Element, models.User, { model: models.User, as: 'Creator' } ]
    ).complete (err, space) ->
      return callback err if err?
      if space? and currentUserId?
        models.User.find(
          where: { id: currentUserId }
          include: [ models.Space ]
        ).complete (err, user) ->
          return callback err if err?
          space.hasUser(user).complete (err, result) ->
            return callback err if err?
            if result
              res.render 'space.jade',
                title : space.name
                space: space
                user: user
            callback()
      else
        res.status 404
        res.render '404', { url: req.url }
        callback()

  uploadFile : (req, res, callback) ->
    object_name = req.query.s3_object_name
    mime_type = req.query.s3_object_type

    now = new Date()
    expires = Math.ceil((now.getTime() + 10000) / 1000) # 10 seconds from now
    amz_headers = "x-amz-acl:public-read"

    put_request = "PUT\n\n#{mime_type}\n#{expires}\n#{amz_headers}\n#{S3_BUCKET}/#{object_name}"

    signature = crypto.createHmac('sha1', AWS_SECRET_KEY).update(put_request).digest 'base64'
    signature = encodeURIComponent signature.trim()
    signature = signature.replace '%2B', '+'

    url = "https://#{S3_BUCKET}.s3.amazonaws.com/#{object_name}"

    credentials = {
        signed_request: "#{url}?AWSAccessKeyId=#{AWS_ACCESS_KEY}&Expires=#{expires}&Signature=#{signature}",
        url: url
      }

    res.write JSON.stringify credentials
    res.end()
    callback()

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text
