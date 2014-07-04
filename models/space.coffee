pg = require 'pg'

class Space


	# TODO: addColumn, removeColumn

	# takes options hash
	#	Creates wrapper around database record
	constructor: (@id, creator_id, column_sorting) ->
		# TODO: create 'creator' and 'columns' instance variables

	addUser: (user, callback) ->
		user_id = user.id

		query = "INSERT INTO user_spaces (user_id, space_id) VALUES ($1, $2)"
		pg.query query, [user_id, @id], (err, res) ->
			return callback err if err?
			callback null

	removeUser: (user, callback) ->
		user_id = user.id

		query = "DELETE FROM user_spaces WHERE user_id = $1 AND space_id = $2"
		pg.query query, [user_id, @id], (err, res) ->
			return callback err if err?
			callback null

	reorderSpace: (@column_sorting, callback) ->
		query = "UPDATE spaces SET column_sorting = $2 WHERE space_id = $1"
		pg.query query, [@id, column_sorting], (err, res) ->
			return callback err if err?
			callback null, @
		
	# creator - User instance
	# return a new Space
	@create: (creator, name, callback) ->
		creator_id = creator.id

		query = "INSERT INTO spaces (creator_id, name) VALUES ($1, $2) RETURNS space_id"
		pg.query query, [creator_id, name], (err, res) ->
			return callback err if err?
			callback null, new Space creator_id, res.rows[0].space_id, []

	@find: (id, callback) ->
		query = "SELECT * FROM spaces WHERE space_id = $1"
		pg.query query, [id], (err, res) ->
			return callback err if err?
			space = res.rows[0]
			callback null, new Space space.creator_id, id, space.column_sorting
	
