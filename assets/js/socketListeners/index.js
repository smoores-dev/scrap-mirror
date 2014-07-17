$(document).ready(function() {   
  console.log('hello scrap');
  var socket = io.connect();
  
  // $('#sender').bind('click', function() {
  //  socket.emit('message', 'Message Sent on ' + new Date());     
  // });
  // socket.on('server_message', function(data){

  //  $('#receiver').append('<li>' + data + '</li>');
  // });
  socket.on('newSpace', function(data){
    var space = data.space;
  });
  socket.on('reorderSpace', function(data){
    var columnSorting = data.columnSorting;
  });
  socket.on('newColumn', function(data){
    var column = data.column;
  });
  socket.on('reorderColumn', function(data){
    var columnId = data.columnId;
    var elementSorting = data.elementSorting;
  });
  socket.on('newElement', function(data){
    var element = element;
  });
  socket.on('removeElement', function(data){
    var element = element;
  });
  socket.on('moveElement', function(data){
    var oldColumn = data.oldColumn; 
    var newColumn = data.newColumn;
    var newIndex = data.newIndex;
    var elementId = data.elementId;
  });
});