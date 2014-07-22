$(document).ready(function() {   
  var socket = io.connect();
  
  $('form').submit(function(event) {
    event.preventDefault();
    var columnId = $('input[name=columnId]', this).val();
    var content = $('input[name=content]', this).val();
    if (columnId) {
      var index = $('input[name=index]', this).val();
      socket.emit('newElement', { columnId: +columnId, contentType: 'text', content: content, index: +index });

    } else { // make a new column with a new element
      socket.emit('newColumn', { contentType: 'text', content: content });
    }
  });
});