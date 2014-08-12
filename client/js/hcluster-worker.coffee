importScripts 'clusterfck.js'

onmessage = (event) ->
  data = event.data
  t1 = Date.now()
  clusters = clusterColors data.colors, data.frameRate, data.linkage
  t2 = Date.now()
  this.postMessage {clusters: clusters, time: t2 - t1}

clusterColors = (colors, frameRate, linkage) ->
  linkageValue = switch linkage
    when "single" then {link: 'single', thresh: 7}
    when "complete" then {link: 'complete', thresh: 125}
    when "average" then {link: 'average', thresh: 60}
    else "fuck you"

  clusters = clusterfck.hcluster colors, "euclidean", linkageValue.link,
    linkageValue.thresh, frameRate, (clusters) ->
      postMessage { clusters }
