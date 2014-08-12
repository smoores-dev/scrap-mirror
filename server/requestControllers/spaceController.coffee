models = require '../../models'
module.exports =
  
  # create a new space and save it to the db
  newSpace : (name, res, user) ->
    spaceKey = @generateUUID()
    
    models.Space.create( { name, spaceKey } ).complete (err, space) ->
      return console.error err if err?
      space.setUsers [user]

      # redirect to new page
      res.redirect "/s/" + spaceKey

  showSpace : (req, res) ->
    models.Space.find({
      where: { spaceKey: req.params.spaceKey },
      include: [ models.Element ]
    }).complete (err, space) ->
      return console.error err if err?
      if space?
        res.render 'space.jade',
          title : space.name
          space : space
      else
        res.status 404
        res.render '404', { url: req.url }

  generateUUID : () ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789";
    for i in [0..6]
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text
