$(document).ready(function() {

  $('.column.normal').sortable({
    revert: true,
    connectWith: '.column.normal',
    cursor: 'move',
    items: '> :not(.add)',
    stop: function(event, ui) {
      var columnId = ui.item.data('columnid');
      var newElement = '<article class="add">'+
          '<form>'+
          '<input type="hidden" name="columnid" value='+columnId+'></input>'+
          '<input type="hidden" name="index" value="1"></input>'+
          '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
          '<input type="submit" style="visibility:hidden;"></input>'+
          '</form>'+
          '</article>'
      if(ui.item.next().hasClass('add')) {
        $(ui.item).before(newElement);
      }
      else {
        $(ui.item).after(newElement);
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