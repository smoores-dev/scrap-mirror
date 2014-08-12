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
          console.log 'LOGIN FAILED: not a valid email'
          return res.redirect "/"
        if err.code == '23505' # not a unique email
          console.log 'LOGIN FAILED: not a unique email'
          return res.redirect "/"

        return callback err

      req.session.currentUserId = user.id
      req.body.space =
        name: "Welcome"
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
            req.session.currentUserId = user.id
            res.redirect "/s/" + user.spaces[0].spaceKey
            callback()
          else
            res.redirect "/"
            callback()
      else
        res.redirect "/"
        callback()

  logout : (req, res, callback) ->
    req.session.destroy (err) ->
      return callback err if err?
      res.redirect "/"
      callback()
