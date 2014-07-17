$(document).ready(function() {   
  var socket = io.connect();
  
  $('form').submit(function(event) {
    event.preventDefault();
    columnId = $('input[name=columnId]', this).val();
    content = $('input[name=content]', this).val();
    if columnId {
      index = $('input[name=index]', this).val();
      socket.emit('newElement', { columnId: +columnId, contentType: 'text', content: content });
    }
    else {
      socket.emit('newColumn', { contentType: 'text'}, content: content });
    }
  });
});