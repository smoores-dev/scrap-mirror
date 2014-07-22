$(document).ready(function() {

  $('.column.normal').sortable({
    revert: true,
    connectWith: '.column.normal',
    cursor: 'move',
    items: '> :not(.add)'
  });

  $('column.normal').on('mousedown',function() {
    console.log("Clicked down");
    $(this).next().remove();
  }).on('mouseup', function() {
    console.log("Unclick");
    columnId = $(this).data('columnid')
    $(this).after('<article class="add">'+
      '<form>'+
      '<input type="hidden" name="columnid" value='+columnId+'></input>'+
      '<input type="hidden" name="index" value="1"></input>'+
      '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
      '<input type="submit" style="visibility:hidden;"></input>'+
      '</form>'+
      '</article>')
  });

})