cluster = () ->
  leaves = (hcluster) ->
   # flatten cluster hierarchy
    if(!hcluster.left)
      [hcluster]
    else
      leaves(hcluster.left).concat(leaves(hcluster.right))

  getCoords = () ->
    $('.content').children().get().map((elem)->
      try
        elem = $(elem)
        offset = elem.offset()
        dimens = dimension elem
        x = Math.floor(parseInt(elem.css('left')) + dimens.w/2)
        y = Math.floor(parseInt(elem.css('top')) + dimens.h/2)
        id = parseInt(elem.attr('id'))
        {x, id, y}
      catch
        null).filter((elem) -> !!elem)

  worker = {} #new Worker("./hcluster-worker.js");
  
  compare = (e1, e2) ->
    Math.sqrt(Math.pow(e1.x * currScale() - e2.x * currScale(), 2) + Math.pow(e1.y * currScale() - e2.y * currScale(), 2))

  worker.onmessage = (event) ->
    clusters = event.data.clusters.map((hcluster) ->
      leaves(hcluster).map((leaf) -> leaf.value))
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

      avg = { x: avg.x / l, y: avg.y / l }
      for elem in clust
        diffX = -(elem.x - avg.x)/1.5
        diffY = -(elem.y - avg.y)/1.5
        # $('#'+elem.id).css('transform','translate('+diffX+'px,'+diffY+'px)')
        # $('#'+elem.id).css('background-color', color);
        
  # worker.onerror = (event) ->
  #   console.log("Worker thread error: " + event.message + " " + event.filename + " " + event.lineno)
  onmessage = (event) ->
    data = event.data
    t1 = Date.now()
    clusters = clusterElems(data.coords, data.frameRate, data.linkage)
    t2 = Date.now()
    worker.onmessage(data: {clusters: clusters, time: t2 - t1})
   # this.postMessage({clusters: clusters, time: t2 - t1})


  clusterElems = (coords, frameRate, linkage) ->
    linkage = {
      "single" : {link: 'single', thresh: 7},
      "complete": {link: 'complete', thresh: 125},
      "average": {link: 'average', thresh: 120}
    }['average']
    clusterfck.hcluster coords, compare, linkage.link, linkage.thresh, frameRate

  onmessage({data : {
    coords: getCoords(),
    frameRate: 1000
  }})
  # worker.postMessage('hello world')
