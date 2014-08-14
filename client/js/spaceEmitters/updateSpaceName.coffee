$ ->

  socket = io.connect()

  # updating a space name
  $('.name').on 'dblclick', (event) ->
    editing = !!$('.edit-name', this).length
    event.stopPropagation()
    if not editing
      parent = $(this).parent()
      oldName = $(this).html()
      $(this).text('')

      formEl = "<form class='edit-name'><input type='text' name='name' value='#{oldName}'><input style='visibility:hidden' type='submit'></form>"
      $(this).append(formEl)
      $('input[name="name"]').focus()
        .on 'blur', (event) ->
          $(this).parent().remove()
          $('.name').text(oldName)
      $('.edit-name').css(
          'z-index':2
          position: 'fixed'
          top: "#{$(this).offset().top}px"
          left: "#{$(this).offset().left}px")
      
      $('.edit-name').submit (event) ->
        event.preventDefault()
        newName = $('input[name="name"]').val()
        $(this).remove()
        socket.emit 'updateSpace', { name : newName }
