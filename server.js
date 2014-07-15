require('coffee-script/register');
var connect = require('connect')
    , express = require('express')
    , io = require('socket.io')
    , port = (process.env.PORT || 9001)
    , db = require('./models')
    , compass = require('node-compass');


//Setup Express
var server = express.createServer();
server.configure(function(){
    server.set('views', __dirname + '/views');
    server.set('view options', { layout: false });
    server.use(connect.bodyParser());
    server.use(express.cookieParser());
    server.use(express.session({ secret: "club_sexdungeon"}));
    server.use(connect.static(__dirname + '/assets'));
    server.use(server.router);
    server.use(compass());
});

db.sequelize.sync({ force: true }).complete(function(err) {
    if (err) {
        throw err[0];
    } else {
        server.listen(port);
        require('./server/socketBinding')(server);
        require('./server/routes')(server);
        console.log('Listening on port:' + port );
    }
});
