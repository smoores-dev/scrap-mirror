$ ->

  socket = io.connect()

  $('.column.normal').sortable(
    revert: true
    connectWith: '.column.normal'
    cursor: 'move'
    items: '> :not(.add)'
    stop: (event, ui) ->
      newElement = 
        '<article class="add">'+
        '<form>'+
        '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
        '<input type="submit" style="visibility:hidden;"></input>'+
        '</form>'+
        '</article>'
      if ui.item.next().hasClass 'add'
        $(ui.item).before(newElement)
        $form = $ 'form', $(ui.item).prev()
        $form.submit emitNewElement(socket)
      else
        $(ui.item).after(newElement)
        $form = $ 'form', $(ui.item).next()
        $form.submit emitNewElement(socket)
  )

  $('.column.normal > article:not(.add)').on 'mousedown', ->
    $(this).on 'mousemove', ->
      $(this).next().remove()
      $(this).off 'mousemove'