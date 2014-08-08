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
      elemWidth / screenWidth
    $('.content').children().get().map((elem)->
      try
        $elem = $(elem)
        offset = $elem.offset()
        dimens = dimension $elem
        elem =
          id: Math.floor(parseInt($elem.attr('id')))
          x: Math.floor(parseInt($elem.css('left')))
          y: Math.floor(parseInt($elem.css('top')))
          w: Math.floor(dimens.w)
          h: Math.floor(dimens.h)
          tooBig: false

        if porportionOFScreen(elem) > .10
          elem.tooBig = true
        elem
      catch
        null).filter((elem) -> !!elem)

  worker = {}
  
  intersect = (a, b) ->
    screenScale = $('.content').css('scale')
    offset = 10 / screenScale
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
    return !( aLeftOfB || aRightOfB || aAboveB || aBelowB );


  compare = (e1, e2) ->
    if e1.tooBig || e2.tooBig
      return Infinity
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
        color = "rgba(255,255,255,.925)"
      avg = { x: 0, y: 0 }
      l = clust.length
      clusterToIds[cid] = []
      for elem in clust
        clusterToIds[cid].push(elem.id)
        idToClusters[elem.id] = cid
        $('.card','#'+elem.id).css('border-color', color);
        avg.x += elem.x
        avg.y += elem.y
        
      cid += 1

  onmessage = (event) ->
    data = event.data
    t1 = Date.now()
    clusters = clusterElems(data.coords, data.frameRate, data.linkage)
    t2 = Date.now()
    worker.onmessage(data: {clusters: clusters, time: t2 - t1})


  clusterElems = (coords, frameRate, linkage) ->
    clusterfck.hcluster coords, compare, 'single', 60

  onmessage({data : {
    coords: getCoords(),
    frameRate: 1000
  }})
