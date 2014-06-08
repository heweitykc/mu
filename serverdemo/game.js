var timeout = 20000;//超时
var clients = [];
var stime = 0;

exports.clientIn = function (socket){
	// 我们获得一个连接 - 该连接自动关联一个socket对象
    console.log('new client: ' +
        socket.remoteAddress + ':' + socket.remotePort);
    socket.setEncoding('binary');
	clients.push({sock:socket});

    //超时事件
    socket.setTimeout(timeout,function(){
        console.log('连接超时');
        socket.end();
    });

    //接收到数据
    socket.on('data',function(data){
		if(data == "q"){
			socket.end();
		} else {
			
		}
        console.log('recv:' + (data));
    });

    //数据错误事件
    socket.on('error',function(exception){
        console.log('socket error:' + exception);
        socket.end();
    });

    //客户端关闭事件
    socket.on('close',function(data){
        console.log('client close: ' +
            socket.remoteAddress + ' ' + socket.remotePort);
		socket.destroy();
    });
}

exports.mainstart = function(){
	stime = process.hrtime();
}

exports.mainloop = function (){
	var delta = process.hrtime(stime);
	stime = process.hrtime();
	console.log('frame。。。' + delta);
	for(var i=0;i<clients.length;i++){
		var sock = clients[i].sock;
		console.log('在线：' + sock.remoteAddress);
	}
}