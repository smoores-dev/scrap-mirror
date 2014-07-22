$ ->  
  socket = io.connect()
  
  socket.on 'newSpace', (data) ->
    space = data.space

  socket.on 'reorderSpace', (data) ->
    columnSorting = data.columnSorting

  socket.on 'newColumn', (data) ->
    column = data.column

  socket.on 'reorderColumn', (data) ->
    columnId = data.columnId
    elementSorting = data.elementSorting

  socket.on 'newElement', (data) ->
    element = data.element
    content = element.content
    index = data.index
    columnId = element.ColumnId

    newArticle = '<article class="text"><p>' + content + '</p><div class="background"></div></article>'
    column = $('section.column.normal[data-columnid=' + columnId + ']')
    articles = $('article:not(.add)', column)

    # clear the textbox
    textboxForm = $(articles[index - 1]).next()
    $('input[name=content]', textboxForm).val('')

    # add the new article and textbox
    $(articles[index - 1]).after(newArticle).after(getAddBox(columnId))
    newTextboxForm = $(articles[index - 1]).next()
    $('form', newTextboxForm).submit(emitNewElement(socket))

  socket.on 'removeElement', (data) ->
    element = data.element

  socket.on 'moveElement', (data) ->
    oldColumn = data.oldColumn 
    newColumn = data.newColumn
    newIndex = data.newIndex
    elementId = data.elementId

  getAddBox = (columnId) ->
    return '<article class="add">'+
        '<form>'+
        '<input class="add" type="text" name="content" placeholder="Add something new"></input>'+
        '<input type="submit" style="visibility:hidden;"></input>'+
        '</form>'+
        '</article>'