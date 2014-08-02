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

  server.get '/s/:spaceKey', (req, res) ->
    space = db.Space.find( {
      where: { spaceKey: req.params.spaceKey },
      include: [ db.Element ]
    } ).complete (err, space) ->
      return console.error err if err?
      if not space?
        res.status 404
        res.render '404', { url: req.url }
      else
        res.render 'space.jade',
          title : space.name
          space : space

  server.get '/500', (req, res) ->
    throw new Error 'This is a 500 Error'

  server.get '/*', (req, res) ->
    res.status 404
    res.render '404', { url: req.url }
    console.log 'Failed to get', req.url
    # throw new NotFound;

  NotFound = (msg) ->
    this.name = 'NotFound'
    Error.call this, msg
    Error.captureStackTrace this, arguments.callee