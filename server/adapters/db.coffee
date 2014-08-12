var pg = require 'pg'
var dbstring = 'postgres://localhost/scrapdb'

exports.connString = dbstring

exports.query = (text, values, callback) ->
  if not callback?
    callback = values
    values = []

	return callback 'Invalid text:' + text if typeof text isnt 'string'
	return callback 'Invalid values:' + values if not Array.isArray(values)? 
	return callback 'Invalid callback' if typeof callback isnt 'function'

  pg.connect dbstring, (err, client, done) ->
    client.query text, values, (err, result) ->
      done()
      if err and err.position
        err.text = text.insert err.position - 1, '{error->}'
      if callback? 
        callback err, result
      else
        console.log 'Call to db.query withouth a callback, very bad!!'
        console.trace()

exports.getConnection = (callback) ->
  pg.connect dbstring, callback

String.prototype.insert = (index, string) ->
  if index > 0
    @substring(0, index) + string + @substring index, @length
  else
    string + this
