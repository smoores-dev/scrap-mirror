$ ->

  # oldElementScale = 0
  # $('article').resizable(
#     autoHide: true
#     handles: 'all'
#     aspectRatio: true
#     start: (event, ui) ->
#       # $(window).off 'mousemove'
#       click.x = event.clientX
#       click.y = event.clientY
#       oldElementScale = elementScale(ui.element)

#     resize: (event, ui) ->
#       screenScale = currScale()

#       deltaX = (event.clientX - click.x) / screenScale
#       deltaY = (event.clientY - click.y) / screenScale

#       click.x = event.clientX
#       click.y = event.clientY

#       scaleX = deltaX / (ui.originalSize.width * oldElementScale)
#       scaleY = deltaY / (ui.originalSize.height * oldElementScale)


#       ui.element.css("-webkit-transform": "scale(#{+oldElementScale + scaleX + scaleY})")
#       ui.size.width = ui.size.width
#       ui.size.height = ui.size.height
#   )

  $('.ui-resizable-handle').on 'mousedown', (event) ->
    event.stopPropagation()
    element = $(this).parent()
    click.x = event.clientX
    click.y = event.clientY

    $(window).on 'mousemove', (event) ->
      oldElementScale = elementScale(element)
      screenScale = currScale()

      deltaX = (event.clientX - click.x) / screenScale
      deltaY = (event.clientY - click.y) / screenScale

      click.x = event.clientX
      click.y = event.clientY

      scaleX = deltaX / (element.width() * oldElementScale)
      scaleY = deltaY / (element.height() * oldElementScale)

      element.css("-webkit-transform": "scale(#{+oldElementScale + scaleX + scaleY})")






