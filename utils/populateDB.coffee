db = require '../server/adapters/db.js'
async = require 'async'
createDB = 
"""
drop schema public cascade;create schema public;
create type data_type as enum ('text', 'image', 'website');
create table users (
 user_id serial primary key,
 fb_id  integer unique,
 email text unique,
 name text
);

create table spaces (
 space_id  serial primary key,
 name text,
 creation_time timestamp default now() NOT NULL,
 last_change timestamp default now() NOT NULL,
 creator_id  integer references users(user_id) NOT NULL,
 column_sorting integer[] DEFAULT array[]::int[]
);

create table user_spaces (
 creation_time timestamp default now() NOT NULL,
 user_id integer references users(user_id) NOT NULL,
 space_id integer references spaces(space_id) NOT NULL,
 primary key (user_id, space_id)
);

create table columns (
 column_id  serial primary key,
 space_id  integer references spaces(space_id) NOT NULL,
 creation_time  timestamp default now(),
 element_sorting integer[] DEFAULT array[]::int[]
);

create table elements (
 element_id serial primary key,
 column_id integer references columns(column_id) NOT NULL, 
 content_type data_type NOT NULL,
 content text NOT NULL
);
"""
copyCols = "COPY columns(space_id, element_sorting) FROM '/Users/joelsimon/Projects/Scrap/utils/fakeData/columns.csv' DELIMITER ',' CSV;"
copyElems = "COPY elements(column_id, content_type, content) FROM '/Users/joelsimon/Projects/Scrap/utils/fakeData/elements.csv' DELIMITER ',' CSV;"
createUser = "INSERT INTO users (name) VALUES ('Testr')"
createSpace = "INSERT INTO spaces (creator_id, name) VALUES (1, 'Test')"
addSpaceToUser = "INSERT INTO user_spaces (user_id, space_id) VALUES (1, 1)"
async.series [
	(cb) -> db.query createDB, cb
	(cb) -> db.query createUser, cb
	(cb) -> db.query createSpace, cb
	(cb) -> db.query addSpaceToUser, cb
	(cb) -> db.query copyCols, cb
	(cb) -> db.query copyElems, cb
	], (err, result) ->
		if err?
			console.log "Error:", err
		else
			console.log "Success"
