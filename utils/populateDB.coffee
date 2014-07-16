utils = require './db_utils'
utils.populate (err, result) ->
	if err?
		console.log "Error:", err
		process.exit(1)
	else
		console.log "Success"
		process.exit(0)

