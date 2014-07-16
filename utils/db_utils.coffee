models = require '../models'
async = require 'async'

randomLatin = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eros massa, pellentesque at ipsum in, congue rutrum dolor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed ac metus neque. Suspendisse scelerisque tristique nulla a tempor. Pellentesque sollicitudin gravida commodo. Quisque eu egestas sapien. Etiam libero orci, volutpat sed lectus at, accumsan tempus ante. Vivamus consequat sagittis posuere. Pellentesque vitae porttitor odio. Nam eu enim eu lacus varius iaculis sit amet sed est. Cras sit amet faucibus sapien."
  "Pellentesque nec aliquet erat. Vestibulum vitae odio sit amet sapien interdum adipiscing a pulvinar augue. In et mi velit. Nam venenatis aliquet elit, sit amet dictum tellus tristique et. Sed rutrum tortor eget lorem facilisis mattis. Vestibulum ultrices dignissim justo et bibendum. Sed id quam non odio volutpat fermentum eu sed neque. Ut malesuada suscipit viverra. In hac habitasse platea dictumst. Morbi ut vulputate odio."
  "Vestibulum sollicitudin lacus eget interdum porta. Praesent vel tellus ipsum. Nunc eget adipiscing lorem. Pellentesque et orci eu velit auctor rutrum. Praesent sodales dictum libero sit amet mollis. Suspendisse sed viverra ipsum. Nulla lacinia, lacus nec suscipit interdum, sapien nulla aliquet nibh, at mollis leo turpis eu odio. Aenean quam erat, pulvinar ac elementum et, faucibus at odio. Nam elementum ligula sit amet gravida imperdiet. Nam pellentesque elementum nunc, at molestie magna aliquam nec. Vivamus pharetra egestas odio sit amet pretium. Nulla risus est, dictum eu auctor fermentum, euismod quis ante."
  "Nulla tincidunt rhoncus urna nec pellentesque. Vestibulum quis eros libero. Fusce vehicula velit mi, eget congue arcu viverra sed. Quisque arcu dolor, egestas ac justo vitae, dignissim tincidunt nibh. Etiam id dolor mollis, bibendum elit ac, aliquet leo. Morbi faucibus lectus sit amet fringilla auctor. In justo felis, tempus ac tincidunt quis, interdum quis metus. Curabitur id nisl et lacus lacinia cursus. Nullam sed accumsan nunc. Integer dignissim cursus commodo. Donec gravida neque nec augue hendrerit, eu malesuada diam fermentum. Integer adipiscing hendrerit turpis, sed lacinia enim lacinia sit amet. Praesent felis nisl, hendrerit vel elit ac, elementum blandit ipsum. Morbi vel ligula ipsum."
  "Quisque accumsan lacus eu est pretium ullamcorper. Cras et odio lectus. Vivamus hendrerit pharetra mauris, id pharetra leo tincidunt et. Phasellus massa purus, venenatis at porttitor dignissim, sollicitudin eu nunc. Praesent vel quam nulla. Aenean ornare erat erat, eget rhoncus mauris posuere sed. Vestibulum posuere convallis risus. Nulla sit amet rutrum nisi, eu eleifend sapien. Sed sit amet condimentum risus, et venenatis lorem. Proin pulvinar metus massa, accumsan bibendum lacus convallis eu."
]

exports.populate = (callback) ->
  #MODIFY THIS
  elemsPerColumn = [2,5,2]

  models.sequelize.sync({ force: true }).complete (err) ->
    return callback err if err?
    models.Space.create({ 'Test Space' }).complete (err, space) ->
      return callback err if err?
      createColumns elemsPerColumn.length, (err) ->
        return callback err if err?
        c = 0
        async.each elemsPerColumn, ((el,cb) -> populateColumn(c, elemsPerColumn[c++], cb)), (err)->
          return callback err if err?
          columnSorting = []
          for i,j in elemsPerColumn
            columnSorting.push (j+1)
          space.updateAttributes( { columnSorting} ).complete (err) ->
            return callback err if err?
            callback null
          

createColumns = (n, callback) ->
  async.whilst (() -> return ((n--) > 0)),
   ((cb) -> models.Column.create({SpaceId:1}).complete cb), callback

populateColumn = (ColumnId, n, callback) ->
  contentType = 'text'
  content = randomLatin[Math.floor(Math.random() * randomLatin.length)]
  elements = []

  createElement = (cb) ->
    models.Element.create({ contentType, content, ColumnId }).complete (err, element) ->
      return cb err if err?
      elements.push element.id
      cb null
  
  done = (err) ->
    return callback err if err?
    models.Column.find(where: { id: (ColumnId+1) } ).complete (err, column) ->
      return callback err if err?
      column.updateAttributes( { elementSorting: elements } ).complete (err) ->
        return callback err if err?
        callback null
    
  async.whilst (() -> return ((n--) > 0)), createElement, done