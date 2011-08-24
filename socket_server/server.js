/**
 * Important note: this application is not suitable for benchmarks!
 */

var http = require('http')
    , url = require('url')
    , fs = require('fs')
    , io = require('socket.io');

var send404 = function(res){
    res.writeHead(404);
    res.write('404');
    res.end();
};

server = http.createServer(function(request, response) {
    // your normal server code
    var path = url.parse(request.url).pathname;
    switch (path) {
    case '/':
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.write('<h1>Welcome. Try the <a href="/client.html">sample socket client</a>.</h1>');
        response.end();
    break;
    case '/json.js':
    case '/client.html':
        fs.readFile(__dirname + path, function(err, data) {
            if (err) 
                return send404(response);
            response.writeHead(200, {'Content-Type': path == '/json.js' ? 'text/javascript' : 'text/html'})
            response.write(data, 'utf8');
            response.end();
        });
    break;
    default: 
        send404(response);
    }    
}),
server.listen(8124);

// socket.io, I choose you
var io = io.listen(server)
  , clients = [];
  
io.on('connection', function(client) {
    console.log("client connected", client);
    
    clients.push(client);
    client.send("welcome! :)");
    
    // tell everyone this client has connected
    // client.broadcast({ announcement: client.sessionId + ' connected' });
  
    client.on('message', function(message){
        console.log("message received", message);
        // echo this message back to the client
        client.send(message);
    });

    client.on('disconnect', function(){
        // tell everyone this client has disconnected
        // client.broadcast({ announcement: client.sessionId + ' disconnected' });
    });
});
