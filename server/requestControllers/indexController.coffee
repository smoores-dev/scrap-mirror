models = require '../../models'
module.exports =

  index: (req, res, callback) ->
    if req.session.currentUserId?
      currentUserId = req.session.currentUserId
      models.User.find(
        where: { id: currentUserId }
        include: [ models.Space ]
      ).complete (err, user) ->
        return callback err if err?
        req.session.currentUserId = user.id
        res.redirect "/s/" + user.spaces[0].spaceKey
        callback()
    else
      res.render 'index.jade',
        title : 'Welcome to Scrap!'
        description: ''
        author: 'scrap'
        analyticssiteid: 'XXXXXXX'
      callback()
