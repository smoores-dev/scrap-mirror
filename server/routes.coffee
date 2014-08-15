models = require '../models'
errorHandler = require './errorHandler'
fs = require 'fs'
path = require 'path'

controllers = {}
fs.readdirSync(__dirname + '/requestControllers').forEach (fileName) ->
  controllerName = fileName.slice(0, -7)
  pathName = path.join __dirname, '/requestControllers', controllerName
  controllers[controllerName] = require(pathName)

module.exports = (server) ->
  server.get '/', (req,res) ->
    controllers.indexController.index req, res, errorHandler

  server.post '/s/new', (req, res) ->
    controllers.spaceController.newSpace req, res, errorHandler

  server.get '/s/:spaceKey', (req, res) ->
    controllers.spaceController.showSpace req, res, errorHandler

  server.post '/login', (req, res) ->
    controllers.userController.login req, res, errorHandler

  server.get '/logout', (req, res) ->
    controllers.userController.logout req, res, errorHandler

  server.post '/register', (req, res) ->
    controllers.userController.newUser req, res, errorHandler

  server.get '/sign_s3', (req, res) ->
    controllers.spaceController.uploadFile req, res, errorHandler
    
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
