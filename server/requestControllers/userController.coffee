models = require '../../models'
spaceController = require './spaceController'
module.exports =
  
  # create a new user and default space, redirect to space
  newUser : (req, res, callback) ->
    attributes =
      name: req.body.user.name
      email: req.body.user.email
      password: req.body.user.password
    
    models.User.create(attributes).complete (err, user) ->
      if err?
        if 'email' of err # not a valid email
          return res.redirect "/"
        if err.code == '23505' # not a unique email
          return res.redirect "/"

        return callback err

      req.session.currentUser = user
      req.body.space.name = "Welcome"
      spaceController.newSpace req, res, callback

  # verify login creds, redirect to first space
  login : (req, res, callback) ->
    email = req.body.user.email
    password = req.body.user.password

    models.User.find(
      where: { email }
      include: [ models.Space ]
    ).complete (err, user) ->
      return callback err if err?
      if user?
        user.verifyPassword password, (err, result) ->
          return callback err if err?

          # render first space on success
          if result
            req.session.currentUser = user
            user.getSpaces().complete (err, spaces) ->
              return callback err if err?
              # redirect to new page
              res.redirect "/s/" + spaces[0].spaceKey
          else res.redirect "/"

      else res.redirect "/"
