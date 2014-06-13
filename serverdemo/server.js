var net = require('net');
var game = require('./game.js');

var listenPort = 7003;//监听端口

var server = net.createServer(game.clientIn)
server.listen(listenPort);

//服务器监听事件
server.on('listening',function(){
    console.log("server listening:" + server.address().port);
});

//服务器错误事件
server.on("error",function(exception){
    console.log("server error:" + exception);
});

game.mainstart();
setInterval(game.mainloop, 500);