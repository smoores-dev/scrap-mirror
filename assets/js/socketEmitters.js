$(document).ready(function() {   
  var socket = io.connect();
  
  $('form').submit(function(event) {
    event.preventDefault();
    columnId = $('input[name=columnId]', this).val()
    index = $('input[name=index]', this).val()
    content = $('input[name=content]', this).val()
    socket.emit('newElement', { columnId: +columnId, contentType: 'text', content: content })
  });
});