$(document).ready(function() {

  $('.column.normal').sortable({
    revert: true,
    connectWith: '.column.normal',
    cursor: 'move',
    items: '> :not(.add)'
  });

})