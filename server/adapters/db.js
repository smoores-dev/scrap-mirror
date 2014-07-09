var pg = require('pg');
var dbstring = 'postgres://localhost/scrapdb';

exports.connString = dbstring;

exports.query = function(text, values, cb) {
  if (!cb) {
    cb = values;
    values = [];
  }

	if (typeof(text) !== 'string') return cb('Invalid text:'+text);
	if (! Array.isArray(values)) return cb('Invalid values:'+values);
	if (typeof(cb) !== 'function') return cb('Invalid cb');

  pg.connect(dbstring, function(err, client, done) {
    client.query(text, values, function(err, result) {
      done();
      if (err && err.position) {
        err.text = (text.insert(err.position-1, '{error->}'))
      }
      if(cb) {
        cb(err, result);
      } else {
        console.log('Call to db.query withouth a callback, very bad!!');
        console.trace();
      }
    })
  });
}

exports.getConnection = function(callback) {
  pg.connect(dbstring, callback);
}

String.prototype.insert = function (index, string) {
  if (index > 0)
    return this.substring(0, index) + string + this.substring(index, this.length);
  else
    return string + this;
};