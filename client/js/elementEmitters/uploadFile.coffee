$ ->
  currentMousePos =
    x: 0
    y: 0
  storedMouse = 
    x: currentMousePos.x
    y: currentMousePos.y

  $(document).mousemove (event) ->
      currentMousePos.x = event.clientX;
      currentMousePos.y = event.clientY;

  socket = io.connect()
  $('.direct-upload').each () ->

    # For each file selected, process and upload 
    form = $(this)
    contentType = null
    $(this).fileupload {
      url: form.attr('action') # Grabs form's action src
      type: 'POST'
      autoUpload: true
      dataType: 'xml' # S3's XML response
      add:  (event, data) ->
        storedMouse = 
          x: currentMousePos.x
          y: currentMousePos.y        
        $.ajax {
          url: "/sign_s3"
          type: 'GET'
          dataType: 'json'
          data: {title: data.files[0].name} # Send filename to /signed for the signed response 
          async: false
          success: (data) ->
            # Now that we have our data, we update the form so it contains all
            # the needed data to sign the request
            contentType = data.contentType.split('/')[0]

            form.find('input[name=key]').val data.key
            form.find('input[name=policy]').val data.policy
            form.find('input[name=signature]').val data.signature
            form.find('input[name=Content-Type]').val data.contentType
        }
        data.submit()

      # send: (e, data) ->
      #   $('.progress').fadeIn(); # Display widget progress bar

      progress: (e, data)->
        percent = Math.round((e.loaded / e.total) * 100)
        console.log 'progress', percent

      fail: (e, data) ->
        console.log 'fail', data
        # $('#circle').removeClass('animate');

      success: (data) ->
        content = $(data).find('Location').text(); # Find location value from XML response
        console.log 'success', content, contentType
        window.maxZ += 1
        z = window.maxZ
        screenScale = $('.content').css('scale')
        scale = 1/ screenScale
        x = Math.floor((storedMouse.x - $('.content').offset().left) / screenScale)
        y = Math.floor((storedMouse.y - $('.content').offset().top) / screenScale)
        x = Math.floor(x - (150 * scale))
        # console.log x , y
        socket.emit 'newElement', { contentType, content, x, y, z, scale, '' }


        # $('.share-url').show(); # Show input
        # $('.share-url').val(url.replace("%2F", "/")); # Update the input with url address 

      # done: (event, data) ->
      #   console.log 'done', data
        # When upload is done, fade out progress bar and reset to 0
        # $('.progress').fadeOut 300, () ->
        #   $('.bar').css 'width', 0

        # Stop circle animation
        # $('#circle').removeClass 'animate'
    }
