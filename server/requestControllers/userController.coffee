models = require '../../models'
spaceController = require './spaceController'
module.exports =
  
  # create a new user and save them to the db
  newUser : (req, res) ->
    attributes =
      username: req.body.username
      email: req.body.email
      password: req.body.password
    
    models.User.create(attributes).complete (err, user) ->
      if err?
        if 'email' of err # not a valid email
          return res.redirect "/"
        if err.code == '23505' # not a unique email
          return res.redirect "/"

        return console.error err
      spaceController.newSpace "My Beans", res, user

  # verify login creds
  login : (req, res) ->
    email = req.body.email
    password = req.body.password

    models.User.find(where: { email } ).complete (err, user) ->
      return console.error err if err?
      if user?
        user.verifyPassword password, (err, result) ->
          return console.error err if err?

          # render first space on success
          if result
            user.getSpaces().complete (err, spaces) ->
              return console.error err if err?
              # redirect to new page
              return res.redirect "/s/" + spaces[0].spaceKey

      res.redirect "/"
