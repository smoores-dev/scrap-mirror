totalDelta =
  x: 0
  y: 0

matrixToArray = (str) ->
  str.match(/(-?[0-9\.]+)/g)

currScale = -> matrixToArray($('section.content').css('-webkit-transform'))[0]

elementScale = (element) -> matrixToArray(element.css('-webkit-transform'))[0]

click = {}
startPosition = {}

resize = (socket) ->
  (event) ->
    event.stopPropagation()
    element = $(this).parent()
    clickX = event.clientX
    clickY = event.clientY
    screenScale = currScale()

    $(window).on 'mouseup', (event) ->
      socket.emit 'updateElement', { elementId: element.attr('id'), scale: elementScale(element) }

    $(window).on 'mousemove', (event) ->
      event.preventDefault()
      oldElementScale = elementScale(element)

      deltaX = (event.clientX - clickX) / screenScale
      deltaY = (event.clientY - clickY) / screenScale

      delta = Math.sqrt(deltaX*deltaX + deltaY*deltaY)

      clickX = event.clientX
      clickY = event.clientY

      newScale = delta / Math.sqrt(element.width()*element.width() + element.height() * element.height())

      newScale *= -1 if deltaX < 0 || deltaY < 0

      element.css("-webkit-transform": "scale(#{+oldElementScale + newScale})")

draggableOptions = (socket) ->
  start: (event, ui) ->
    $(window).off 'mousemove'
    click.x = event.clientX
    click.y = event.clientY

    highestZ += 1
    z = highestZ
    $(this).zIndex z

    startPosition.left = ui.position.left
    startPosition.top = ui.position.top 

  drag: (event, ui) ->
    s = elementScale(ui.helper)
    ui.position =
      left: (event.clientX - click.x + startPosition.left) / (currScale())
      top: (event.clientY - click.y + startPosition.top) / (currScale())

  stop: (event, ui) ->
    xString = $(this).css('left')
    #remove the 'px' from the end of the string
    x = Math.floor(xString.slice(0,xString.length - 2) - totalDelta.x)
    yString = $(this).css('top')
    y = Math.floor(yString.slice(0,yString.length - 2) - totalDelta.y)
    z = highestZ
    elementId = this.id
    
    socket.emit('updateElement', { x, y, z, elementId })
    # cluster()


leaves = (hcluster) ->
   # flatten cluster hierarchy
   if(!hcluster.left)
     [hcluster];
   else
     this.leaves(hcluster.left).concat(this.leaves(hcluster.right));

dimension = (elem) ->
  scale = currScale()
  elemScale = elementScale elem
  w = parseInt(elem.css('width')) * scale * elemScale
  h = parseInt(elem.css('height')) * scale * elemScale
  {w, h}

cluster = () ->
  # console.log 'clsuer'
  coords = $('.content').children().get().map((elem)->
    try
      elem = $(elem)
      offset = elem.offset()
      dimens = dimension elem
      # console.log offset, dimens
      x = Math.floor(offset.left + dimens.w/2)
      y = Math.floor(offset.top + dimens.h/2)
      id = parseInt(elem.attr('id'))
      # console.log(x,y, id)
      {x, id, y}
    catch
      null).filter((elem) -> !!elem)

  worker = {} #new Worker("./hcluster-worker.js");
  
  compare = (e1, e2) ->
    Math.sqrt(Math.pow(e1.x - e2.x, 2) + Math.pow(e1.y - e2.y, 2))

  worker.onmessage = (event) ->
    # console.log 'hello from worker'
    clusters = event.data.clusters.map((hcluster) ->
      leaves(hcluster).map((leaf) -> leaf.value))
    # console.log 'message', clusters
    try
      colorClusters clusters
      
      

  colorClusters = (clusters) ->
    for clust in clusters
      color = "#" + Math.random().toString(16).slice(2, 8)
      avg = { x: 0, y: 0 }
      l = clust.length
      for elem in clust
        avg.x += elem.x
        avg.y += elem.y


      avg = { x: avg.x // l, y: avg.y // l }
      foo = "<div style='width:10px;height:10px;top:#{avg.y}px;left:#{avg.x}px;background-color:red;position:relative'></div>"
      $('content').append(foo)
      # console.log 'avg:',avg
      
      for elem in clust
        left = elem.x + (elem.x - avg.x)/4
        top  = elem.y + (elem.y - avg.y)/4
        # console.log diffX,diffY
        # $('#'+elem.id).css('transform','translate('+diffX+'px,'+diffY+'px)')
        # $('#'+elem.id).animate({ top, left })
        $('#'+elem.id).css('background-color', color);
        # console.log $('#'+elem.id)
        

    

  # worker.onerror = (event) ->
  #   console.log("Worker thread error: " + event.message + " " + event.filename + " " + event.lineno)
  onmessage = (event) ->
    data = event.data
    t1 = Date.now()
    clusters = clusterElems(data.colors, data.frameRate, data.linkage)
    t2 = Date.now()
    worker.onmessage(data: {clusters: clusters, time: t2 - t1})
   # this.postMessage({clusters: clusters, time: t2 - t1})


  clusterElems = (colors, frameRate, linkage) ->
    linkage = {
      "single" : {link: 'single', thresh: 7},
      "complete": {link: 'complete', thresh: 125},
      "average": {link: 'average', thresh: 120}
    }['average']
    clusters = clusterfck.hcluster(colors, compare, linkage.link,
      linkage.thresh, frameRate, (clusters) ->
        # postMessage({clusters: clusters}))
        # worker.onmessage({data:{clusters: clusters}})
        )
    clusters

  onmessage({data : {
    colors: coords,
    frameRate: 1000
  }})
  # worker.postMessage('hello world')
