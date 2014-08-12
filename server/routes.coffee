models = require '../models'
spaceController = require './requestControllers/spaceController'
userController = require './requestControllers/userController'

module.exports = (server) ->
  server.get '/', (req,res) ->
    res.render 'index.jade', 
      title : 'Welcome to Scrap!'
      description: ''
      author: 'scrap'
      analyticssiteid: 'XXXXXXX' 

  server.get '/s/:spaceKey', (req, res) ->
    spaceController.showSpace req, res

  server.post '/login', (req, res) ->
    userController.login req, res

  server.post '/register', (req, res) ->
    userController.newUser req, res

  server.get '/500', (req, res) ->
    throw new Error 'This is a 500 Error'

  server.get '/*', (req, res) ->
    res.status 404
    res.render '404', { url: req.url }
    console.log 'Failed to get', req.url

  NotFound = (msg) ->
    this.name = 'NotFound'
    Error.call this, msg
    Error.captureStackTrace this, arguments.callee
