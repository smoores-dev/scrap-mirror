db = require '../server/adapters/db.js'
async = require 'async'
initDB = 
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
db.query initDB, (err, res) ->
	if err?
		console.log "Error:", err
		process.exit(1)
	else
		console.log "Success"
		process.exit(0)

