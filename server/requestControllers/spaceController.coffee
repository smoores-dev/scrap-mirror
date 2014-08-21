models = require '../../models'
crypto = require 'crypto'
uuid = require('node-uuid')
mime = require('mime')
moment = require('moment')

config = 
  aws_key:  "AKIAJQ7VP2SMGLIV5JQA" #AWS Key
  aws_secret:  "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" #AWS Secret
  aws_bucket:  "scrap_images" #AWS Bucket
  redirect_host:  "http://ocalhost:3000/" #Host to redirect after uploading
  host:  "s3.amazonaws.com" #S3 provider host
  bucket_dir:  "uploads/";
  max_filesize:  20971520 #Max filesize in bytes (default 20MB)

module.exports =
  # create a new space and redirect to it
  newSpace : (req, res, callback) ->
    spaceKey = uuid.v4().split('-')[0]
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
    mime_type = mime.lookup(req.query.title) # Uses node-mime to detect mime-type based on file extension
    expire = moment().utc().add('hour', 1).toJSON("YYYY-MM-DDTHH:mm:ss Z") # Set policy expire date +30 minutes in UTC
    file_key = uuid.v4() # Generate uuid for filename

    # Creates the JSON policy according to Amazon S3's CORS uploads specfication (http://aws.amazon.com/articles/1434)
    policy = JSON.stringify({
      "expiration": expire
      "conditions": [
        {"bucket": config.aws_bucket}
        ["eq", "$key", config.bucket_dir + file_key + "_" + req.query.title]
        {"acl": "public-read"}
        {"success_action_status": "201"}
        ["starts-with", "$Content-Type", mime_type]
        ["content-length-range", 0, config.max_filesize]
      ]
    });

    base64policy = new Buffer(policy).toString('base64'); # Create base64 policy
    signature = crypto.createHmac('sha1', config.aws_secret).update(base64policy).digest('base64'); # Create signature

    # Return JSON View
    res.json {
      policy: base64policy
      signature: signature
      key: (config.bucket_dir + file_key + "_" + req.query.title)
      success_action_redirect: "/"
      contentType: mime_type
    }
    callback()