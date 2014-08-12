models = require '../models'
errorHandler = require './errorHandler'
spaceController = require './requestControllers/spaceController'
userController = require './requestControllers/userController'

module.exports = (server) ->
  server.get '/', (req,res) ->
    res.render 'index.jade', 
      title : 'Welcome to Scrap!'
      description: ''
      author: 'scrap'
      analyticssiteid: 'XXXXXXX' 

  server.post '/s/new', (req, res) ->
    spaceController.newSpace req, res, errorHandler

  server.get '/s/:spaceKey', (req, res) ->
    console.log "SPACES2", req.session.currentUser.spaces
    spaceController.showSpace req, res, errorHandler

  server.post '/login', (req, res) ->
    userController.login req, res, errorHandler

  server.post '/register', (req, res) ->
    userController.newUser req, res, errorHandler

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
