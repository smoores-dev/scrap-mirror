require('coffee-script/register');
var connect = require('connect')
    , express = require('express')
    , io = require('socket.io')
    , port = (process.env.PORT || 9001);

//Setup Express
var server = express.createServer();
server.configure(function(){
    server.set('views', __dirname + '/views');
    server.set('view options', { layout: false });
    server.use(connect.bodyParser());
    server.use(express.cookieParser());
    server.use(express.session({ secret: "club_sexdungeon"}));
    server.use(connect.static(__dirname + '/static'));
    server.use(server.router);
});

server.listen(port);
require('./server/socketBinding')(server);
require('./server/routes')(server);
console.log('Listening on port:' + port );
