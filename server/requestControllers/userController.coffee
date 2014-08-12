models = require '../../models'
spaceController = require './spaceController'
module.exports =
  
  # create a new user and save them to the db
  newUser : (req, res) ->
    username = req.body.username
    email = req.body.email
    password = req.body.password
    
    models.User.create( { username, email, password } ).complete (err, user) ->
      return console.error err if err?
      spaceController.newSpace "My Beans", res

  # verify login creds
  login : (req, res) ->
    email = req.body.email
    password = req.body.password

    models.User.find(where: { email } ).complete (err, user) ->
      return console.error err if err?
      user.verifyPassword password, (err, result) ->
        return console.error err if err?

        # render first space on success
        if result
          user.getSpaces().complete (err, spaces) ->
            return console.error err if err?
            space = spaces[0]
            res.render 'space.jade',
              title : space.name
              space : space
        else
          # go back to index on failure
          res.render 'index.jade'
