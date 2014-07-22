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
    var element = data.element;
    var content = element.content;
    var index = data.index;
    var columnId = element.ColumnId;

    var newArticle = '<article class="text"><p>' + content + '</p><div class="background"></div></article>';
    var column = $('section.column.normal[data-columnid=' + columnId + ']');
    var articles = $('article:not(.add)', column);

    // clear the textbox
    var textboxForm = $(articles[index - 1]).next();
    $('input[name=content]', textboxForm).val('');

    // add the new article and textbox
    $(articles[index - 1]).after(newArticle).after(getAddBox(columnId));
    var newTextboxForm = $(articles[index - 1]).next();
    $('form', newTextboxForm).submit(emitNewElement(socket));
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

  var getAddBox = function(columnId) {
    return '<article class="add">'+
        '<form>'+
        '<input type="hidden" name="columnId" value='+columnId+'></input>'+
        '<input type="hidden" name="index" value="1"></input>'+
        '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
        '<input type="submit" style="visibility:hidden;"></input>'+
        '</form>'+
        '</article>'
  };
});