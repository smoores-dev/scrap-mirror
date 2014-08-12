models = require '../models'
async = require 'async'

randomLatin = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eros massa, pellentesque at ipsum in, congue rutrum dolor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed ac metus neque. Suspendisse scelerisque tristique nulla a tempor. Pellentesque sollicitudin gravida commodo. Quisque eu egestas sapien. Etiam libero orci, volutpat sed lectus at, accumsan tempus ante. Vivamus consequat sagittis posuere. Pellentesque vitae porttitor odio. Nam eu enim eu lacus varius iaculis sit amet sed est. Cras sit amet faucibus sapien."
  "Pellentesque nec aliquet erat. Vestibulum vitae odio sit amet sapien interdum adipiscing a pulvinar augue. In et mi velit. Nam venenatis aliquet elit, sit amet dictum tellus tristique et. Sed rutrum tortor eget lorem facilisis mattis. Vestibulum ultrices dignissim justo et bibendum. Sed id quam non odio volutpat fermentum eu sed neque. Ut malesuada suscipit viverra. In hac habitasse platea dictumst. Morbi ut vulputate odio."
  "Vestibulum sollicitudin lacus eget interdum porta. Praesent vel tellus ipsum. Nunc eget adipiscing lorem. Pellentesque et orci eu velit auctor rutrum. Praesent sodales dictum libero sit amet mollis. Suspendisse sed viverra ipsum. Nulla lacinia, lacus nec suscipit interdum, sapien nulla aliquet nibh, at mollis leo turpis eu odio. Aenean quam erat, pulvinar ac elementum et, faucibus at odio. Nam elementum ligula sit amet gravida imperdiet. Nam pellentesque elementum nunc, at molestie magna aliquam nec. Vivamus pharetra egestas odio sit amet pretium. Nulla risus est, dictum eu auctor fermentum, euismod quis ante."
  "Nulla tincidunt rhoncus urna nec pellentesque. Vestibulum quis eros libero. Fusce vehicula velit mi, eget congue arcu viverra sed. Quisque arcu dolor, egestas ac justo vitae, dignissim tincidunt nibh. Etiam id dolor mollis, bibendum elit ac, aliquet leo. Morbi faucibus lectus sit amet fringilla auctor. In justo felis, tempus ac tincidunt quis, interdum quis metus. Curabitur id nisl et lacus lacinia cursus. Nullam sed accumsan nunc. Integer dignissim cursus commodo. Donec gravida neque nec augue hendrerit, eu malesuada diam fermentum. Integer adipiscing hendrerit turpis, sed lacinia enim lacinia sit amet. Praesent felis nisl, hendrerit vel elit ac, elementum blandit ipsum. Morbi vel ligula ipsum."
  "Quisque accumsan lacus eu est pretium ullamcorper. Cras et odio lectus. Vivamus hendrerit pharetra mauris, id pharetra leo tincidunt et."
]

randomImage = [
  "http://www.menucool.com/slider/prod/image-slider-5.jpg"
  "http://www.menucool.com/slider/prod/image-slider-4.jpg"
  "http://cdn1.yourstory.com/wp-content/uploads/2014/04/Image-1.jpg"
  "http://emarketingblogger.com/wp-content/uploads/2014/04/image-marketing-sites.jpg"
  "http://wowslider.com/images/demo/box-stack-v/data1/images/train.jpg"
  "https://disney-animation.s3.amazonaws.com/uploads/production/project_image/frozen/72/image/project_image.jpg"
]

n = 15
m = randomImage.length
maxX = 5000
maxY = 2000
maxS = 5
minS = 0.2
z = 0;

randInt = (n) -> Math.floor(Math.random()*n)

exports.populate = (callback) ->
  models.sequelize.sync({ force: true }).complete (err) ->
    return callback err if err?
    models.User.create(
      name: "Test User"
      email: "test@test.test"
      password: "password"
    ).complete (err, user) ->
      return callback err if err?
      models.Space.create(
        name: 'Test Space'
        spaceKey: '12345a'
      ).complete (err, space) ->
        return callback err if err?
        space.setCreator(user).complete (err) ->
          return callback err if err?
          space.addUser(user).complete (err) ->
            return callback err if err?
            async.whilst (() -> n > 0), createTextElement, (err) ->
              return callback err if err?
              async.whilst (() -> m > 0), createImageElement, (err) ->
                return callback err if err?
                callback null

createTextElement = (cb) ->
  options =
    contentType : 'text'
    content : randomLatin[randInt(randomLatin.length)]
    x : randInt(maxX)
    y : randInt(maxY)
    z : (z++)
    scale : (Math.random() * (maxS - minS)) + minS
    SpaceId : 1

  models.Element.create(options).complete (err, element) ->
    return cb err if err?
    n--
    cb null

createImageElement = (cb) ->
  options =
    contentType : 'image'
    content : randomImage[m - 1]
    caption : randomLatin[randInt(randomLatin.length)].slice(0, 80)
    x : randInt(maxX)
    y : randInt(maxY)
    z : (z++)
    scale : (Math.random() * (maxS - minS)) + minS
    SpaceId : 1

  models.Element.create(options).complete (err, element) ->
    return cb err if err?
    m--
    cb null
