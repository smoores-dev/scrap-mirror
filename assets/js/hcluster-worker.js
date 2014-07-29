importScripts('clusterfck.js');


postMessage("I\'m working before postMessage(\'ali\').");
onmessage = function(event) {
  var data = event.data;
  var t1 = Date.now();
  var clusters = clusterColors(data.colors, data.frameRate, data.linkage);
  var t2 = Date.now();
  this.postMessage({clusters: clusters, time: t2 - t1});
};

function clusterColors(colors, frameRate, linkage) {
  var linkage = {
   "single" : {link: 'single', thresh: 7},
   "complete": {link: 'complete', thresh: 125},
   "average": {link: 'average', thresh: 60}
  }[linkage];

  var clusters = clusterfck.hcluster(colors, "euclidean", linkage.link,
    linkage.thresh, frameRate, function(clusters) {
      postMessage({clusters: clusters});
  });
  return clusters;
}
// onmessage = (event) ->
//   data = event.data
//   t1 = Date.now()
//   clusters = clusterColors(data.colors, data.frameRate, data.linkage)
//   t2 = Date.now()
//   this.postMessage({clusters: clusters, time: t2 - t1})


// clusterColors = (colors, frameRate, linkage) ->
//   linkage = {
//    "single" : {link: 'single', thresh: 7},
//    "complete": {link: 'complete', thresh: 125},
//    "average": {link: 'average', thresh: 60}
//   }[linkage]
//   clusters = clusterfck.hcluster(colors, "euclidean", linkage.link,
//     linkage.thresh, frameRate, (clusters) ->
//       postMessage({clusters: clusters}))
//   clusters