$ ->

  $('.column.normal').sortable(
    revert: true
    connectWith: '.column.normal'
    cursor: 'move'
    items: '> :not(.add)'
    stop: (event, ui) ->
      columnId = ui.item.data 'columnid'
      newElement = 
        '<article class="add">'+
        '<form>'+
        '<input type="hidden" name="columnid" value='+columnId+'></input>'+
        '<input type="hidden" name="index" value="1"></input>'+
        '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
        '<input type="submit" style="visibility:hidden;"></input>'+
        '</form>'+
        '</article>'
      if ui.item.next().hasClass 'add'
        $(ui.item).before(newElement)
      else
        $(ui.item).after(newElement)
  )

  $('.column.normal > article:not(.add)').on 'mousedown', ->
    $(this).on 'mousemove', ->
      $(this).next().remove()
      $(this).off 'mousemove'