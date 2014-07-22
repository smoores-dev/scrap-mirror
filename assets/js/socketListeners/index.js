$(document).ready(function() {   
  var socket = io.connect();
  
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
    console.log('Got newElement', data);
    var element = element;

    // var content = $('<article></article>');
    // var content = $('<p></p>');
    // var div = $('<div></div>');

    // content.text(element.content);
    // div.addClass('background');

    // article.append(content);
    // article.append(div);

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