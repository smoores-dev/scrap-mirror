models = require '../../models'
module.exports =
  
  # create a new space and save it to the db
  newSpace : (req, res, callback) ->
    spaceKey = @generateUUID()
    name = req.body.space.name
    user = req.session.currentUser
    
    models.Space.create( { name, spaceKey } ).complete (err, space) ->
      return callback err if err?
      space.setUsers [user]

      # redirect to new page
      res.redirect "/s/" + spaceKey

  showSpace : (req, res, callback) ->
    currentUser = req.session.currentUser
    models.Space.find(
      where: { spaceKey: req.params.spaceKey }
      include: [ models.Element, models.User ]
    ).complete (err, space) ->
      return callback err if err?
      if space? and currentUser?
        space.hasUser(currentUser).complete (err, result) ->
          return callback err if err?
          if result
            res.render 'space.jade',
              title : space.name
              space : space
              user : currentUser
      else
        res.status 404
        res.render '404', { url: req.url }

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text
