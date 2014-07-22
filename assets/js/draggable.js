$(document).ready(function() {

  var socket = io.connect();

  $('.column.normal').sortable({
    revert: true,
    connectWith: '.column.normal',
    cursor: 'move',
    items: '> :not(.add)',
    stop: function(event, ui) {
      var columnId = ui.item.data('columnid');
      var newElement = '<article class="add">'+
          '<form>'+
          '<input type="hidden" name="columnId" value='+columnId+'></input>'+
          '<input type="hidden" name="index" value="1"></input>'+
          '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
          '<input type="submit" style="visibility:hidden;"></input>'+
          '</form>'+
          '</article>'
      if(ui.item.next().hasClass('add')) {
        $(ui.item).before(newElement);
        var form = $('form', $(ui.item).prev())
        form.submit(emitNewElement(socket));
      }
      else {
        $(ui.item).after();
        var form = $('form', $(ui.item).next())
        form.submit(emitNewElement(socket));
      }
    }
  });

  $('.column.normal > article:not(.add)').on('mousedown', function() {
    $(this).on('mousemove', function() {
      $(this).next().remove();
      $(this).off('mousemove');
    });
  });

})