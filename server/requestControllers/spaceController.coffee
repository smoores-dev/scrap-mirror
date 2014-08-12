models = require '../../models'
module.exports =
  
  # create a new space and save it to the db
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

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text
