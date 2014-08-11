db = require '../models'

module.exports = (server) ->
  server.get '/', (req,res) ->
    res.render 'index.jade', 
      title : 'Welcome to Scrap!'
      description: ''
      author: 'scrap'
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

  NotFound = (msg) ->
    this.name = 'NotFound'
    Error.call this, msg
    Error.captureStackTrace this, arguments.callee
