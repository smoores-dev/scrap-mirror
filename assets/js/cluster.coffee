idToClusters = {}

clusterToIds = {}

getIdsInCluster = (id) ->
  clusterToIds[idToClusters[id]] or []

cluster = () ->
  leaves = (hcluster) ->
   # flatten cluster hierarchy
    if(!hcluster.left)
      [hcluster]
    else
      leaves(hcluster.left).concat(leaves(hcluster.right))

  getCoords = () ->
    porportionOFScreen = (e) ->
      elemWidth = e.w * $('.content').css('scale')
      screenWidth = window.innerWidth
      # console.log screenWidth, elemWidth, $('.content').css('scale')
      elemWidth / screenWidth
    $('.content').children().get().map((elem)->
      try
        elem = $(elem)
        offset = elem.offset()
        dimens = dimension elem
        id = Math.floor(parseInt(elem.attr('id')))
        x = Math.floor(parseInt(elem.css('left')))
        y = Math.floor(parseInt(elem.css('top')))
        w = Math.floor(dimens.w)
        h = Math.floor(dimens.h)

        elem = { id, x, y, w, h }
        if porportionOFScreen(elem) > .15
          $('#'+elem.id).css('background-color', "#FFFFFF");
          null
        else
          { id, x, y, w, h }


      catch
        null).filter((elem) -> !!elem)

  worker = {} #new Worker("./hcluster-worker.js");
  
  intersect = (a, b) ->
    offset = 100
    maxAx = a.x + a.w + offset
    maxAy = a.y + a.h + offset

    maxBx = b.x + b.w + offset
    maxBy = b.y + b.h + offset

    minAx = a.x - offset
    minAy = a.y - offset

    minBx = b.x - offset
    minBy = b.y - offset

    aLeftOfB  = maxAx < minBx;
    aRightOfB = minAx > maxBx;
    aAboveB   = minAy > maxBy;
    aBelowB   = maxAy < minBy;
    # console.log !( aLeftOfB || aRightOfB || aAboveB || aBelowB );
    return !( aLeftOfB || aRightOfB || aAboveB || aBelowB );


  compare = (e1, e2) ->
    screenScale = $('.content').css('scale')
    Math.sqrt(Math.pow( (e1.x - e2.x) * screenScale, 2) + Math.pow(e1.y * screenScale - e2.y * screenScale, 2))
    if intersect e1, e2 then 0 else Infinity

  worker.onmessage = (event) ->
    clusters = event.data.clusters.map((hcluster) ->
      leaves(hcluster).map((leaf) -> leaf.value))
    try
      colorClusters clusters
  
  colorClusters = (clusters) ->
    idToClusters = {}
    clusterToIds = {}
    cid = 0
    for clust in clusters
      if clust.length > 1
        color = "#" + Math.random().toString(16).slice(2, 8)
      else 
        color = "#FFFFFF"
      avg = { x: 0, y: 0 }
      l = clust.length
      clusterToIds[cid] = []
      for elem in clust
        clusterToIds[cid].push(elem.id)
        idToClusters[elem.id] = cid
        $('#'+elem.id).css('background-color', color);
        avg.x += elem.x
        avg.y += elem.y

      # avg = { x: avg.x / l, y: avg.y / l }
      # for elem in clust
      #   diffX = -(elem.x - avg.x)/1.5
      #   diffY = -(elem.y - avg.y)/1.5
      #   $('#'+elem.id).css('transform','translate('+diffX+'px,'+diffY+'px)')
        
      cid += 1
        
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
    # linkage = {
    #   "single" : {link: 'single', thresh: 7},
    #   "complete": {link: 'complete', thresh: 125},
    #   "average": {link: 'average', thresh: 40}
    # }['average']
    clusterfck.hcluster coords, compare, 'single', 60

  onmessage({data : {
    coords: getCoords(),
    frameRate: 1000
  }})
  # worker.postMessage('hello world')
