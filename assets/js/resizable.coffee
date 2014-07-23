$ ->
  originalArea = 0
  originalFontSize = 0
  $('article.text').resizable(
    autoHide: true
    handles: 'all'
    start: (event, ui) ->
      originalArea = ui.originalSize.width * ui.originalSize.height
      originalFontSize = parseInt($('p', ui.originalElement).css('font-size'))

    resize: (event, ui) ->
      area = ui.size.width * ui.size.height
      ratio = area / originalArea
      $('p', ui.element).css("font-size": originalFontSize * ratio)
  )