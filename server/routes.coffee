db = require '../models'

module.exports = (server) ->
  # server.error (err, req, res, next) ->
  #   if err instanceof NotFound
  #     res.render '404.jade', { locals: { 
  #           title : '404 - Not Found'
  #           description: ''
  #           author: ''
  #           analyticssiteid: 'XXXXXXX' 
  #         }, status: 404 }
  #   else
  #     res.render '500.jade', { locals: {
  #           title : 'The Server Encountered an Error'
  #           description: ''
  #           author: ''
  #           analyticssiteid: 'XXXXXXX'
  #           error: err
  #         },status: 500 }

  server.get '/', (req,res) ->
    res.render 'index.jade', 
      title : 'Your Page Title'
      description: 'Your Page Description'
      author: 'Your Name'
      analyticssiteid: 'XXXXXXX' 

  server.get '/s/:id', (req, res) ->
    space = db.Space.find( {
      where: { id: +req.params.id },
      include: [ db.Element ]
    } ).complete (err, space) ->
      return console.error err if err?
      res.render 'space.jade',
        title : space.name
        space : space

  server.get '/500', (req, res) ->
    throw new Error 'This is a 500 Error'


  server.get '/*', (req, res) ->
    res.redirect('/');

  NotFound = (msg) ->
    this.name = 'NotFound'
    Error.call this, msg
    Error.captureStackTrace this, arguments.callee